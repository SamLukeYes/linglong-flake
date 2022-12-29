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
  version = "1.3.3.3.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-095BL9DtZlAE4+IIRJPSqphjRjY5mWm3j5qhr2gBi2M=";
  };

  nativeBuildInputs = [ cmake pkgconfig qttools wrapQtAppsHook ];

  buildInputs = [ dbus gtest ];

  meta = with lib; {
    description = "A dbus proxy for linglong applications which run in the linglong-box";
    homepage = "https://github.com/linuxdeepin/linglong-dbus-proxy";
    license = licenses.gpl3Plus;
  };
}