# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5
SLOT=0

DESCRIPTION="NeXToo Desktop base metapackage"
HOMEPAGE="http://www.nextoo.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND="
	nextoo-meta/nextoo-base

	app-arch/deb2targz
	app-arch/p7zip

	app-emulation/wine
	app-emulation/winetricks

	app-office/libreoffice
	dev-java/icedtea-bin

	media-fonts/font-bitstream-100dpi

	media-gfx/gimp
	media-gfx/imagemagick
	media-gfx/xsane

	media-libs/exiftool
	media-libs/freeglut

	media-sound/audacity
	media-sound/paprefs
	media-sound/pavucontrol
	media-sound/pianobar
	media-sound/picard
	media-sound/pulseaudio
	media-sound/qtmpc

	media-video/vlc

	net-ftp/filezilla

	net-im/pidgin
	net-im/skype

	net-irc/konversation

	net-misc/dropbox
	net-misc/tightvnc

	net-print/hplip
	net-print/xerox-drivers

	net-proxy/privoxy

	sys-block/gparted

	www-client/firefox
	www-client/google-chrome
	www-client/opera
	www-plugins/adobe-flash
	www-plugins/google-talkplugin

	x11-apps/mesa-progs
	x11-base/xorg-server
	x11-drivers/nvidia-drivers
	x11-misc/synergy
	x11-misc/x11vnc
	x11-terms/eterm
	x11-terms/xterm
	x11-wm/fluxbox
"
