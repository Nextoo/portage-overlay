# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5
SLOT=0

DESCRIPTION="NeXToo Server base metapackage"
HOMEPAGE="http://www.nextoo.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND="
	nextoo/nextoo-base

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
