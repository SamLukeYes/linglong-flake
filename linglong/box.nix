{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, libseccomp
, libyamlcpp
, linglong-dbus-proxy
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "linglong-box";
  version = "1.3.3.15-1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "${version}";
    hash = "sha256-Wwx7azcfZh2HBZMYXinHUDbzHAfywRx42asxDrQ/zu0=";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ gtest libseccomp libyamlcpp ];

  cmakeFlags = [
    "-DBUILD_STATIC=OFF"
  ];

  postPatch = ''
    substituteInPlace src/container/container.cpp \
      --replace "/usr/bin/ll-dbus-proxy" "${linglong-dbus-proxy}/bin/ll-dbus-proxy"
  '';

  meta = with lib; {
    description = "Linglong sandbox";
    homepage = "https://github.com/linuxdeepin/linglong-box";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
