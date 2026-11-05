# Obsidian vault

The **repository root** is the vault. This follows guild-rebrew's arrangement: one Markdown knowledge base shared by GitHub and Obsidian, relative links, and local application settings.

## Open it

1. Run `make vault` from the checkout root.
2. In Obsidian, choose **Open folder as vault** and select the `holidaydecomp` repository folder.
3. Open [docs/README.md](README.md).

No community plugins are required. Core backlinks, outgoing links, search, outline and graph view work with the existing Markdown links. The Markdown files stay readable without Obsidian.

## Local settings

`make vault` creates `.obsidian/app.json`, `community-plugins.json` and `templates.json` only when each file is absent. It preserves existing settings, enables ordinary relative Markdown links, puts new notes in `docs/`, and sends attachments to `docs/assets/`.

`.obsidian/` is ignored, including personal workspaces and plugin state. The repeatable defaults are in [gen_docs_index.py](../tools/gen_docs_index.py); there is no committed machine-specific vault path.

## Notes and attachments

Use one topic owner linked from the [knowledge-base index](README.md). Use the [finding template](templates/finding.md) for a new investigation; Obsidian's built-in Templates feature can use `docs/templates`, or copy it manually.

Link to [STATUS.md](../STATUS.md) and managed metadata for current measurements. Keep reference executables, copied artwork, binary resource dumps and toolchain files outside note attachments. A diagram or receipt written for this project can live in `docs/assets/` or `docs/evidence/`.

## Check and maintain

```sh
make docs
make docs-check
```

The check covers local Markdown destinations and heading anchors, including the form index. It does not fetch external URLs or launch the Obsidian desktop application. If a page moves, update its incoming relative links before committing.
