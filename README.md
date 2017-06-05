# Block travel package

This package used to be a useful way to navigate and select through blocks.

But now, Atom has implemented this functionality into it's core. Simply add this to your `keymap.cson` file:

```
'.editor':
  'alt-up': 'editor:move-to-beginning-of-previous-paragraph'
  'alt-down': 'editor:move-to-beginning-of-next-paragraph'
  'alt-shift-up': 'editor:select-to-beginning-of-previous-paragraph'
  'alt-shift-down': 'editor:select-to-beginning-of-next-paragraph'
```
