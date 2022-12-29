{ lib
, stdenv
, fetchFromGitHub
, cmake
, curl
, gdk-pixbuf
, glib
, gtest
, libarchive
, libselinux
, libsepol
, libyamlcpp
, ostree
, pcre
, pkgconfig
, qttools
, qtwebsockets
, util-linux
, wrapGAppsHook
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "linglong";
  version = "1.3.3.22";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lFtpI5dFSPH+yNLpwXEPpTqMCYo/LwkUG3iHWb1n7P4=";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
    wrapGAppsHook
    wrapQtAppsHook
  ];

  buildInputs = [
    curl
    gdk-pixbuf
    glib
    gtest
    libarchive
    libselinux
    libsepol
    libyamlcpp
    ostree
    pcre
    qtwebsockets
    util-linux
  ];

  postPatch = ''
    for cmakefile in $(find . -name CMakeLists.txt); do
      substituteInPlace $cmakefile \
        --replace "DESTINATION /usr" "DESTINATION $out" \
        --replace "DESTINATION /etc" "DESTINATION $out/etc" \
        --replace "DESTINATION /lib" "DESTINATION $out/lib"
    done
    for file in \
      src/package_manager/misc/org.deepin.linglong.PackageManager.service \
      src/package_manager/misc/systemd/org.deepin.linglong.PackageManager.service \
      src/service/misc/xdg/org.deepin.linglong.service.desktop \
      src/system_helper/misc/org.deepin.linglong.SystemHelper.service \
      src/system_helper/misc/systemd/org.deepin.linglong.SystemHelper.service
    do
      substituteInPlace $file \
        --replace "/usr/bin" "$out/bin"
    done
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "The container application toolkit of deepin";
    homepage = "https://linglong.dev";
    license = licenses.gpl3Plus;
  };
}