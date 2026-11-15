from __future__ import annotations

from pc_transfer.netinfo import list_lan_ipv4, primary_lan_ipv4


def test_list_lan_ipv4_returns_list() -> None:
    addrs = list_lan_ipv4()
    assert isinstance(addrs, list)
    for ip in addrs:
        assert isinstance(ip, str)
        assert ip.count(".") == 3
        assert not ip.startswith("127.")


def test_primary_lan_ipv4_matches_list() -> None:
    addrs = list_lan_ipv4()
    primary = primary_lan_ipv4()
    if addrs:
        assert primary == addrs[0]
    else:
        assert primary is None
