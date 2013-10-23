# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=5
SLOT=0

DESCRIPTION="NeXToo Base metapackage"
HOMEPAGE="http://www.nextoo.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND="
	app-admin/sudo
	app-admin/syslog-ng

	app-arch/pbzip2

	app-backup/rdiff-backup

	app-editors/nano

	app-misc/ckermit
	app-misc/screen

	app-portage/eix
	app-portage/gentoolkit
	app-portage/layman
	app-portage/ufed

	dev-lang/ruby

	dev-ruby/rubygems

	mail-client/nail

	|| (
		mail-mta/nullmailer
		mail-mta/postfix
		mail-mta/courier
	)

	net-analyzer/iptraf-ng
	net-analyzer/mtr
	net-analyzer/nethogs
	net-analyzer/nmap
	net-analyzer/traceroute

	net-dns/bind-tools

	net-fs/nfs-utils

	net-ftp/ncftp

	net-misc/dhcpcd
	net-misc/iperf
	net-misc/keychain
	net-misc/ntp
	net-misc/openssh
	net-misc/openvpn
	net-misc/telnet-bsd

	sys-apps/hdparm
	sys-apps/less
	sys-apps/lshw
	sys-apps/iproute2
	sys-apps/pciutils
	sys-apps/setserial
	sys-apps/smartmontools
	sys-apps/usbutils

	sys-auth/nss-mdns

	>=sys-boot/grub-2.0
	sys-boot/os-prober

	sys-fs/cachefilesd
	sys-fs/cryptsetup
	sys-fs/ddrescue
	sys-fs/dosfstools
	sys-fs/exfat-utils
	sys-fs/fuse-exfat
	sys-fs/inotify-tools
	sys-fs/mdadm
	sys-fs/ntfs3g
	sys-fs/xfsprogs

	sys-kernel/nextoo-kernel

	|| (
		sys-power/apcupsd
		sys-power/nut
	)

	sys-process/atop
	sys-process/htop
	sys-process/lsof
	sys-process/vixie-cron

	www-client/links
"
