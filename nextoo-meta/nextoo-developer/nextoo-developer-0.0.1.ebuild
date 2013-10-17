# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="NeXToo Desktop developer metapackage"
SLOT=0

RDEPEND="
	app-doc/doxygen
	app-doc/pms

	app-emulation/virt-manager
	app-emulation/virtualbox

	app-text/sloccount

	dev-db/pgadmin3
	dev-db/postgresql-server
	dev-db/sqliteman

	dev-java/ant

	dev-lang/ghc
	dev-lang/mono
	dev-lang/php:5.3

	dev-php/phpunit
	dev-php/xdebug

	dev-python/pip
	dev-python/python-distutils-extra
	dev-python/virtualenv

	dev-qt/qt-creator

	dev-util/android-sdk-update-manager
	dev-util/bsdiff
	dev-util/cgdb
	dev-util/codeblocks
	dev-util/cppcheck
	dev-util/kdevelop
	dev-util/premake
	dev-util/splint
	dev-util/strace

	dev-vcs/git
	dev-vcs/git-cola
	dev-vcs/git-sh
	dev-vcs/mercurial
	dev-vcs/qgit

	net-analyzer/wireshark

	net-dialup/minicom

	net-libs/nodejs

	net-misc/gupnp-tools

	sci-electronics/kicad

	sys-devel/gdb
	sys-devel/sparse

	www-servers/lighttpd
"
