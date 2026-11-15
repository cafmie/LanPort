"""PyInstaller entry point for the frozen LanPort.exe."""

from pc_transfer.__main__ import main

if __name__ == "__main__":
    raise SystemExit(main())
