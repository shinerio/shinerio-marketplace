---
name: embed-mindmap
description: Generate a mind map based on a Markdown file and embed it into the Markdown document
---

# steps

1. generate mindmap
2. export html to png
3. upload image
4. embed mindmap
5. cleanup temporary files

## generate mindmap

1. try to install the mcp named "markmap-mcp-server" if not exist.
2. Use mcp tools named "markmap-mcp-server" to generate mindmap. Record the output HTML file path as `{html_path}`.

## export html to png

1. Open the generated HTML in chrome-devtools via `navigate_page` with `url` set to `file://{html_path}`.
2. Use the chrome-devtools `take_screenshot` tool with `fullPage: true` and `filePath` set to `{html_path}.png` to capture the mindmap directly to a known path. This avoids relying on browser downloads.
3. close the chrome launched for screenshot.

## upload image

Important! Note that you must run picgo_client.py by `uv run` first.

Use `uv run scripts/picgo_client.py {html_path}.png` to upload image to picgo and get the image url.

Only if uv is not available, you can also run the script with python directly:

```bash
python scripts/picgo_client.py {html_path}.png`
```

## embed mindmap

Add a mind map section if not exist at the end of the Markdown file and embed the image url. `![mindmap](image_url)`

## cleanup temporary files

Delete the two temporary files created during the process:

```bash
rm -f "{html_path}" "{html_path}.png"
```