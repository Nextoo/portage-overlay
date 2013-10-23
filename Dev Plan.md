Current dev plan
================

	- [x] Kernel ebuild
	- [ ] Initramfs ebuild
	- [ ] Installation script
	- [ ] Installation script ebuild
	- [ ] Metapackage for base system wtih dependencies on all above



[00:23] <TomWij> aarontc: There's multiple ways to obtain the sources and/or kernel in mind; one way is to use the existing *-sources that exist and create a *-kernel for them (eg. gentoo-kernel uses gentoo-sources), another way is to just fetch the sources as part of the *-kernel ebuild, yet another way is to fetch a prebuilt kernel although I think we might rather want to use binpkg for that.
[00:24] <TomWij> aarontc: Well, I'm not so sure if we can integrate them, it is pending some future EAPI work that might or might not happen; one of the things I'd really like to see is have external kernel modules rebuild if you emerge the kernel again, but for that to work you need virtual sub slot pass-through to work.
[00:25] <aarontc> igli: Primarily because there are helper functions for architecture detection, versioning, etc, which would be useful for any ebuild or eclass needing to work with kernel sources or binaries, I think, but they are inaccessible without inheriting from kernel-2, which assumes the ebuild is a kernel-sources ebuild
[00:25] <igli> ah ok
[00:26] <TomWij> Because currently you can say "external module depends on sub slot X of kernel Y"; but in reality, we support multiple different kernels, so we have to say something like "external module needs to depend on sub slot X of all kernels through a virtual" which we can't currently do.
[00:26] <igli> ouch
[00:27] <TomWij> bug #449094 covers the passthrough subslots
[00:27] <willikins> TomWij: https://bugs.gentoo.org/449094 "Support for "passthru subslots" to rebuild all the reverse dependency graph."; Gentoo Hosted Projects, PMS/EAPI; CONF; slyfox:pms-bugs
[00:28] <TomWij> aarontc: What we also have to note is that prior works exists on building kernels, see bug #472906 which links Bertrand's work as well as Fabio's Sabayon work.
[00:28] <willikins> TomWij: https://bugs.gentoo.org/472906 "(initial) portage kernel building support"; Gentoo Linux, Core system; CONF; zerochaos:zerochaos
[00:29] <TomWij> There's like an entire function using genkernel at https://github.com/Sabayon/sabayon-distro/blob/master/eclass/sabayon-kernel.eclass#L499 so if we want to let the user opt between manual and genkernel it might be handy to adapt that code so we don't need to write the genkernel portion from scratch.
[00:30] <TomWij> Besides choosing the way we pick up the source (*-sources VS fetch it) we also need to see what would be the most sane way to manage the .config.
[00:31] <TomWij> The .config _needs_ the kernel source tree; so, *-sources seems more handy unless we go crazy and extract just the Kconfig related tree from the kernel sources and install just that.
[00:32] <TomWij> And how would one start menuconfig / nconfig; `emerge --config =sys-kernel/*-sources-*` comes to mind
[00:32] <TomWij> but I haven't yet thought true if that's a good or bad way at doing things.
[00:32] <aarontc> TomWij: My initial stab at this before talking with you and igli was an ebuild modeled after gentoo-sources, which downloads the source, injects a .config from files/, makes the kernel, installs the kernel/modules/firmware, and uses genkernel to generate an initramfs
[00:32] <TomWij> (Then the user picks whether menuconfig or nconfig or ... is wanted in /etc/portage/make.conf)
[00:33] <TomWij> And we also will likely need to take `make oldconfig` into account in one or another way.
[00:33] <igli> ok
