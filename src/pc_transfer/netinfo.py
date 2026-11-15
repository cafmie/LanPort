"""LAN address helpers for host pairing UI."""

from __future__ import annotations

import socket
from typing import Optional


def _outbound_ipv4() -> Optional[str]:
    """Best-effort primary LAN IP via the route used for outbound IPv4."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            # No packets are sent; OS picks the outbound interface.
            sock.connect(("8.8.8.8", 80))
            ip = sock.getsockname()[0]
        finally:
            sock.close()
    except OSError:
        return None
    if not ip or ip.startswith("127."):
        return None
    return ip


def list_lan_ipv4() -> list[str]:
    """Return non-loopback IPv4 addresses for this host (best-effort).

    The first entry is the preferred primary address when available.
    """
    ordered: list[str] = []
    seen: set[str] = set()

    def add(ip: Optional[str]) -> None:
        if not ip or ip.startswith("127.") or ip in seen:
            return
        seen.add(ip)
        ordered.append(ip)

    add(_outbound_ipv4())

    try:
        hostname = socket.gethostname()
        for info in socket.getaddrinfo(hostname, None, socket.AF_INET, socket.SOCK_STREAM):
            add(info[4][0])
    except OSError:
        pass

    primary = [ip for ip in ordered if not ip.startswith("169.254.")]
    link_local = [ip for ip in ordered if ip.startswith("169.254.")]
    return primary + link_local


def primary_lan_ipv4() -> Optional[str]:
    addrs = list_lan_ipv4()
    return addrs[0] if addrs else None
