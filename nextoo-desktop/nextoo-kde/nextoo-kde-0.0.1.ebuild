# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5
SLOT=0

DESCRIPTION="NeXToo Desktop KDE metapackage"
HOMEPAGE="http://www.nextoo.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND="
	nextoo-meta/nextoo-desktop

	app-cdr/k3b

	kde-base/dolphin-plugins
	kde-base/kde-meta

	kde-misc/kfilebox

	media-sound/amarok

	net-misc/ksshaskpass

	net-p2p/bitcoin-qt
	net-p2p/ktorrent
"
