{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, libseccomp
, libyamlcpp
, linglong-dbus-proxy
, makeWrapper
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "linglong-box";
  version = "1.3.3.14";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-D/m9Ip4n+8pJIYppn6PtO+DYIrkZo+xwnGX50p+5uyc=";
  };

  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];

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
  };
}