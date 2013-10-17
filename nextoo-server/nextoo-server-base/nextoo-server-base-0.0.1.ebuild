# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="NeXToo Server base metapackage"
SLOT=0

RDEPEND="
	nextoo-meta/nextoo-base

	app-admin/logsentry

	net-analyzer/fail2ban
	net-analyzer/tcpdump
	net-analyzer/zabbix

	net-firewall/ebtables
	net-firewall/ipset
	net-firewall/shorewall
	net-firewall/shorewall6

	net-misc/bridge-utils

	sys-block/tw_cli
"
