# XTX Files

- Whenever you see `[#HEX]` it actually means `[AARRGGBB]` which is what we store colours as.

The `HEADER` and `CONTENT` files in the root of each XTX file actually have no extension at all, this is because they
are only really fragments if you look at the whole document.

```
├── HEADER
├── CONTENT
│   p0
│   t0
│   c0
│   p1
│   351305624.png
│   1412347234627356.mp4
│   24572.jpeg
├── ...
```

## HEADER

We will always parse the `HEADER` when searching the SPACE. Therefore, it contains all important metadata for each file.

```java
id:5gsa52a
tags[holiday/easter,fe,thrsb,wow] // We can use '/' to make nested tags
created:10/1/2026-1:39:8 // Made with just our moment class
modified:10/1/2026-1:40:1
icon:🚧
```

## CONTENT

The content file displays the order that nodes are arranged.
For each linebreak in the document we just put an `x` while a horizontal rule becomes `-`.

**NOTE: List nodes (l0, l1, etc.) no longer appear in CONTENT as they are now embedded within paragraph nodes.**

```java
p0
c0
p1
x
p2
t0
-
t1
xxxx // There were 4 linebreaks here so we put them together
q0
```

## Nodes

Each node is named `{NODE-TYPE}{NODE-ID}` (no extension)
which is what makes up the base Node class.
The content of the file then defines that node

Where:

- `NODE-TYPE` is the type of node contained in the file

    - [p](XTX/lib/Enums/NodeType.dart) : [Paragraph](lib/src/models/nodes/paragraph_node.dart) (can contain embedded lists)
    - [c](XTX/lib/Enums/NodeType.dart) : [Code Block](lib/src/models/nodes/code_node.dart)
    - [t](XTX/lib/Enums/NodeType.dart) : [Table](lib/src/models/nodes/table_node.dart)
    - [q](XTX/lib/Enums/NodeType.dart) : [Quote](lib/src/models/nodes/quote_node.dart)
    - [e](XTX/lib/Enums/NodeType.dart) : [Equation](lib/src/models/nodes/equation_node.dart)
    - [l](XTX/lib/Enums/NodeType.dart) : ~~List Items~~ (DEPRECATED - lists are now embedded in paragraphs)

- `NODE-ID` is an incrementing zero-indexed number used to identify the node when there are others of the same type

`p62`, for example would be the 63rd paragraph node while `c0` would be the first code node in the document.

## [Paragraphs](XTX/lib/Nodes/ParagraphNode.dart)

Each Paragraph node contains the [TextBlock](XTX/lib/Node-Common/TextBlock.dart) data model that controls the styling
and the content of each paragraph.

Paragraphs can now contain embedded lists using special delimiter characters that users cannot type:
- `\x02` (STX - Start of Text) marks the beginning of an embedded list
- `\x03` (ETX - End of Text) marks the end of an embedded list
- `\x1E` (Record Separator) separates individual list items
- `\x1F` (Unit Separator) reserved for additional metadata (future use)

**Format:**
```
[paragraph text content]
+style
[style-type]:[value]:[ranges]
[style-type]:[ranges]
```

**Example without embedded list:**
```
The first line of text \nWith each line being seperated with a literal newline.
+style
b:1-5,12-25
c:#ffE043:0-12,20-27
```

**Example with embedded list:**
```
Regular paragraph text before the list.\x02type:t\x1EMilk\x1ECheese\x1E    Cheddar\x1E    Feta\x1EBread\x03More text after the list.
+style
b:1-5,12-25
c:#ffE043:0-12,20-27
```

**Style types:**
- `b` - Bold
- `i` - Italic
- `u` - Underline
- `s` - Strikethrough
- `c` - Color (requires value: `c:#AARRGGBB:ranges`)
- `a` - Link URL (requires value: `a:[url]:ranges`)

## [Code Blocks](XTX/lib/Nodes/CodeNode.dart)

A code block contains the language of the following code as well as the actual code data.
The code content comes first, followed by the language specification on the last line.

**Format:**
```
[code content with \n for newlines]
language:[language-name]
```

**Example:**
```
void main() {\n\t print('Hello World');\n}
language:dart
```

**Notes:**
- Special characters in code are escaped using `\n` for newlines, `\[` for `[`, `\]` for `]`
- The language can be empty (`language:`) if no language is specified
- Code content preserves all whitespace and formatting

## [Quotes](XTX/lib/Parargaph-Node/QuoteNode.dart)

Quote nodes display highlighted quotations or callouts. They use the [TextBlock] data model similar to paragraphs.

**Format:**
```
[quote text content]
[style-type]:[value]:[ranges]
[style-type]:[ranges]
```

**Example:**
```
To be or not to be, that is the question.
i:0-44
```

**Style types:** (same as paragraphs)
- `b` - Bold
- `i` - Italic
- `u` - Underline
- `s` - Strikethrough
- `c` - Color (requires value)
- `a` - Link URL (requires value)

## [Equations](XTX/lib/Parargaph-Node/EquationNode.dart)

The first line of an equation file is always the mode property that can be either `display` or `inline`. Then each subsequent line in the file is a line in the equation.

**Format:**
```
mode:[display|inline]
[equation line 1]
[equation line 2]
[equation line 3]
...
```

**Example:**
```
mode:display
E = mc^2
E = mc^2
E = mc^2
```

**Notes:**
- Mode defaults to `display` if not specified or empty
- Each equation line is plain text (LaTeX format)
- Multiple equation lines can be used for multi-line equations

## [Media](XTX/lib/Parargaph-Node/MediaNode.dart)

Media files (images, videos, pdfs, etc.) are stored directly in the root of the XTX file with their original filenames.
We only store the file name and file extension because there really isn't that much else to store.

```java
summary.pdf
```

## List Items

**NOTE: Lists are now embedded inside paragraph nodes, not stored as standalone nodes.**

Lists can be ordered lists, unordered lists or lists of checkboxes (added with `type:t` for tasks).
We can add nested lists by increasing the indent of the items (4 spaces per indent level).

Lists are embedded in paragraph files using these delimiters:
- `\x02` (STX) - Start of embedded list
- `\x03` (ETX) - End of embedded list
- `\x1E` (Record Separator) - Separates list items
- `\x1F` (Unit Separator) - For additional metadata (reserved for future use)

Example embedded list format inside a paragraph file:
```
\x02type:t\x1EMilk\x1ECheese\x1E    Cheddar\x1E    Feta\x1EBread\x1EParchment Paper\x03
```

The old standalone list node format (for reference, no longer used):
```
type:t
-Milk
-Cheese
  >Cheddar
  >Feta
=Bread
=Parchment Paper
```