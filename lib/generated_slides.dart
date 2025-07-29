import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_deck_ai/src/painters.dart';
import 'package:fl_chart/fl_chart.dart';

class GeneratedSlide1 extends FlutterDeckSlideWidget {
  const GeneratedSlide1()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide1',
          title: 'Why?',
          hidden: false,
          steps: 3,
          speakerNotes:
              'Remember to talk about how easy it is to use Org Mode for presentations.\n',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Why?',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                FlutterDeckSlideStepsBuilder(
                    builder: (
                  context,
                  step,
                ) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (step > 0)
                              Text(
                                  """- No need for complicated presentation software"""),
                            if (step > 1)
                              Text(
                                  """- Impress and/or confuse your coworkers"""),
                            if (step > 2) Text("""- Because it's fun!"""),
                          ],
                        )),
              ],
            )));
  }
}

class GeneratedSlide2 extends FlutterDeckSlideWidget {
  const GeneratedSlide2()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide2',
          title: 'COMMENT This isn\'t shown!',
          hidden: true,
          steps: 0,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'COMMENT This isn\'t shown!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'This slide won\'t be shown as part of the presentation because it has a `COMMENT` state.\n',
                  textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}

class GeneratedSlide3 extends FlutterDeckSlideWidget {
  const GeneratedSlide3()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide3',
          title: 'Initial Setup',
          hidden: false,
          steps: 0,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Initial Setup',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                FlutterDeckCodeHighlight(
                  code:
                      '\n  (use-package org-tree-slide\n    :custom\n    (org-image-actual-width nil))\n\n',
                  language: 'emacs-lisp',
                  textStyle: GoogleFonts.robotoMono(),
                ),
              ],
            )));
  }
}

class GeneratedSlide4 extends FlutterDeckSlideWidget {
  const GeneratedSlide4()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide4',
          title: 'What Can It Do?',
          hidden: false,
          steps: 5,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'What Can It Do?',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(child:SingleChildScrollView(
                    child: FlutterDeckSlideStepsBuilder(
                        builder: (
                  context,
                  step,
                ) =>
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (step > 0) ...[
                                  Padding(padding:
                                    const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• Display Images',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '',
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                if (step > 1) ...[
                                  Padding(padding:
                                    const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• System Crafters',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'I haven\'t included these images with the notes so you will have to change the link to another image on your computer!  You can do that with =C-c C-l= (=org-insert-link=) and link to the image without adding a description.\nThis is an image of a computer screen with code on it.\n',
                                          textAlign: TextAlign.start,
                                        ),
                                        Image.asset(
                                          'assets/images/photo-1555066931-4365d14bab8c.webp',
                                          width: 500.0,
                                          height: 0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                if (step > 2) ...[
                                  Padding(padding:
                                    const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• Emacs',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '',
                                          textAlign: TextAlign.start,
                                        ),
                                        Image.asset(
                                          'assets/images/photo-1605379399642-870262d3d051.webp',
                                          width: 300.0,
                                          height: 300.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                if (step > 3) ...[
                                  Padding(padding:
                                    const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• Run Code Examples',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'This is a terrible code snippet for *example purposes only*!\n',
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                if (step > 4) ...[
                                  Padding(padding:
                                    const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• Countdown Timer',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Run =org-tree-slide-play-with-timer= to have a countdown timer appear in your modeline.\nGood for keeping track of how much time you have left!\n',
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ],
                            )))),
              ],
            )));
  }
}

class GeneratedSlide5 extends FlutterDeckSlideWidget {
  const GeneratedSlide5()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide5',
          title: 'Profiles',
          hidden: false,
          steps: 3,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Profiles',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(child:SingleChildScrollView(
                    child: FlutterDeckSlideStepsBuilder(
                        builder: (
                  context,
                  step,
                ) =>
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (step > 0) ...[
                                  Padding(padding:
                                    const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• Simple Profile',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Run =org-tree-slide-simple-profile=\n',
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                if (step > 1) ...[
                                  Padding(padding:
                                    const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• Presentation Profile',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Run =org-tree-slide-presentation-profile=\n',
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                if (step > 2) ...[
                                  Padding(padding:
                                    const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• Narrowing Profile',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Run =org-tree-slide-narrowing-control-profile=\n',
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ],
                            )))),
              ],
            )));
  }
}

class GeneratedSlide6 extends FlutterDeckSlideWidget {
  const GeneratedSlide6()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide6',
          title: 'Customization',
          hidden: false,
          steps: 0,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Customization',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(child:SingleChildScrollView(
                    child: FlutterDeckCodeHighlight(
                  code:
                      '\n  (use-package hide-mode-line)\n\n  (defun efs/presentation-setup ()\n    ;; Hide the mode line\n    (hide-mode-line-mode 1)\n\n    ;; Display images inline\n    (org-display-inline-images) ;; Can also use org-startup-with-inline-images\n\n    ;; Scale the text.  The next line is for basic scaling:\n    (setq text-scale-mode-amount 3)\n    (text-scale-mode 1))\n\n    ;; This option is more advanced, allows you to scale other faces too\n    ;; (setq-local face-remapping-alist \'((default (:height 2.0) variable-pitch)\n    ;;                                    (org-verbatim (:height 1.75) org-verbatim)\n    ;;                                    (org-block (:height 1.25) org-block))))\n\n  (defun efs/presentation-end ()\n    ;; Show the mode line again\n    (hide-mode-line-mode 0)\n\n    ;; Turn off text scale mode (or use the next line if you didn\'t use text-scale-mode)\n    ;; (text-scale-mode 0))\n\n    ;; If you use face-remapping-alist, this clears the scaling:\n    (setq-local face-remapping-alist \'((default variable-pitch default))))\n\n  (use-package org-tree-slide\n    :hook ((org-tree-slide-play . efs/presentation-setup)\n           (org-tree-slide-stop . efs/presentation-end))\n    :custom\n    (org-tree-slide-slide-in-effect t)\n    (org-tree-slide-activate-message "Presentation started!")\n    (org-tree-slide-deactivate-message "Presentation finished!")\n    (org-tree-slide-header t)\n    (org-tree-slide-breadcrumbs " > ")\n    (org-image-actual-width nil))\n\n',
                  language: 'emacs-lisp',
                  textStyle: GoogleFonts.robotoMono(),
                ))),
              ],
            )));
  }
}

class GeneratedSlide7 extends FlutterDeckSlideWidget {
  const GeneratedSlide7()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide7',
          title: 'Generating a PDF of Slides',
          hidden: false,
          steps: 0,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Generating a PDF of Slides',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'Run =org-beamer-export-to-pdf=, requires =pdflatex= and associated tools though!\nMore documentation: https://orgmode.org/worg/exporters/beamer/tutorial.html\n',
                  textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}

class GeneratedSlide8 extends FlutterDeckSlideWidget {
  const GeneratedSlide8()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide8',
          title: 'Flutter Widget Demo',
          hidden: false,
          steps: 0,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Flutter Widget Demo',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                    child: CustomPaint(
                  size: const Size(200, 200),
                  painter: TrianglePainter(),
                )),
              ],
            )));
  }
}

class GeneratedSlide9 extends FlutterDeckSlideWidget {
  const GeneratedSlide9()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide9',
          title: 'Table Demo',
          hidden: false,
          steps: 0,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Table Demo',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Age')),
                    DataColumn(label: Text('City')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('John')),
                      DataCell(Text('30')),
                      DataCell(Text('New York')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Alice')),
                      DataCell(Text('25')),
                      DataCell(Text('London')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Bob')),
                      DataCell(Text('42')),
                      DataCell(Text('Paris')),
                    ]),
                  ],
                ),
              ],
            )));
  }
}

class GeneratedSlide10 extends FlutterDeckSlideWidget {
  const GeneratedSlide10()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide10',
          title: 'Quote Demo',
          hidden: false,
          steps: 0,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.quote(
      quote: 'The only way to do great work is to love what you do.',
      attribution: 'Steve Jobs',
    );
  }
}

class GeneratedSlide11 extends FlutterDeckSlideWidget {
  const GeneratedSlide11()
      : super(
            configuration: const FlutterDeckSlideConfiguration(
          route: '/GeneratedSlide11',
          title: 'Plot Demo',
          hidden: false,
          steps: 0,
          speakerNotes: '',
          transition: FlutterDeckTransition.none(),
        ));

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sample Line Chart',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                    child: LineChart(LineChartData(lineBarsData: [
                  LineChartBarData(spots: [
                    FlSpot(
                      1.0,
                      2.0,
                    ),
                    FlSpot(
                      2.0,
                      3.0,
                    ),
                    FlSpot(
                      3.0,
                      5.0,
                    ),
                    FlSpot(
                      4.0,
                      4.0,
                    ),
                    FlSpot(
                      5.0,
                      6.0,
                    ),
                  ])
                ]))),
              ],
            )));
  }
}

const generatedSlides = <FlutterDeckSlideWidget>[
  GeneratedSlide1(),
  GeneratedSlide2(),
  GeneratedSlide3(),
  GeneratedSlide4(),
  GeneratedSlide5(),
  GeneratedSlide6(),
  GeneratedSlide7(),
  GeneratedSlide8(),
  GeneratedSlide9(),
  GeneratedSlide10(),
  GeneratedSlide11(),
];
