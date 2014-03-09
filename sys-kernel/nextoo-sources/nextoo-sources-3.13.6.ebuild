# Copyright 2014 Nextoo Linux
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Official Nextoo Linux Standard kernel sources"
HOMEPAGE="http://www.nextoo.org/"
KEYWORDS="amd64 x86"
LICENSE="GPL-2"
RESTRICT="splitdebug"
SLOT="3.13.6"


SRC_URI="
	${KERNEL_URI}
	mirror://gentoo/${GENPATCH_PREFIX}.base.tar.xz
	mirror://gentoo/${GENPATCH_PREFIX}.extras.tar.xz
	${ARCH_URI}"

UNIPATCH_LIST="
	${GENPATCH_PREFIX}.base.tar.xz
	${GENPATCH_PREFIX}.extras.tar.xz"
