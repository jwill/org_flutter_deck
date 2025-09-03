# Flutter Deck AI Slide Generator

This project uses a Dart script to generate a Flutter Deck slide presentation from an Org Mode file.

## Generating Slides

To generate the slides, run the `generate_from_org.dart` script from the `tool` directory:

```bash
dart tool/generate_from_org.dart [path/to/your.org] [options]
```

The script will read the specified `.org` file and generate `lib/generated_slides.dart`. If no `.org` file is provided, it will default to reading `demo-slide-deck.org`.

### Options

- `--show-all-bullets`: By default, bullet points on a slide are revealed one by one. Use this flag to make all bullet points appear at once.
- `--transition <type>`: Specify the transition animation between slides. Valid types are:
  - `none` (default)
  - `fade`
  - `slide`
  - `scale`
  - `rotation`
- `--template <ClassName>`: Specify a template class to use for the slides. This class will wrap the content of each slide, allowing for custom layouts and branding. The template class must be a `FlutterDeckSlideWidget`.
- `--imports-file <path>`: Specify a file containing a list of import statements to be added to the generated slides file. Each line in the file should be a valid import statement.

## Slide Deck Structure (Org Mode)

The `demo-slide-deck.org` file is the source for the presentation. Here's how to structure your content:

### Slides

Each top-level heading (`*`) in the Org file represents a new slide.

```org
* This is the title of the slide
```

### Hidden Slides

To create a slide that is not included in the presentation, add the `COMMENT` keyword to its title.

```org
* COMMENT This slide will be hidden
```

### Speaker Notes

You can add speaker notes to a slide by using a `:NOTES:` drawer. These notes will be available in the presenter view.

```org
* Slide with Speaker Notes
:NOTES:
This is a speaker note.
It can span multiple lines.
:END:

This is the slide content.
```

### Content

Any text directly under a slide heading will be added as content to the slide.

### Stepped Content (Bulleted Lists)

You can create content that appears step-by-step by using a simple bulleted list. Each item will be revealed one at a time unless the `--show-all-bullets` flag is used.

```org
* Slide with Stepped Content

- First item to appear
- Second item to appear
- Third item
```

### Nested Bullet Points

For more complex slide layouts, you can use nested bullet points (`**`, `***`, etc.). Each nested bullet point can have its own title, content, and even an image.

```org
* Slide with Nested Bullets

** First Bullet Title
Some content for the first bullet.

** Second Bullet Title
Some content for the second bullet.
```

### Code Blocks

Include code blocks in your slides using the standard Org Mode syntax. The language specified will be used for syntax highlighting.

```org
* Slide with a Code Block

#+begin_src dart
  void main() {
    print('Hello, Flutter Deck!');
  }
#+end_src
```

### Embedding Flutter Widgets

You can embed a runnable Flutter widget in a slide by using a `#+BEGIN_FLUTTER` block. The widget will be rendered on the slide.

```org
* Slide with an Embedded Widget

#+BEGIN_FLUTTER
CustomPaint(
  size: const Size(200, 200),
  painter: TrianglePainter(),
)
#+END_FLUTTER
```

### Tables

You can create tables using Org Mode's table syntax. The first row will be treated as the header.

```org
* Slide with a Table

| Name  | Age | City      |
|-------+-----+-----------|
| John  | 30  | New York  |
| Alice | 25  | London    |
| Bob   | 42  | Paris     |
```

### Quotes

You can add a quote to a slide using a `#+BEGIN_QUOTE` block. The last line starting with `- ` will be used as the attribution.

```org
* Slide with a Quote

#+BEGIN_QUOTE
The only way to do great work is to love what you do.
- Steve Jobs
#+END_QUOTE
```

### Images

You can add images to slides. Both local and remote images are supported.

- **Local Images**: Place the image file in the `assets/images` directory and link to it using the `file:` prefix.
- **Remote Images**: Link directly to the image URL.

You can specify the width and height of the image using `#+ATTR_HTML`.

```org
* Slide with an Image

#+ATTR_HTML: :width 500 :height 300
[[file:my-local-image.png]]

[[https://example.com/remote-image.jpg]]
```

## Presenter View

This project supports a presenter view, which allows you to control the presentation from a separate window. To use the presenter view, follow these steps:

1.  Run the app in presenter mode by using the `--dart-define=PRESENTER_MODE=true` flag:

    ```bash
    flutter run --dart-define=PRESENTER_MODE=true
    ```

2.  Open a browser and navigate to the URL displayed in the console. This will be the presenter view, where you can control the slides.

3.  The app window will display the presentation, which will be controlled by the presenter view.