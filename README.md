# Flutter Deck AI Slide Generator

This project uses a Dart script to generate a Flutter Deck slide presentation from an Org Mode file.

## Generating Slides

To generate the slides, run the `generate_from_org.dart` script from the `tool` directory:

```bash
dart tool/generate_from_org.dart [options]
```

This will read `demo-slide-deck.org` and generate `lib/generated_slides.dart`.

### Options

- `--show-all-bullets`: By default, bullet points on a slide are revealed one by one. Use this flag to make all bullet points appear at once.
- `--transition <type>`: Specify the transition animation between slides. Valid types are:
  - `none` (default)
  - `fade`
  - `slide`
  - `scale`
  - `rotation`

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
