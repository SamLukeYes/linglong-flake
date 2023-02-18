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
, linglong-box
, ostree
, pcre
, pkgconfig
, procps
, qttools
, qtwebsockets
, runtimeShell
, util-linux
, wrapGAppsHook
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "linglong";
  version = "1.3.5-1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "${version}";
    hash = "sha256-13mE8tArdfiriBTw7XkcySAawF3dPhc7KcXlnKg/M3s=";
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
  ];

  patches = [
    ./ostree-pid.patch
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

    for source in \
      src/builder/builder/linglong_builder.cpp \
      src/module/runtime/app.cpp
    do
      substituteInPlace $source \
        --replace "/usr/bin/ll-box" "${linglong-box}/bin/ll-box"
    done
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ostree procps util-linux ]}"
    "--set SHELL ${runtimeShell}"
  ];

  meta = with lib; {
    description = "The container application toolkit of deepin";
    homepage = "https://linglong.dev";
    license = licenses.gpl3Plus;
  };
}