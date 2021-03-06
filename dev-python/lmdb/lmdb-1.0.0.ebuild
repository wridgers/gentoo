# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Python bindings for the Lightning Database"
HOMEPAGE="https://github.com/jnwatson/py-lmdb/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-db/lmdb:="
DEPEND="${RDEPEND}"

distutils_enable_sphinx docs
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/jnwatson/py-lmdb/commit/2d0f93984f53c19925f07d742584f5e3e69d7902
	"${FILESDIR}/${P}-pypy3.patch"
)

python_compile() {
	LMDB_FORCE_SYSTEM=1 distutils-r1_python_compile
}

python_test() {
	pytest tests -vv || die "Tests fail with ${EPYTHON}"
}

python_install() {
	# This is required when the CFFI extension is used (for PyPy3)
	LMDB_FORCE_SYSTEM=1 distutils-r1_python_install
}
