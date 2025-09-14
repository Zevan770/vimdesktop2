# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

- Main logic is implemented with AutoHotkey v2.0 scripts.
- Core class: `VimD` (vimd.ahk) manages global state, windows, modes, and error handling.
- Modular design separates logic into classes:
  - `VimDMode` (VimDMode.ahk): Handles individual mode state and key processing.
  - `VimDKeySeqence` (VimDKeySequence.ahk): Manages key sequences as lists/arrays, parsing, and conversion.
  - `VimDAction` (VimDAction.ahk): Represents actions mapped to key sequences.
  - `VimDActionManager` (VimDActionManager.ahk): Maps and manages action lookups and prefix matching.
- Each window (`VimDWindow`) has its own mode and state.

## Common Commands

_This repository uses pure AHK scripts. There are no standard build, test, or lint commands. Development involves editing `.ahk` files and running them with AutoHotkey v2._

- **Main Entry**: `vimd.ahk` acts as the main entry point.

## Additional Notes

- Refer to `README.md` for conceptual model and CIM ideas.
- No Copilot or Cursor rules are present.
- No automated test or lint infrastructure detected. 

For future development, maintain modularity by extending the class-based design and add scripts or documentation only as needed.
