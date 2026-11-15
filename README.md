# LanPort

Desktop LAN tool for moving **game installs** and **save data** between a main Windows PC and a handheld Windows sub-PC on the same network.

- Same-LAN peer discovery (UDP broadcast) + manual IP connect
- Bidirectional HTTP transfer
- Manual registration of game folder + save folder(s) (no Steam auto-resolve)
- Games ship as ZIP archives; saves sync afterward with a **freshness check** (newer wins by default)
- In-app verification of registered paths (exists / size / last modified)
- Controller-first UI for handhelds (D-pad focus, A/B confirm/back)

## Requirements

| Machine | Needs |
|---------|--------|
| **Main PC** | Python 3.10+ (use `setup.bat` / `run-main.bat`) |
| **Handheld / sub-PC** | **No Python** — use the portable `LanPort.exe` ZIP |

Both machines on the same LAN; allow inbound TCP/UDP on the app ports (default **8787** HTTP, **8788** discovery).

> Linux/macOS can run the same source for development and tests. Native folder picker needs a desktop session with tkinter; use typed paths or `PC_TRANSFER_HEADLESS=1` in CI.

## Quick start (Windows)

### Main PC (Python)

1. Install [Python 3.10+](https://www.python.org/downloads/) and enable **Add python.exe to PATH**.
2. Clone this repo (or unzip a source release).
3. Double-click **`setup.bat`** once (creates `.venv`, installs runtime deps).
4. Double-click **`run-main.bat`** to start as main.

Optional device name: `run-main.bat "Living Room PC"`

Manual equivalent:

```powershell
git clone https://github.com/cafmie/LanPort.git
cd LanPort
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -e .
python -m pc_transfer --role main --name "Main PC"
```

### Handheld / sub-PC (portable — no Python)

The handheld must run **without installing Python**.

1. Download **`LanPort-windows-portable`** from [GitHub Actions](https://github.com/cafmie/LanPort/actions/workflows/windows-portable.yml) (artifact on `main` / PR builds), or from a [GitHub Release](https://github.com/cafmie/LanPort/releases) once a portable ZIP / `LanPort.exe` is attached.
2. Unzip anywhere (e.g. `Desktop\LanPort`).
3. Double-click **`run-handheld.bat`** (launches `LanPort.exe` only — no venv, no pip).

Optional name: `run-handheld.bat Ally`

Direct exe:

```text
LanPort.exe --role handheld --name Ally
```

> This repository does **not** commit a prebuilt `.exe`. CI builds it on `windows-latest`. Until a Release attaches the artifact, grab it from the Actions run for the commit you want.

## Run (dev / source)

**Main PC**

```powershell
python -m pc_transfer --role main --name "Main PC"
# or: lanport --role main --name "Main PC"
```

**Handheld** (source only — prefer the portable exe on real handhelds)

```powershell
python -m pc_transfer --role handheld --name "Ally"
```

The UI opens at `http://127.0.0.1:8787/`. Other devices on the LAN reach this machine at `http://<lan-ip>:8787/`.

Useful flags:

| Flag | Meaning |
|------|---------|
| `--port 8787` | HTTP listen port |
| `--no-browser` | Do not auto-open a browser |
| `--data-dir PATH` | Override settings/registry location |
| `--headless` | Disable tkinter folder picker |

Data defaults to `%LOCALAPPDATA%\PCTransfer` on Windows, or `~/.local/share/pc-transfer` elsewhere. Override with `PC_TRANSFER_DATA`.

## Typical flow

1. Start the app on both PCs (main: `run-main.bat`, handheld: `run-handheld.bat` + exe).
2. On the first screen, pick **ホスト（メイン）** or **サブ（ハンディ）** (D-pad + **A**). Last choice is remembered; use **役割を変更** to switch.
3. **Host:** the Pair screen shows this PC’s **LAN IP** (large) plus HTTP/discovery ports — copy the IP for the sub if needed.
4. **Sub:** peers auto-appear, or enter the host LAN IP under Manual connect.
5. On each PC, open **Games** → **Add game** and pick the install folder + save folder.
6. On **Transfer**, choose the game + peer → **Send game ZIP**, then **Sync saves**.
7. Open **Verify** to confirm paths exist and review size / last modified.

Save sync policy:

- **Newer wins** — compare mtime; keep the newer file
- **Always use incoming** — overwrite local saves
- **Prompt** — marks conflicts; non-interactive default keeps local

## Controller map (handheld)

| Input | Action |
|-------|--------|
| D-pad / Left stick | Move focus (role picker + tabs) |
| **A** (South) | Confirm / activate (role pick / buttons) |
| **B** (East) | Back / cancel form |
| **Y** (North) | Refresh peers or run verify |
| **X** (West) | Jump to Transfer |
| **LB / RB** | Previous / next tab |

Keyboard: arrows, Enter, Escape. Mouse still works on the main PC.

Use a browser that exposes the Gamepad API (Edge / Chrome). For a kiosk-like handheld setup, pin the Edge window fullscreen.

## Build portable Windows exe (maintainers)

Built automatically by **`.github/workflows/windows-portable.yml`** (artifact name: `LanPort-windows-portable`).

On a Windows machine with Python 3.10+:

```bat
scripts\build-windows.bat
```

Produces `dist\LanPort.exe`. Package it next to `run-handheld.bat` for handheld users.

Optional extras: `pip install -e ".[build]"` then `pyinstaller --noconfirm --clean lanport.spec`.

For the next GitHub Release, attach the Actions artifact ZIP (or `LanPort.exe`) — this change does not publish a new Release by itself.

## Tests

```powershell
pip install -e ".[dev]"
pytest -q
```

CI-friendly (no GUI picker):

```powershell
$env:PC_TRANSFER_HEADLESS = "1"
pytest -q
```

## Project layout

```
LanPort/
  setup.bat                 # main PC: create .venv + pip install -e .
  run-main.bat              # main PC launcher (calls setup if needed)
  run-handheld.bat          # handheld: launch LanPort.exe only (no Python)
  lanport.spec              # PyInstaller onefile spec (uses assets/icon.ico)
  assets/                   # app icon source (icon.webp) + PNG/ICO builds
  scripts/build-windows.bat # local Windows portable build
  scripts/generate-icons.py # regenerate PNG/ICO from assets/icon.webp (Pillow)
  .github/workflows/        # windows-portable CI artifact
  src/pc_transfer/          # discovery, ZIP transfer, save sync, FastAPI app
    web/                    # controller-first UI + favicon / PWA icons
  tests/
  README.md
```

Python import paths remain `pc_transfer` (and `python -m pc_transfer`) for compatibility; the product name is **LanPort**.

## Windows notes / verification checklist

These should be confirmed on real Windows hardware (main + handheld):

- [ ] UDP discovery across the LAN (firewall rules for 8788/udp and 8787/tcp)
- [ ] Large game ZIP transfer durability on Wi-Fi handhelds
- [ ] XInput controller focus in Edge/Chrome Gamepad API
- [ ] tkinter folder picker under Windows (main / source builds)
- [ ] Portable `LanPort.exe` on handheld without Python installed
- [ ] Paths with non-ASCII characters under `%USERPROFILE%\Documents\My Games\...`
