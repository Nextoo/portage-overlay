# Copyright 1999-2013 Gentoo Foundation
# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

# Common parts
EAPI="5"
KEYWORDS="amd64 x86"
HOMEPAGE="http://www.nextoo.org/"
DESCRIPTION="Binary Linux kernel build of Gentoo-patched sources from the ${KV_MAJOR}.${KV_MINOR} tree, as well as initramfs built using Genkernel"
LICENSE="GPL-2"
SLOT="0"
RESTRICT=""

# Kernel parts
ETYPE="sources"
K_GENPATCHES_VER="1"
K_DEBLOB_AVAILABLE="0"


inherit kernel-2
detect_version
detect_arch


GENPATCH_PREFIX="genpatches-${PV}-${K_GENPATCHES_VER}"

SRC_URI="
	${KERNEL_URI}
	mirror://gentoo/${GENPATCH_PREFIX}.base.tar.xz
	mirror://gentoo/${GENPATCH_PREFIX}.extras.tar.xz
	${ARCH_URI}"

UNIPATCH_LIST="
	${GENPATCH_PREFIX}.base.tar.xz
	${GENPATCH_PREFIX}.extras.tar.xz"

DEPEND="sys-kernel/genkernel[crypt,cryptsetup]"

src_configure() {
	cp "${FILESDIR}/config-${PVR}" .config
	# Dirty hack to prevent portage internals from influencing config generation...
	# Also consider set_arch_to_kernel() from linux-info.eclass?
	old_arch="${ARCH}"
	unset ARCH
	emake silentoldconfig
	export ARCH="${old_arch}"
}

src_compile() {
	kernel-2_src_compile

	old_arch="${ARCH}"
	unset ARCH
	emake
	export ARCH="${old_arch}"
}

src_install() {
	old_arch="${ARCH}"
	unset ARCH

	# Install modules and firmware
	emake INSTALL_MOD_PATH="${D}" modules_install
	emake INSTALL_MOD_PATH="${D}" firmware_install

	# Install bzimage
	mkdir -p "${D}/boot"
	INSTALLKERNEL=false emake INSTALL_PATH="${D}/boot" install

	# Generate initramfs
	mkdir -p "${WORKDIR}/genkernel"
	mkdir -p "${T}/genkernel-temp"
	mkdir -p "${T}/genkernel-cache"
	genkernel  --logfile="${WORKDIR}/genkernel/genkernel.log" --kerneldir="${WORKDIR}/linux-${KV_FULL}" --kernel-config="${WORKDIR}/linux-${KV_FULL}/.config" --lvm --mdadm --dmraid --e2fsprogs --iscsi --disklabel --luks --gpg --unionfs --no-postclear --tempdir="${T}/genkernel-temp" --cachedir="${T}/genkernel-cache" --firmware --firmware-dir="${D}/lib/firmware" --compress-initramfs --compress-initramfs-type=best --makeopts="${MAKEOPTS}" --no-mountboot --bootdir="${D}/boot" initramfs

	export ARCH="${old_arch}"
}


pkg_postinst() {
	return
}

pkg_postrm() {
	return
}
