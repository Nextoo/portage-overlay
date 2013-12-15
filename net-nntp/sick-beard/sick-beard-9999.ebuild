# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Originally from https://github.com/soehest/gentoo/blob/master/net-nntp/sickbeard/sickbeard-9999.ebuild (2013/12/15)

EAPI=4

PYTHON_DEPEND="2:2.7"

EGIT_REPO_URI="https://github.com/midgetspy/Sick-Beard.git"

inherit eutils user git-2 python

DESCRIPTION="Automatic TV-Series downloader for SABnzbd"
HOMEPAGE="https://github.com/midgetspy/Sick-Beard#readme"

LICENSE="GPL-2" # only
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/cheetah
"

pkg_setup() {
	# Control PYTHON_USE_WITH
	python_set_active_version 2
	python_pkg_setup

	# Create sick-beard group
	enewgroup ${PN}
	# Create sick-beard user, put in sick-beard group
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_install() {
	dodoc readme.md

	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	# Location of cache files
	keepdir /var/cache/${PN}
	fowners -R ${PN}:${PN} /var/cache/${PN}

	# Location of data files
	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	keepdir /var/log/${PN}
	fowners -R ${PN}:${PN} /var/log/${PN}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}
	doins "${FILESDIR}/config.ini"

	# Rotation of log files
	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# weird stuff ;-)
	last_commit=$(git rev-parse HEAD)
	echo ${last_commit} > version.txt

	insinto /usr/share/${PN}
	doins -r autoProcessTV cherrypy data lib sickbeard tests CONTRIBUTING.md COPYING.txt SickBeard.py version.txt
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}

	elog "Sick-Beard has been installed with data directories in /var/lib/${PN}"
	elog
	elog "New user/group ${PN}/${PN} has been created"
	elog
	elog "Config file is located in /etc/${PN}/config.ini"
	elog
	elog "Please configure /etc/conf.d/${PN} before starting daemon!"
	elog
	elog "Start with '${ROOT}etc/init.d/${PN} start'"
	elog "Visit http://<host ip>:8081 to configure Sick-Beard"
	elog
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
