{ lib
, stdenv
, fetchFromGitHub
, cmake
, dbus
, gtest
, pkgconfig
, qttools
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "linglong-dbus-proxy";
  version = "1.3.3.10-1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "${version}";
    hash = "sha256-buFizjxmlqd7Ewdnbx35OPfJi3IlSvgWxd/vYytQygE=";
  };

  nativeBuildInputs = [ cmake pkgconfig qttools wrapQtAppsHook ];

  buildInputs = [ dbus gtest ];

  meta = with lib; {
    description = "A dbus proxy for linglong applications which run in the linglong-box";
    homepage = "https://github.com/linuxdeepin/linglong-dbus-proxy";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
