#!/bin/bash
linuxdeployqt /media/nextsigner/ZONA-A1/nsp/unik-recursos/build_unik_linux_64/unik -qmldir=/media/nextsigner/ZONA-A1/nsp/unik -appimage -always-overwrite -bundle-non-qt-libs -no-plugins
mv /media/nextsigner/ZONA-A1/nsp/unik-recursos/build_unik_linux_64.AppImage /home/nextsigner/Escritorio/unik_v$1.AppImage
