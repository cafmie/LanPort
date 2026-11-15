LanPort — Host / Main PC installer
==================================

This install uses LanPort.exe (no separate Python install required).

1. Start Menu → LanPort (Host), or run run-host.bat in the install folder.
2. Browser opens http://127.0.0.1:8787/ (LAN: http://<lan-ip>:8787/).
3. On first launch, pick ホスト（メイン） if asked.
4. Pair screen shows this PC’s LAN IP + ports for the handheld to connect.

Default args: LanPort.exe --role main --name "Main PC"

Allow inbound TCP 8787 and UDP 8788 on the LAN firewall.
Handheld: install LanPort-Handheld-Setup.exe (or use the portable ZIP).

Repo / releases: https://github.com/cafmie/LanPort
