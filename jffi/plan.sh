pkg_name=jffi
pkg_origin=core
pkg_version="1.2.18"
pkg_license=('Apache-2.0')
pkg_description="Java Foreign Function Interface"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_source="https://github.com/jnr/jffi/archive/${pkg_name}-${pkg_version}.tar.gz"
pkg_dirname="${pkg_name}-${pkg_name}-${pkg_version}"
pkg_shasum="05326c985153e4c86449b9732cbaa39c7570f079cd0f1276c2f5df40ebacbd92"
pkg_upstream_url="https://github.com/jnr/jffi"
pkg_deps=(
  core/glibc
  core/libffi
  core/gcc-libs
  core/jre8
)
pkg_build_deps=(
  core/jdk8
  core/ant
  core/pkg-config
  core/make
  core/gcc
  core/file
  core/diffutils
  core/maven
)

do_prepare() {
  build_line "replacing /usr/bin/file with $(pkg_path_for core/file)/bin/file"
  sed -i "s,/usr/bin/file,$(pkg_path_for core/file)/bin/file,g" "jni/libffi/configure"

  export USE_SYSTEM_LIBFFI=1
  export JAVA_HOME
  JAVA_HOME="$(pkg_path_for jdk8)"
}

do_build() {
  ant jar
  ant -Djava.library.path="${LD_RUN_PATH}" archive-platform-jar
  mvn -Djava.library.path="${LD_RUN_PATH}" package
}

do_install() {
  cp -r target "${pkg_prefix}"
}

# Strip was unable to recognise the format of the input file libjffi-1.2.so
do_strip() {
  return 0
}
