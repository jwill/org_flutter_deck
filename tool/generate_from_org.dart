import 'dart:io';

void main(List<String> args) {
  final showAllBullets = args.contains('--show-all-bullets');
  final transitionIndex = args.indexOf('--transition');
  var transition = 'none';
  if (transitionIndex != -1 && transitionIndex + 1 < args.length) {
    transition = args[transitionIndex + 1];
  }
  final orgFile = File('demo-slide-deck.org');
  final lines = orgFile.readAsLinesSync();

  final slides = <Map<String, dynamic>>[];
  Map<String, dynamic>? currentSlide;
  var inCodeBlock = false;
  var inNotesDrawer = false;
  var inFlutterBlock = false;
  var inQuoteBlock = false;
  var codeBlockContent = '';
  var codeBlockLanguage = '';
  var flutterBlockContent = '';
  var quoteBlockContent = '';
  Map<String, dynamic>? lastBullet;

  for (final line in lines) {
    if (line.startsWith('* ')) {
      if (currentSlide != null) {
        final content = currentSlide['content'] as String;
        final contentLines = content.split('\n').where((l) => l.trim().startsWith('- ')).toList();
        if (contentLines.length > 1) {
          currentSlide['content_steps'] = contentLines.map((l) => l.trim().substring(2)).toList();
          currentSlide['content'] = '';
        }
        slides.add(currentSlide);
      }
      final title = line.substring(2).trim();
      currentSlide = {
        'title': title,
        'content': '',
        'notes': '',
        'hidden': title.contains('COMMENT'),
        'code': null,
        'language': null,
        'flutterWidget': null,
        'imageUri': null,
        'imageWidth': null,
        'imageHeight': null,
        'bullets': <Map<String, dynamic>>[],
        'table': null,
        'quote': null,
        'attribution': null,
      };
      lastBullet = null;
    } else if (line.startsWith('** ') || line.startsWith('*** ')) {
      if (currentSlide != null) {
        final level = line.startsWith('***') ? 3 : 2;
        lastBullet = {
          'title': line.substring(level + 1).trim(),
          'content': '',
          'imageUri': null,
          'imageWidth': null,
          'imageHeight': null,
        };
        (currentSlide['bullets'] as List<Map<String, dynamic>>).add(lastBullet);
      }
    } else if (line.trim().startsWith('|')) {
      if (currentSlide != null) {
        if (currentSlide['table'] == null) {
          currentSlide['table'] = <List<String>>[];
        }
        if (line.trim().startsWith('|-')) {
          continue;
        }
        final cells = line.trim().split('|').where((c) => c.isNotEmpty).map((c) => c.trim()).toList();
        (currentSlide['table'] as List<List<String>>).add(cells);
      }
    } else if (line.startsWith('#+begin_src')) {
      inCodeBlock = true;
      codeBlockLanguage = line.split(' ')[1];
      codeBlockContent = '';
      lastBullet = null;
    } else if (line.startsWith('#+end_src')) {
      inCodeBlock = false;
      if (currentSlide != null) {
        currentSlide['code'] = codeBlockContent;
        currentSlide['language'] = codeBlockLanguage;
      }
    } else if (inCodeBlock) {
      codeBlockContent += '$line\n';
    } else if (line.startsWith('#+BEGIN_FLUTTER')) {
      inFlutterBlock = true;
      flutterBlockContent = '';
    } else if (line.startsWith('#+END_FLUTTER')) {
      inFlutterBlock = false;
      if (currentSlide != null) {
        currentSlide['flutterWidget'] = flutterBlockContent;
      }
    } else if (inFlutterBlock) {
      flutterBlockContent += '$line\n';
    } else if (line.startsWith('#+BEGIN_QUOTE')) {
      inQuoteBlock = true;
      quoteBlockContent = '';
    } else if (line.startsWith('#+END_QUOTE')) {
      inQuoteBlock = false;
      if (currentSlide != null) {
        final quoteLines = quoteBlockContent.trim().split('\n');
        final attribution = quoteLines.last.startsWith('- ')
            ? quoteLines.removeLast().substring(2).trim()
            : '';
        currentSlide['quote'] = quoteLines.join('\n');
        currentSlide['attribution'] = attribution;
      }
    } else if (inQuoteBlock) {
      quoteBlockContent += '$line\n';
    } else if (line.trim() == ':NOTES:') {
      inNotesDrawer = true;
    } else if (line.trim() == ':END:') {
      inNotesDrawer = false;
    } else if (inNotesDrawer) {
      if (currentSlide != null) {
        currentSlide['notes'] = '${currentSlide['notes']}$line\n';
      }
    }
    else if (line.startsWith('#+ATTR_HTML')) {
      final widthRegex = RegExp(r':width\s+(\d+)');
      final heightRegex = RegExp(r':height\s+(\d+)');
      final widthMatch = widthRegex.firstMatch(line);
      final heightMatch = heightRegex.firstMatch(line);
      final target = lastBullet ?? currentSlide;
      if (widthMatch != null) {
        target?['imageWidth'] = double.tryParse(widthMatch.group(1)!);
      }
      if (heightMatch != null) {
        target?['imageHeight'] = double.tryParse(heightMatch.group(1)!);
      }
    } else if (line.startsWith('[[file:') || line.startsWith('[[http')) {
      final uriRegex = RegExp(r'\[\[(.*?)\]\]');
      final match = uriRegex.firstMatch(line);
      final target = lastBullet ?? currentSlide;
      if (match != null) {
        target?['imageUri'] = match.group(1);
      }
    } else if (currentSlide != null && line.isNotEmpty) {
      if (lastBullet != null) {
        lastBullet['content'] = '${lastBullet['content']}$line\n';
      } else {
        currentSlide['content'] =
            '${currentSlide['content']}$line\n';
      }
    }
  }
  if (currentSlide != null) {
    final content = currentSlide['content'] as String;
    final contentLines = content.split('\n').where((l) => l.trim().startsWith('- ')).toList();
    if (contentLines.length > 1) {
      currentSlide['content_steps'] = contentLines.map((l) => l.trim().substring(2)).toList();
      currentSlide['content'] = '';
    }
    slides.add(currentSlide);
  }

  generateSlidesFile(slides, showAllBullets: showAllBullets, transition: transition);
}

String _generateBuildMethod(Map<String, dynamic> slide, {bool showAllBullets = false}) {
  final title = slide['title'] as String;
  final content = slide['content'] as String;
  final code = slide['code'] as String?;
  final language = slide['language'] as String?;
  final flutterWidget = slide['flutterWidget'] as String?;
  final imageUri = slide['imageUri'] as String?;
  final imageWidth = slide['imageWidth'] as double?;
  final imageHeight = slide['imageHeight'] as double?;
  final bullets = slide['bullets'] as List<Map<String, dynamic>>;
  final contentSteps = slide['content_steps'] as List<String>?;
  final table = slide['table'] as List<List<String>>?;
  final quote = slide['quote'] as String?;
  final attribution = slide['attribution'] as String?;

  if (quote != null && attribution != null) {
    return '''
  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.quote(
      quote: """$quote""",
      attribution: """$attribution""",
    );
  }
''';
  }

  if (table != null) {
    final header = table.first;
    final rows = table.skip(1).toList();
    final columns = header.map((cell) => 'DataColumn(label: Text("$cell"))').join(', ');
    final dataRows = <String>[];
    for (final row in rows) {
      final cells = row.map((cell) => 'DataCell(Text("$cell"))').join(', ');
      dataRows.add('DataRow(cells: [$cells])');
    }
    final tableWidget = '''
DataTable(
        columns: [
          $columns
        ],
        rows: [
          ${dataRows.join(',\n')}
        ],
      )
    ''';
    return '''
  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""$title""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            $tableWidget,
          ],
        ),
      ),
    );
  }
''';
  }

  if (flutterWidget != null) {
    return '''
  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""$title""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Expanded(
              child: $flutterWidget,
            ),
          ],
        ),
      ),
    );
  }
''';
  }

  if (imageUri != null) {
    var uri = imageUri;
    var imageWidget = 'Image.asset';
    if (uri.startsWith('http')) {
      imageWidget = 'Image.network';
    } else {
      if (uri.startsWith('file:')) {
        uri = uri.replaceFirst('file:', '');
      }
      uri = 'assets/images/$uri';
    }
    if (content.isNotEmpty) {
      return '''
  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $imageWidget(
              """$uri""",
              width: $imageWidth,
              height: $imageHeight,
            ),
            const SizedBox(width: 16),
            Text("""$content""", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
''';
    }
    return '''
  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.image(
      imageBuilder: (context) => $imageWidget(
        """$uri""",
        width: $imageWidth,
        height: $imageHeight,
      ),
      label: """$title""",
    );
  }
''';
  }

  var contentWidget =
      'Text("""$content""", textAlign: TextAlign.center),';
  if (contentSteps != null && contentSteps.isNotEmpty) {
    final buffer = StringBuffer();
    for (var i = 0; i < contentSteps.length; i++) {
      final stepContent = 'Text("""- ${contentSteps[i]}"""),';
      if (showAllBullets) {
        buffer.writeln(stepContent);
      } else {
        buffer.writeln('if (step > $i) $stepContent');
      }
    }
    final column = '''
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ${buffer.toString()}
        ],
      )
    ''';
    if (showAllBullets) {
      contentWidget = column;
    } else {
      contentWidget = '''
      FlutterDeckSlideStepsBuilder(
        builder: (context, step) {
          return $column;
        },
      )''';
    }
  } else if (bullets.isNotEmpty) {
    final buffer = StringBuffer();
    for (var i = 0; i < bullets.length; i++) {
      final bullet = bullets[i];
      final bulletTitle = bullet['title'] as String;
      final bulletContent = bullet['content'] as String;
      final bulletImageUri = bullet['imageUri'] as String?;
      final bulletImageWidth = bullet['imageWidth'] as double?;
      final bulletImageHeight = bullet['imageHeight'] as double?;

      var imageWidgetStr = '';
      if (bulletImageUri != null) {
        var uri = bulletImageUri;
        var imageWidget = 'Image.asset';
        if (uri.startsWith('http')) {
          imageWidget = 'Image.network';
        } else {
          if (uri.startsWith('file:')) {
            uri = uri.replaceFirst('file:', '');
          }
          uri = 'assets/images/$uri';
        }
        imageWidgetStr = '''
        $imageWidget(
          """$uri""",
          width: $bulletImageWidth,
          height: $bulletImageHeight,
        ),
        ''';
      }

      final bulletWidgetString = '''
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• $bulletTitle", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""$bulletContent""", textAlign: TextAlign.start),
              $imageWidgetStr
            ],
          ),
        )
      ''';

      if (showAllBullets) {
        buffer.writeln('$bulletWidgetString,');
      } else {
        buffer.writeln('if (step > $i) ...[ $bulletWidgetString, ],');
      }
    }

    final column = '''
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ${buffer.toString()}
        ],
      )
    ''';

    if (showAllBullets) {
      contentWidget = '''
      Expanded(
        child: SingleChildScrollView(
          child: $column,
        ),
      )
      ''';
    } else {
      contentWidget = '''
      Expanded(
        child: SingleChildScrollView(
          child: FlutterDeckSlideStepsBuilder(
            builder: (context, step) {
              return $column;
            },
          ),
        ),
      )
      ''';
    }
  } else if (code != null) {
    final codeLines = code.split('\n').length;
    final codeHighlight =
        "FlutterDeckCodeHighlight(code: '''$code''', language: '''$language''', textStyle: GoogleFonts.robotoMono(),)";
    if (codeLines > 10) {
      contentWidget = '''
Expanded(
              child: SingleChildScrollView(
                child: $codeHighlight,
              ),
            )''';
    } else {
      contentWidget = codeHighlight;
    }
  }

  return '''
  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""$title""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            $contentWidget
          ],
        ),
      ),
    );
  }
''';
}


void generateSlidesFile(List<Map<String, dynamic>> slides, {bool showAllBullets = false, String transition = 'none'}) {
  final buffer = StringBuffer();
  buffer.writeln('// ignore_for_file: use_key_in_widget_constructors');
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'package:flutter_deck/flutter_deck.dart';");
  buffer.writeln("import 'package:google_fonts/google_fonts.dart';");
  buffer.writeln("import 'package:flutter_deck_ai/src/painters.dart';");
  
  buffer.writeln();

  for (var i = 0; i < slides.length; i++) {
    final slide = slides[i];
    final title = slide['title'] as String;
    final hidden = slide['hidden'] as bool;
    final notes = slide['notes'] as String;
    final bullets = slide['bullets'] as List<Map<String, dynamic>>;
    final contentSteps = slide['content_steps'] as List<String>? ?? [];
    var stepsCount = contentSteps.isNotEmpty ? contentSteps.length : bullets.length;
    if (showAllBullets) {
      stepsCount = 0;
    }
    final className = 'GeneratedSlide${i + 1}';

    var transitionValue = 'FlutterDeckTransition.none()';
    switch (transition) {
      case 'fade':
        transitionValue = 'FlutterDeckTransition.fade()';
        break;
      case 'slide':
        transitionValue = 'FlutterDeckTransition.slide()';
        break;
      case 'scale':
        transitionValue = 'FlutterDeckTransition.scale()';
        break;
      case 'rotation':
        transitionValue = 'FlutterDeckTransition.rotation()';
        break;
    }

    buffer.writeln('''
class $className extends FlutterDeckSlideWidget {
  const $className()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/$className',
            title: """$title""",
            hidden: $hidden,
            steps: $stepsCount,
            speakerNotes: """$notes""",
            transition: $transitionValue,
          ),
        );

${_generateBuildMethod(slide, showAllBullets: showAllBullets)}
}
''');
  }

  buffer.writeln('const generatedSlides = <FlutterDeckSlideWidget>[');
  for (var i = 0; i < slides.length; i++) {
    buffer.writeln('  GeneratedSlide${i + 1}(),');
  }
  buffer.writeln('];');

  final outputFile = File('lib/generated_slides.dart');
  outputFile.writeAsStringSync(buffer.toString());

  print('Generated lib/generated_slides.dart');
}

