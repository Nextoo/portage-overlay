# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5
SLOT=0

DESCRIPTION="NeXToo virtual for message transfer agent"
HOMEPAGE="http://www.nextoo.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND="
	|| (
		mail-mta/nullmailer

		mail-mta/courier
		mail-mta/postfix
	)
"
