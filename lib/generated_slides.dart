// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneratedSlide1 extends FlutterDeckSlideWidget {
  const GeneratedSlide1()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/GeneratedSlide1',
            title: """Why?""",
            hidden: false,
            steps: 3,
            transition: FlutterDeckTransition.none(),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""Why?""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
                  FlutterDeckSlideStepsBuilder(
        builder: (context, step) {
          return       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (step > 0) Text("""- No need for complicated presentation software"""),
if (step > 1) Text("""- Impress and/or confuse your coworkers"""),
if (step > 2) Text("""- Because it's fun!"""),

        ],
      )
    ;
        },
      )
          ],
        ),
      ),
    );
  }

}

class GeneratedSlide2 extends FlutterDeckSlideWidget {
  const GeneratedSlide2()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/GeneratedSlide2',
            title: """COMMENT This isn't shown!""",
            hidden: true,
            steps: 0,
            transition: FlutterDeckTransition.none(),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""COMMENT This isn't shown!""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Text("""This slide won't be shown as part of the presentation because it has a `COMMENT` state.
""", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

}

class GeneratedSlide3 extends FlutterDeckSlideWidget {
  const GeneratedSlide3()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/GeneratedSlide3',
            title: """Initial Setup""",
            hidden: false,
            steps: 0,
            transition: FlutterDeckTransition.none(),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""Initial Setup""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            FlutterDeckCodeHighlight(code: '''
  (use-package org-tree-slide
    :custom
    (org-image-actual-width nil))

''', language: '''emacs-lisp''', textStyle: GoogleFonts.robotoMono(),)
          ],
        ),
      ),
    );
  }

}

class GeneratedSlide4 extends FlutterDeckSlideWidget {
  const GeneratedSlide4()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/GeneratedSlide4',
            title: """What Can It Do?""",
            hidden: false,
            steps: 5,
            transition: FlutterDeckTransition.none(),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""What Can It Do?""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
                  Expanded(
        child: SingleChildScrollView(
          child: FlutterDeckSlideStepsBuilder(
            builder: (context, step) {
              return       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (step > 0) ...[         Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Display Images", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""""", textAlign: TextAlign.start),
              
            ],
          ),
        )
      , ],
if (step > 1) ...[         Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• System Crafters", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""I haven't included these images with the notes so you will have to change the link to another image on your computer!  You can do that with =C-c C-l= (=org-insert-link=) and link to the image without adding a description.
This is an image of a computer screen with code on it.
""", textAlign: TextAlign.start),
                      Image.asset(
          """assets/images/photo-1555066931-4365d14bab8c.webp""",
          width: 500.0,
          height: null,
        ),
        
            ],
          ),
        )
      , ],
if (step > 2) ...[         Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Emacs", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""""", textAlign: TextAlign.start),
                      Image.asset(
          """assets/images/photo-1605379399642-870262d3d051.webp""",
          width: 300.0,
          height: 300.0,
        ),
        
            ],
          ),
        )
      , ],
if (step > 3) ...[         Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Run Code Examples", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""This is a terrible code snippet for *example purposes only*!
""", textAlign: TextAlign.start),
              
            ],
          ),
        )
      , ],
if (step > 4) ...[         Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Countdown Timer", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""Run =org-tree-slide-play-with-timer= to have a countdown timer appear in your modeline.
Good for keeping track of how much time you have left!
""", textAlign: TextAlign.start),
              
            ],
          ),
        )
      , ],

        ],
      )
    ;
            },
          ),
        ),
      )
      
          ],
        ),
      ),
    );
  }

}

class GeneratedSlide5 extends FlutterDeckSlideWidget {
  const GeneratedSlide5()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/GeneratedSlide5',
            title: """Profiles""",
            hidden: false,
            steps: 3,
            transition: FlutterDeckTransition.none(),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""Profiles""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
                  Expanded(
        child: SingleChildScrollView(
          child: FlutterDeckSlideStepsBuilder(
            builder: (context, step) {
              return       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (step > 0) ...[         Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Simple Profile", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""Run =org-tree-slide-simple-profile=
""", textAlign: TextAlign.start),
              
            ],
          ),
        )
      , ],
if (step > 1) ...[         Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Presentation Profile", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""Run =org-tree-slide-presentation-profile=
""", textAlign: TextAlign.start),
              
            ],
          ),
        )
      , ],
if (step > 2) ...[         Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Narrowing Profile", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("""Run =org-tree-slide-narrowing-control-profile=
""", textAlign: TextAlign.start),
              
            ],
          ),
        )
      , ],

        ],
      )
    ;
            },
          ),
        ),
      )
      
          ],
        ),
      ),
    );
  }

}

class GeneratedSlide6 extends FlutterDeckSlideWidget {
  const GeneratedSlide6()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/GeneratedSlide6',
            title: """Customization""",
            hidden: false,
            steps: 0,
            transition: FlutterDeckTransition.none(),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""Customization""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: FlutterDeckCodeHighlight(code: '''
  (use-package hide-mode-line)

  (defun efs/presentation-setup ()
    ;; Hide the mode line
    (hide-mode-line-mode 1)

    ;; Display images inline
    (org-display-inline-images) ;; Can also use org-startup-with-inline-images

    ;; Scale the text.  The next line is for basic scaling:
    (setq text-scale-mode-amount 3)
    (text-scale-mode 1))

    ;; This option is more advanced, allows you to scale other faces too
    ;; (setq-local face-remapping-alist '((default (:height 2.0) variable-pitch)
    ;;                                    (org-verbatim (:height 1.75) org-verbatim)
    ;;                                    (org-block (:height 1.25) org-block))))

  (defun efs/presentation-end ()
    ;; Show the mode line again
    (hide-mode-line-mode 0)

    ;; Turn off text scale mode (or use the next line if you didn't use text-scale-mode)
    ;; (text-scale-mode 0))

    ;; If you use face-remapping-alist, this clears the scaling:
    (setq-local face-remapping-alist '((default variable-pitch default))))

  (use-package org-tree-slide
    :hook ((org-tree-slide-play . efs/presentation-setup)
           (org-tree-slide-stop . efs/presentation-end))
    :custom
    (org-tree-slide-slide-in-effect t)
    (org-tree-slide-activate-message "Presentation started!")
    (org-tree-slide-deactivate-message "Presentation finished!")
    (org-tree-slide-header t)
    (org-tree-slide-breadcrumbs " > ")
    (org-image-actual-width nil))

''', language: '''emacs-lisp''', textStyle: GoogleFonts.robotoMono(),),
              ),
            )
          ],
        ),
      ),
    );
  }

}

class GeneratedSlide7 extends FlutterDeckSlideWidget {
  const GeneratedSlide7()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/GeneratedSlide7',
            title: """Generating a PDF of Slides""",
            hidden: false,
            steps: 0,
            transition: FlutterDeckTransition.none(),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("""Generating a PDF of Slides""", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Text("""Run =org-beamer-export-to-pdf=, requires =pdflatex= and associated tools though!
More documentation: https://orgmode.org/worg/exporters/beamer/tutorial.html
""", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

}

const generatedSlides = <FlutterDeckSlideWidget>[
  const GeneratedSlide1(),
  const GeneratedSlide2(),
  const GeneratedSlide3(),
  const GeneratedSlide4(),
  const GeneratedSlide5(),
  const GeneratedSlide6(),
  const GeneratedSlide7(),
];
