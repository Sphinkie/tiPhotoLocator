# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**TiPhotoLocator** is a Qt 6 desktop application for geotagging photos and managing EXIF/IPTC metadata. It lets users place photos on a map, sync with GPX tracks, and edit metadata tags. It uses [ExifTool](https://exiftool.org) (embedded in `Bin/`) for all metadata read/write operations.

## Build

Requires Qt 6.8+ with the **Qt Quick**, **Qt Location**, **Qt Positioning**, and **Qt Linguist** modules, plus OpenSSL binaries. Use MSVC 2019/2022 64-bit or MinGW 64-bit on Windows.

```bash
# Configure and build
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build

# Or open CMakeLists.txt directly in Qt Creator
```

Deployment scripts for packaging: `Q_deploiement_MSVC.bat` / `Q_deploiement_minGW.bat`.

There is no automated test suite. Manual ExifTool tests are in `Bin/test_exif_*.bat`.

## Architecture

The app is a **QML + C++ hybrid**. The C++ backend exposes models as QML context properties; QML handles all UI.

### C++ Backend (`Sources/cpp/`)

- **`Models/Photo.h`** — Plain struct holding ~28 metadata fields (GPS, EXIF, IPTC). This is the core data container.
- **`Models/PhotoModel`** — `QAbstractListModel` that owns the photo list, drives EXIF I/O, and tracks selection and dirty state. The central object of the application.
- **`Models/*ProxyModel`** — Several `QSortFilterProxyModel` subclasses filter the main list for specific views: `OnTheMapProxyModel` (geotagged photos), `SelectedPhotoProxyModel`, `UndatedPhotoProxyModel`, `SuggestionProxyModel`, `SuggestionCategoryProxyModel`.
- **`ExifReadTask` / `ExifWriteTask`** — `QRunnable` workers that call `exiftool.exe` via `QProcess` (JSON output for reads). Executed on `QThreadPool` to keep the UI responsive.
- **`GeocodeWrapper`** — HTTP reverse-geocoding via OpenStreetMap Nominatim API.
- **`Models/SuggestionModel`** — Manages auto-suggestions for tags derived from existing metadata and geocoding results.
- **`main.cpp`** — Instantiates all models, registers them as QML context properties, wires cross-object signals, and loads `Main.qml`.

### QML Frontend (`Sources/Qml/`)

| Subdirectory | Purpose |
|---|---|
| `Components/` | Reusable UI elements: `MapView`, `PhotoListview`, `Chips`, `ImagettesListView`, etc. |
| `Controllers/` | Business-logic layer: toolbars, `Zone*` panels (ZoneExif, ZoneIptc, ZoneGeoloc…), popups |
| `Vues/` | Qt Designer-generated `.ui.qml` layout files (counterparts to Controllers) |
| `Dialogs/` | Modal windows: About, Settings, API key, folder picker |
| `Javascript/` | Helper scripts: `Networking.js` (HTTP), `Chips.js` (tag management), `TiUtilities.js` (date/format) |
| `Style.qml` | Singleton — Material Design color/theme constants; imported everywhere |

### Data flow

1. User opens folder → `PhotoModel` scans directory, creates `Photo` objects.
2. `ExifReadTask` (async) reads metadata via `exiftool -json`; results populate `Photo` fields via signals.
3. QML binds to `PhotoModel` roles (`FilenameRole`, `LatitudeRole`, etc.) for display.
4. User edits metadata or moves a map marker → `PhotoModel` sets `photo.toBeSaved = true`.
5. Save action → `ExifWriteTask` (async) calls `exiftool` to write changes back to files.
6. `GeocodeWrapper` fetches place names from OSM; results feed `SuggestionModel`.

## Key Conventions

- **QML ↔ C++ boundary**: Models are injected as context properties in `main.cpp` (e.g., `engine.rootContext()->setContextProperty("photoModel", &model)`). QML calls C++ slots via these properties; C++ emits signals that QML connects to with `Connections {}`.
- **Translations**: Strings in QML use `qsTr()`; C++ uses `tr()`. Translation files are in `Languages/fre.ts` and `eng.ts`. Run `lupdate` to extract new strings, `lrelease` to compile `.qm` files (CMake does this automatically at build time).
- **ExifTool config**: Custom tag definitions live in `Bin/exiftool.config` — edit this when adding support for non-standard EXIF/IPTC tags.
- **Developer API docs**: https://sphinkie.github.io/tiPhotoLocator/doxygen/html/index.html
