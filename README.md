# caelestia-note

A lightweight note popout for Caelestia Quickshell. It replaces the AI chat UI with a simple text box that creates a note through the Obsidian CLI.

## How it works

```text
Caelestia bar
    ↓
Note popout
    ↓
Type text + Send / Ctrl+Enter
    ↓
Obsidian CLI
    ↓
New note in the active Obsidian vault
```

Each submitted note is created with a timestamped title such as:

```text
Quick Note 2026-08-21 07-10-30
```

The complete submitted text becomes the note content.

## Install

This project is an add-on for an existing Caelestia Quickshell installation. It is **not** a standalone Caelestia application.

First make sure the Obsidian CLI works from your shell:

```bash
obsidian --help
obsidian create --help
```

Then clone this repository and switch to the note branch:

```bash
git clone https://github.com/bien245/caelestia-note.git
cd caelestia-note
git checkout feature/obsidian-note
```

Install the module into the active Caelestia configuration:

```bash
./scripts/install.sh
```

By default the installer copies the module into:

```text
~/.config/quickshell/caelestia/
```

You can override that location with `QS_CAELESTIA_DIR`.

Finally restart Quickshell:

```bash
pkill quickshell
quickshell -c caelestia &
```

The installer does not install system packages, modify your shell configuration, or merge unrelated Caelestia files.

## Using the note UI

Open the Caelestia bar's Note/AI entry. The existing bar entry is intentionally kept as `ai` internally so it remains compatible with the original Caelestia configuration.

Type your note into the text area and either:

- click **Send**; or
- press **Ctrl + Enter**.

A success/error message is displayed below the editor.

## Files changed for the first implementation

```text
quickshell/modules/bar/components/Ai.qml
    Note icon and busy state

quickshell/modules/bar/popouts/Ai.qml
    Replaced AI chat UI with the Quick Note editor

quickshell/services/Note.qml
    Runs `obsidian create` and reports success/failure

scripts/install.sh
    Installs the module into the active Caelestia config
```

The original OpenCode-related files are left in the repository for now so the first implementation changes the UI path without unnecessarily deleting the existing Caelestia integration files. They are no longer used by the new Note popout.
