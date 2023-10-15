{ lib
, stdenv
, fetchFromGitHub
, cmake
, dbus
, gtest
, pkg-config
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

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ];

  buildInputs = [ dbus gtest ];

  postPatch = ''
    substituteInPlace src/proxy/dbus_proxy.cpp \
      --replace "/usr/share" "$out/share"
  '';

  meta = with lib; {
    description = "A dbus proxy for linglong applications which run in the linglong-box";
    homepage = "https://github.com/linuxdeepin/linglong-dbus-proxy";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
