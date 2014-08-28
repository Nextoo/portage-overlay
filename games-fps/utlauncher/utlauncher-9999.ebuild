# Distributed under the terms of the GNU General Public License v2

EAPI=5
GIT_ECLASS="git-2"

inherit games ${GIT_ECLASS}

DESCRIPTION="A standalone application to join UT4 servers."
HOMEPAGE="https://github.com/CodeCharmLtd/UTLauncher"
SRC_URI=""
EGIT_REPO_URI="https://github.com/CodeCharmLtd/UTLauncher.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	x11-libs/libxkbcommon
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8.12
	dev-vcs/git
"

src_compile() {
	git submodule update --init --recursive
	#cmake . -DCMAKE_BUILD_TYPE=Release
	# make debug version while we figure out why it's not displaying servers
	cmake .
	make
}

src_install() {
	dogamesbin UTLauncher || die "dogamesbin failed"
	make_desktop_entry UTLauncher "Unreal Tournament 4 Launcher"
	# TODO: install licence file
}
