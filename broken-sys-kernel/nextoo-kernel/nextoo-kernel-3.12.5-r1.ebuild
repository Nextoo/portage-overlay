# Copyright 1999-2013 Gentoo Foundation
# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

# Common parts
EAPI="5"

# Kernel parts
ETYPE="sources"
K_GENPATCHES_VER="6"
K_DEBLOB_AVAILABLE="0"
inherit kernel-2
detect_version
detect_arch

# NexToo parts
DESCRIPTION="Binary Linux kernel build of Gentoo-patched sources from the ${KV_MAJOR}.${KV_MINOR} tree, as well as initramfs built using Genkernel"
HOMEPAGE="http://www.nextoo.org/"
IUSE="${IUSE/build}"
IUSE="${IUSE/symlink}"
KEYWORDS="amd64 x86"
LICENSE="GPL-2"
RESTRICT="splitdebug"
SLOT="3.12.5-r1"





GENPATCH_PREFIX="genpatches-${KV_MAJOR}.${KV_MINOR}-${K_GENPATCHES_VER}"

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
	emake modules_prepare
	export ARCH="${old_arch}"

	# parts of kernel-2_src_compile()
	local file

	cd "${S}"
	dodir /usr/src
	echo ">>> Copying configured sources ..."

	file="$(find ${WORKDIR} -iname "docs" -type d)"
	if [[ -n ${file} ]]; then
		for file in $(find ${file} -type f); do
			echo "${file//*docs\/}" >> "${S}"/patches.txt
			echo "===================================================" >> "${S}"/patches.txt
			cat ${file} >> "${S}"/patches.txt
			echo "===================================================" >> "${S}"/patches.txt
			echo "" >> "${S}"/patches.txt
		done
	fi

	if [[ ! -f ${S}/patches.txt ]]; then
		# patches.txt is empty so lets use our ChangeLog
		[[ -f ${FILESDIR}/../ChangeLog ]] && \
			echo "Please check the ebuild ChangeLog for more details." \
			> "${S}"/patches.txt
	fi

	# Deploy configured sources to the image directory
	cp -a ${WORKDIR}/linux* "${D}"/usr/src
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

	# Fix up symlinks for kernel module build and source
	rm "${D}/lib/modules/${KV_FULL}/build"
	rm "${D}/lib/modules/${KV_FULL}/source"

	cd "${D}/lib/modules/${KV_FULL}"
	ln -s "/usr/src/linux-${KV_FULL}" build
	ln -s "/usr/src/linux-${KV_FULL}" source
	cd -

	# Install bzimage
	mkdir -p "${D}/boot"
	INSTALLKERNEL=false emake INSTALL_PATH="${D}/boot" install

	# Generate initramfs
	mkdir -p "${WORKDIR}/genkernel"
	mkdir -p "${T}/genkernel-temp"
	mkdir -p "${T}/genkernel-cache"
	genkernel --logfile="${WORKDIR}/genkernel/genkernel.log" --kerneldir="${WORKDIR}/linux-${KV_FULL}" --kernel-config="${WORKDIR}/linux-${KV_FULL}/.config" --lvm --mdadm --dmraid --e2fsprogs --iscsi --disklabel --luks --gpg --unionfs --no-postclear --tempdir="${T}/genkernel-temp" --cachedir="${T}/genkernel-cache" --firmware --firmware-dir="${D}/lib/firmware" --compress-initramfs --compress-initramfs-type=best --makeopts="${MAKEOPTS}" --no-mountboot --bootdir="${D}/boot" initramfs

	# Install System.map for module building
	cp "${WORKDIR}/linux-${KV_FULL}/System.map" "${D}/usr/src/linux-${KV_FULL}/System.map"

	# Cleanup from build
	emake clean
	export ARCH="${old_arch}"

	kernel-2_src_install
}


pkg_postinst() {
	# Remove any existing symlink
	[[ -h "${ROOT}/usr/src/linux" ]] && rm "${ROOT}/usr/src/linux"

	# Generate symlink
	cd "${ROOT}/usr/src"
	ln -sf linux-${KV_FULL} linux
	cd ${OLDPWD}
}

pkg_postrm() {
	return
}
