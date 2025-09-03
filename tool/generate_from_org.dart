import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:pub_semver/pub_semver.dart';

void main(List<String> args) {
  final showAllBullets = args.contains('--show-all-bullets');
  final transitionIndex = args.indexOf('--transition');
  var transition = 'none';
  if (transitionIndex != -1 && transitionIndex + 1 < args.length) {
    transition = args[transitionIndex + 1];
  }
  final orgFile = File(args.firstWhere((arg) => arg.endsWith('.org'), orElse: () => 'demo-slide-deck.org'));
  final lines = orgFile.readAsLinesSync();

  String? author;
  final authorLine = lines.firstWhere(
    (line) => line.startsWith('#+author:'),
    orElse: () => '',
  );
  if (authorLine.isNotEmpty) {
    author = authorLine.substring(9).trim();
  }

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
  Map<String, dynamic>? plot;

  for (final line in lines) {
    if (line.startsWith('* ')) {
      if (currentSlide != null) {
        final content = currentSlide['content'] as String;
        final contentLines =
            content.split('\n').where((l) => l.trim().startsWith('- ')).toList();
        if (contentLines.length > 1) {
          currentSlide['content_steps'] =
              contentLines.map((l) => l.trim().substring(2)).toList();
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
        'plot': null,
      };
      lastBullet = null;
      plot = null;
    } else if (line.startsWith('#+PLOT:')) {
      final plotOptions = line.substring(7).trim();
      final titleMatch = RegExp(r'title:"(.*?)"').firstMatch(plotOptions);
      final typeMatch = RegExp(r'type:(.*?)(?:\s|$)').firstMatch(plotOptions);
      final withMatch = RegExp(r'with:(.*?)(?:\s|$)').firstMatch(plotOptions);
      plot = {
        'title': titleMatch?.group(1) ?? '',
        'type': typeMatch?.group(1) ?? '2d',
        'with': withMatch?.group(1) ?? 'lines',
        'data': <List<String>>[],
      };
      if (currentSlide != null) {
        currentSlide['plot'] = plot;
      }
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
      if (plot != null) {
        if (line.trim().startsWith('|-')) {
          continue;
        }
        final cells = line
            .trim()
            .split('|')
            .where((c) => c.isNotEmpty)
            .map((c) => c.trim())
            .toList();
        (plot['data'] as List<List<String>>).add(cells);
      } else if (currentSlide != null) {
        if (currentSlide['table'] == null) {
          currentSlide['table'] = <List<String>>[];
        }
        if (line.trim().startsWith('|-')) {
          continue;
        }
        final cells = line
            .trim()
            .split('|')
            .where((c) => c.isNotEmpty)
            .map((c) => c.trim())
            .toList();
        (currentSlide['table'] as List<List<String>>).add(cells);
      }
    } else if (line.toLowerCase().startsWith('#+begin_src')) {
      inCodeBlock = true;
      codeBlockLanguage = line.split(' ')[1];
      codeBlockContent = '';
      lastBullet = null;
    } else if (line.toLowerCase().startsWith('#+end_src')) {
      inCodeBlock = false;
      if (currentSlide != null) {
        currentSlide['code'] = codeBlockContent;
        currentSlide['language'] = codeBlockLanguage;
      }
    } else if (inCodeBlock) {
      codeBlockContent += '$line\n';
    } else if (line.toLowerCase().startsWith('#+begin_flutter')) {
      inFlutterBlock = true;
      flutterBlockContent = '';
    } else if (line.toLowerCase().startsWith('#+end_flutter')) {
      inFlutterBlock = false;
      if (currentSlide != null) {
        currentSlide['flutterWidget'] = flutterBlockContent;
      }
    } else if (inFlutterBlock) {
      flutterBlockContent += '$line\n';
    } else if (line.toLowerCase().startsWith('#+begin_quote')) {
      inQuoteBlock = true;
      quoteBlockContent = '';
    } else if (line.toLowerCase().startsWith('#+end_quote')) {
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
    } else if (line.startsWith('#+ATTR_HTML')) {
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
        currentSlide['content'] = '${currentSlide['content']}$line\n';
      }
    }
  }
  if (currentSlide != null) {
    final content = currentSlide['content'] as String;
    final contentLines =
        content.split('\n').where((l) => l.trim().startsWith('- ')).toList();
    if (contentLines.length > 1) {
      currentSlide['content_steps'] =
          contentLines.map((l) => l.trim().substring(2)).toList();
      currentSlide['content'] = '';
    }
    slides.add(currentSlide);
  }

  generateSlidesFile(
    slides,
    author: author,
    showAllBullets: showAllBullets,
    transition: transition,
  );
}

Method _generateBuildMethod(Map<String, dynamic> slide,
    {bool showAllBullets = false}) {
  final plot = slide['plot'] as Map<String, dynamic>?;
  if (plot != null) {
    return _generatePlotSlide(slide);
  }

  final quote = slide['quote'] as String?;
  final attribution = slide['attribution'] as String?;

  if (quote != null && attribution != null) {
    return _generateQuoteSlide(slide);
  }

  final table = slide['table'] as List<List<String>>?;

  if (table != null) {
    return _generateTableSlide(slide);
  }

  final flutterWidget = slide['flutterWidget'] as String?;
  if (flutterWidget != null) {
    return _generateFlutterWidgetSlide(slide);
  }

  final imageUri = slide['imageUri'] as String?;
  if (imageUri != null) {
    return _generateImageSlide(slide);
  }

  return _generateContentSlide(slide, showAllBullets: showAllBullets);
}

Method _generatePlotSlide(Map<String, dynamic> slide) {
  final plot = slide['plot'] as Map<String, dynamic>;
  final plotTitle = plot['title'] as String;
  final data = plot['data'] as List<List<String>>;
  final spots = data.skip(1).map((row) {
    final x = double.tryParse(row[0]) ?? 0.0;
    final y = double.tryParse(row[1]) ?? 0.0;
    return refer('FlSpot').newInstance([literalNum(x), literalNum(y)]);
  }).toList();
  final lineChart = refer('LineChart').newInstance([
    refer('LineChartData').newInstance([], {
      'lineBarsData': literalList([
        refer('LineChartBarData').newInstance([], {
          'spots': literalList(spots),
        })
      ]),
    })
  ]);
  return Method((b) => b
    ..name = 'build'
    ..returns = refer('FlutterDeckSlide')
    ..annotations.add(refer('override'))
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'context'
      ..type = refer('BuildContext')))
    ..body = refer('FlutterDeckSlide.blank').call([], {
      'builder': Method((b) => b
        ..requiredParameters.add(Parameter((b) => b..name = 'context'))
        ..body = refer('Center').newInstance([], {
          'child': refer('Column').newInstance([], {
            'mainAxisAlignment':
                refer('MainAxisAlignment.center', 'package:flutter/material.dart'),
            'children': literalList([
              refer('ResponsiveText').call([
                literalString(plotTitle)
              ], {
                'style': refer('Theme.of')
                    .call([refer('context')])
                    .property('textTheme')
                    .property('headlineLarge')
              }),
              refer('SizedBox').constInstance([], {'height': literalNum(16)}),
              refer('Expanded').newInstance([], {'child': lineChart}),
            ])
          })
        }).code,
      ).closure,
    }).returned.statement);
}

Method _generateQuoteSlide(Map<String, dynamic> slide) {
  final quote = slide['quote'] as String;
  final attribution = slide['attribution'] as String;

  return Method((b) => b
    ..name = 'build'
    ..returns = refer('FlutterDeckSlide')
    ..annotations.add(refer('override'))
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'context'
      ..type = refer('BuildContext')))
    ..body = refer('FlutterDeckSlide.quote').call([], {
      'quote': literalString(quote),
      'attribution': literalString(attribution),
    }).returned.statement);
}

Method _generateTableSlide(Map<String, dynamic> slide) {
  final title = slide['title'] as String;
  final table = slide['table'] as List<List<String>>;
  final header = table.first;
  final rows = table.skip(1).toList();
  final columns = header
      .map((cell) => refer('DataColumn')
          .newInstance([], {'label': refer('Text').call([literalString(cell)])}))
      .toList();
  final dataRows = rows.map((row) {
    final cells = row
        .map((cell) =>
            refer('DataCell').newInstance([refer('Text').call([literalString(cell)])]))
        .toList();
    return refer('DataRow').newInstance([], {
      'cells': literalList(cells),
    });
  }).toList();

  final tableWidget = refer('DataTable').newInstance([], {
    'columns': literalList(columns),
    'rows': literalList(dataRows),
  });

  return Method((b) => b
    ..name = 'build'
    ..returns = refer('FlutterDeckSlide')
    ..annotations.add(refer('override'))
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'context'
      ..type = refer('BuildContext')))
    ..body = refer('FlutterDeckSlide.blank').call([], {
      'builder': Method((b) => b
        ..requiredParameters.add(Parameter((b) => b..name = 'context'))
        ..body = refer('Center').newInstance([], {
          'child': refer('Column').newInstance([], {
            'mainAxisAlignment':
                refer('MainAxisAlignment.center', 'package:flutter/material.dart'),
            'children': literalList([
              refer('ResponsiveText').call([
                literalString(title)
              ], {
                'style': refer('Theme.of')
                    .call([refer('context')])
                    .property('textTheme')
                    .property('headlineLarge')
              }),
              refer('SizedBox').constInstance([], {'height': literalNum(16)}),
              tableWidget,
            ])
          })
        }).code,
      ).closure,
    }).returned.statement);
}

Method _generateFlutterWidgetSlide(Map<String, dynamic> slide) {
  final title = slide['title'] as String;
  final flutterWidget = slide['flutterWidget'] as String;
  return Method((b) => b
    ..name = 'build'
    ..returns = refer('FlutterDeckSlide')
    ..annotations.add(refer('override'))
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'context'
      ..type = refer('BuildContext')))
    ..body = refer('FlutterDeckSlide.blank').call([], {
      'builder': Method((b) => b
        ..requiredParameters.add(Parameter((b) => b..name = 'context'))
        ..body = refer('Center').newInstance([], {
          'child': refer('Column').newInstance([], {
            'mainAxisAlignment':
                refer('MainAxisAlignment.center', 'package:flutter/material.dart'),
            'children': literalList([
              refer('ResponsiveText').call([
                literalString(title)
              ], {
                'style': refer('Theme.of')
                    .call([refer('context')])
                    .property('textTheme')
                    .property('headlineLarge')
              }),
              refer('SizedBox').constInstance([], {'height': literalNum(16)}),
              refer('Expanded').newInstance([], {'child': CodeExpression(Code(flutterWidget))}),
            ])
          })
        }).code,
      ).closure,
    }).returned.statement);
}

Method _generateImageSlide(Map<String, dynamic> slide) {
  final title = slide['title'] as String;
  final imageUri = slide['imageUri'] as String;
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
  final imageWidth = slide['imageWidth'] as double?;
  final imageHeight = slide['imageHeight'] as double?;
  final content = slide['content'] as String;

  if (content.isNotEmpty) {
    return Method((b) => b
      ..name = 'build'
      ..returns = refer('FlutterDeckSlide')
      ..annotations.add(refer('override'))
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'context'
        ..type = refer('BuildContext')))
      ..body = refer('FlutterDeckSlide.blank').call([], {
        'builder': Method((b) => b
          ..requiredParameters.add(Parameter((b) => b..name = 'context'))
          ..body = refer('Center').newInstance([], {
            'child': refer('Row').newInstance([], {
              'mainAxisAlignment':
                  refer('MainAxisAlignment.center', 'package:flutter/material.dart'),
              'children': literalList([
                refer(imageWidget).call([
                  literalString(uri)
                ], {
                  'width': literalNum(imageWidth ?? 0),
                  'height': literalNum(imageHeight ?? 0),
                }),
                refer('SizedBox').constInstance([], {'width': literalNum(16)}),
                refer('Text').call([
                  literalString(content)
                ], {
                  'textAlign': refer('TextAlign.center', 'package:flutter/material.dart'),
                }),
              ])
            })
          }).code,
        ).closure,
      }).returned.statement);
  }

  return Method((b) => b
    ..name = 'build'
    ..returns = refer('FlutterDeckSlide')
    ..annotations.add(refer('override'))
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'context'
      ..type = refer('BuildContext')))
    ..body = refer('FlutterDeckSlide.image').call([], {
      'imageBuilder': Method((b) => b
        ..requiredParameters.add(Parameter((b) => b..name = 'context'))
        ..body = refer(imageWidget).call([
          literalString(uri)
        ], {
          'width': literalNum(imageWidth ?? 0),
          'height': literalNum(imageHeight ?? 0),
        }).code).closure,
      'label': literalString(title),
    }).returned.statement);
}

Method _generateContentSlide(Map<String, dynamic> slide,
    {bool showAllBullets = false}) {
  final title = slide['title'] as String;
  final content = slide['content'] as String;
  final contentSteps = slide['content_steps'] as List<String>?;
  final bullets = slide['bullets'] as List<Map<String, dynamic>>;
  final code = slide['code'] as String?;

  var contentWidget = refer('Text').call([
    literalString(content)
  ], {
    'textAlign': refer('TextAlign.center', 'package:flutter/material.dart'),
  });

  if (contentSteps != null && contentSteps.isNotEmpty) {
    final steps = contentSteps.map((step) =>
        refer('Text').call([literalString('- $step')])).toList();
    final column = refer('Column').newInstance([], {
      'crossAxisAlignment': refer('CrossAxisAlignment.start', 'package:flutter/material.dart'),
      'mainAxisSize': refer('MainAxisSize.min', 'package:flutter/material.dart'),
      'children': literalList(steps),
    });
    if (showAllBullets) {
      contentWidget = column;
    } else {
      contentWidget = refer('FlutterDeckSlideStepsBuilder').newInstance([], {
        'builder': Method((b) => b
          ..requiredParameters.add(Parameter((b) => b..name = 'context'))
          ..requiredParameters.add(Parameter((b) => b..name = 'step'))
          ..body = refer('Column').newInstance([], {
            'crossAxisAlignment': refer('CrossAxisAlignment.start', 'package:flutter/material.dart'),
            'mainAxisSize': refer('MainAxisSize.min', 'package:flutter/material.dart'),
            'children': literalList(
              contentSteps.asMap().entries.map((entry) {
                final i = entry.key;
                final stepContent = entry.value;
                return CodeExpression(Code('if (step > $i) Text("""- $stepContent""")'));
              }).toList(),
            ),
          }).code,
        ).closure,
      });
    }
  } else if (bullets.isNotEmpty) {
    final bulletWidgets = bullets.map((bullet) {
      final bulletTitle = bullet['title'] as String;
      final bulletContent = bullet['content'] as String;
      final bulletImageUri = bullet['imageUri'] as String?;
      final bulletImageWidth = bullet['imageWidth'] as double?;
      final bulletImageHeight = bullet['imageHeight'] as double?;

      var imageWidgetStr = literalNull;
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
        imageWidgetStr = refer(imageWidget).call([
          literalString(uri)
        ], {
          'width': literalNum(bulletImageWidth ?? 0),
          'height': literalNum(bulletImageHeight ?? 0),
        });
      }

      return refer('Padding').newInstance([], {
        'padding':
            refer('EdgeInsets.only').constInstance([], {'bottom': literalNum(16)}),
        'child': refer('Column').newInstance([], {
          'crossAxisAlignment':
              refer('CrossAxisAlignment.start', 'package:flutter/material.dart'),
          'children': literalList([
            refer('ResponsiveText').call([
              literalString('• $bulletTitle')
            ], {
              'style': refer('Theme.of')
                  .call([refer('context')])
                  .property('textTheme')
                  .property('headlineSmall')
            }),
            refer('SizedBox').constInstance([], {'height': literalNum(8)}),
            refer('ResponsiveText').call([
              literalString(bulletContent)
            ], {
              'textAlign':
                  refer('TextAlign.start', 'package:flutter/material.dart'),
            }),
            if (imageWidgetStr != literalNull) imageWidgetStr,
          ])
        })
      });
    }).toList();

    final column = refer('Column').newInstance([], {
      'crossAxisAlignment': refer('CrossAxisAlignment.start', 'package:flutter/material.dart'),
      'children': literalList(bulletWidgets),
    });

    if (showAllBullets) {
      contentWidget = refer('Expanded').newInstance([
        refer('SingleChildScrollView').newInstance([], {'child': column})
      ]);
    } else {
      contentWidget = refer('Expanded').newInstance([], {
        'child': refer('SingleChildScrollView').newInstance([], {
          'child': refer('FlutterDeckSlideStepsBuilder').newInstance([], {
            'builder': Method((b) => b
              ..requiredParameters.add(Parameter((b) => b..name = 'context'))
              ..requiredParameters.add(Parameter((b) => b..name = 'step'))
              ..body = refer('Column').newInstance([], {
                'crossAxisAlignment': refer(
                    'CrossAxisAlignment.start', 'package:flutter/material.dart'),
                'children': literalList(
                  bullets.asMap().entries.map((entry) {
                    final i = entry.key;
                    return CodeExpression(Code(
                        'if (step > $i) ...[ ${bulletWidgets[i].accept(DartEmitter())} ]'));
                  }).toList(),
                ),
              }).code,
            ).closure,
          })
        })
      });
    }
  } else if (code != null) {
    final language = slide['language'] as String?;
    final codeLines = code.split('\n').length;
    final codeHighlight =
        refer('FlutterDeckCodeHighlight').newInstance([], {
      'code': literalString(code),
      'language': literalString(language!),
      'textStyle': refer('GoogleFonts.robotoMono').call([]),
    });
    if (codeLines > 10) {
      contentWidget = refer('Expanded').newInstance([], {
        'child':
            refer('SingleChildScrollView').newInstance([], {'child': codeHighlight})
      });
    } else {
      contentWidget = codeHighlight;
    }
  }

  return Method((b) => b
    ..name = 'build'
    ..returns = refer('FlutterDeckSlide')
    ..annotations.add(refer('override'))
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'context'
      ..type = refer('BuildContext')))
    ..body = refer('FlutterDeckSlide.blank').call([], {
      'builder': Method((b) => b
        ..requiredParameters.add(Parameter((b) => b..name = 'context'))
        ..body = refer('Center').newInstance([], {
          'child': refer('Column').newInstance([], {
            'mainAxisAlignment': refer('MainAxisAlignment.center', 'package:flutter/material.dart'),
            'children': literalList([
              refer('ResponsiveText').call([
                literalString(title)
              ], {
                'style': refer('Theme.of')
                    .call([refer('context')])
                    .property('textTheme')
                    .property('headlineLarge')
              }),
              refer('SizedBox').constInstance([], {'height': literalNum(16)}),
              contentWidget,
            ])
          })
        }).code,
      ).closure,
    }).returned.statement);
}

void generateSlidesFile(
  List<Map<String, dynamic>> slides, {
  String? author,
  bool showAllBullets = false,
  String transition = 'none',
}) {
  final library = Library((b) {
    b.directives.addAll([
      Directive.import('package:flutter/material.dart'),
      Directive.import('package:flutter_deck/flutter_deck.dart'),
      Directive.import('package:google_fonts/google_fonts.dart'),
      Directive.import('package:dash_summit_talk/responsive_text.dart'),
    ]);

    for (var i = 0; i < slides.length; i++) {
      final slide = slides[i];
      final title = slide['title'] as String;
      final hidden = slide['hidden'] as bool;
      final notes = slide['notes'] as String;
      final bullets = slide['bullets'] as List<Map<String, dynamic>>;
      final contentSteps = slide['content_steps'] as List<String>? ?? [];
      var stepsCount =
          contentSteps.isNotEmpty ? contentSteps.length : bullets.length;
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

      b.body.add(Class((b) => b
        ..name = className
        ..extend = refer('FlutterDeckSlideWidget')
        ..constructors.add(Constructor((b) => b
          ..constant = true
          ..initializers.add(refer('super').call([], {
                'configuration':
                    refer('FlutterDeckSlideConfiguration').constInstance([], {
                  'route': literalString('/$className'),
                  'title': literalString(title),
                  'hidden': literalBool(hidden),
                  'steps': literalNum(stepsCount),
                  'speakerNotes': literalString(notes),
                  'transition': CodeExpression(Code(transitionValue)),
                })
              }).code)))
        ..methods
            .add(_generateBuildMethod(slide, showAllBullets: showAllBullets))));
    }

    b.body.add(Field((b) => b
      ..name = 'generatedSlides'
      ..modifier = FieldModifier.constant
      ..assignment = literalList(
        List.generate(
            slides.length, (i) => refer('GeneratedSlide${i + 1}').constInstance([])),
        refer('FlutterDeckSlideWidget'),
      ).code));

    if (author != null) {
      b.body.add(Field((b) => b
        ..name = 'speakerInfo'
        ..modifier = FieldModifier.constant
        ..assignment = refer('FlutterDeckSpeakerInfo').constInstance([], {
          'name': literalString(author),
          'description': literalString(''),
          'socialHandle': literalString(''),
          'imagePath': literalString(''),
        }).code));
    }
  });

  final emitter = DartEmitter(useNullSafetySyntax: true);
  final pubspecContent = File('pubspec.yaml').readAsStringSync();
  final languageVersionString =
      RegExp(r'sdk: ">=(\d+\.\d+\.\d+)').firstMatch(pubspecContent)?.group(1);
  final languageVersion = languageVersionString != null
      ? Version.parse(languageVersionString)
      : Version.none;
  final formatter = DartFormatter(
      pageWidth: 80, languageVersion: languageVersion);
  final formattedCode =
      formatter.format(library.accept(emitter).toString());

  final outputFile = File('lib/generated_slides.dart');
  outputFile.writeAsStringSync(formattedCode);

  print('Generated lib/generated_slides.dart');
}