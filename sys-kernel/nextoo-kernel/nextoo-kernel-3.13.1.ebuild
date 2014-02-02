# Copyright 1999-2013 Gentoo Foundation
# Copyright 2013 Aaron Ten Clay <aarontc@aarontc.com>
# Distributed under the terms of the GNU General Public License v2

# Common parts
EAPI="5"

# Kernel parts
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="9"
K_DEBLOB_AVAILABLE="0"
# inherit kernel-2
inherit eutils toolchain-funcs versionator multilib python-any-r1

detect_version
detect_arch

# Nextoo parts
DESCRIPTION="Binary Linux kernel build of Gentoo-patched sources from the ${KV_MAJOR}.${KV_MINOR} tree, as well as initramfs built using Genkernel"
HOMEPAGE="http://www.nextoo.org/"
KEYWORDS="amd64 x86"
LICENSE="GPL-2"

SLOT="3.12.8"

IUSE=""


RDEPEND="sys-kernel/genkernel[crypt,cryptsetup]"


# kernel-2 src_unpack from the kernel-2.eclass file ( /usr/portage/eclass/kernel-2.eclass )

src_unpack() {
	universal_unpack
	debug-print "Doing unipatch"

	[[ -n ${UNIPATCH_LIST} || -n ${UNIPATCH_LIST_DEFAULT} || -n ${UNIPATCH_LIST_GENPATCHES} ]] && \
		unipatch "${UNIPATCH_LIST_DEFAULT} ${UNIPATCH_LIST_GENPATCHES} ${UNIPATCH_LIST}"

	debug-print "Doing premake"

	# allow ebuilds to massage the source tree after patching but before
	# we run misc `make` functions below
	[[ $(type -t kernel-2_hook_premake) == "function" ]] && kernel-2_hook_premake

	debug-print "Doing epatch_user"
	epatch_user

	debug-print "Doing unpack_set_extraversion"

	[[ -z ${K_NOSETEXTRAVERSION} ]] && unpack_set_extraversion
	unpack_fix_install_path

	# Setup xmakeopts and cd into sourcetree.
	env_setup_xmakeopts
	cd "${S}"

	# We dont need a version.h for anything other than headers
	# at least, I should hope we dont. If this causes problems
	# take out the if/fi block and inform me please.
	# unpack_2_6 should now be 2.6.17 safe anyways
	if [[ ${ETYPE} == headers ]]; then
		kernel_is 2 4 && unpack_2_4
		kernel_is 2 6 && unpack_2_6
	fi

	if [[ $K_DEBLOB_AVAILABLE == 1 ]] && use deblob ; then
		cp "${DISTDIR}/${DEBLOB_A}" "${T}" || die "cp ${DEBLOB_A} failed"
		cp "${DISTDIR}/${DEBLOB_CHECK_A}" "${T}/deblob-check" || die "cp ${DEBLOB_CHECK_A} failed"
		chmod +x "${T}/${DEBLOB_A}" "${T}/deblob-check" || die "chmod deblob scripts failed"
	fi

	# fix a problem on ppc where TOUT writes to /usr/src/linux breaking sandbox
	# only do this for kernel < 2.6.27 since this file does not exist in later
	# kernels
	if [[ -n ${KV_MINOR} &&  ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH} < 2.6.27 ]] ; then
		sed -i \
			-e 's|TOUT      := .tmp_gas_check|TOUT  := $(T).tmp_gas_check|' \
			"${S}"/arch/ppc/Makefile
	else
		sed -i \
			-e 's|TOUT      := .tmp_gas_check|TOUT  := $(T).tmp_gas_check|' \
			"${S}"/arch/powerpc/Makefile
	fi
}

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
