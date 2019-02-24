message(linux.pri is loaded)

QT += webengine
DESTDIR=../unik-recursos/build_osx_clang64

#FILE_VERSION_NAME=macos_version

FILE_VERSION_NAME=$$replace(PWD, /unik,/build_osx_clang64/macos_version)
FILE_VERSION_NAME2=\"$$FILE_VERSION_NAME\"
write_file(/tmp/macos_version, APPVERSION)
message(File version location: $$FILE_VERSION_NAME2)

QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11
message(Unikode Desarrollo en Mac)
ICON = logo.icns
QMAKE_INFO_PLIST = Info.plist

#Building Quazip from Ubuntu 16.10
#Compile quazip.pro and install with sudo make install from the $$OUT_PWD
INCLUDEPATH += $$PWD/quazip
LIBS += -lz
LIBS+=-L/usr/local/zlib/lib
INCLUDEPATH+=/usr/local/zlib/include
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c

#COPIAR ARCHIVOS DENTRO DE APPIMAGE
EXTRA_BINFILES += \
/tmp/macos_version
for(FILE,EXTRA_BINFILES){
    QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}/unik.app/Contents/MacOS$$escape_expand(\n\t))
    message(Copyng $${FILE} $${DESTDIR}/unik.app/Contents/MacOS$$escape_expand(\n\t))
}

#APP_QML_FILES.files = ffmpegsumo.so
#APP_QML_FILES.path = Contents/Resources
#QMAKE_BUNDLE_DATA += APP_QML_FILES

#Deploy command line example
#/Users/qt/Qt5.9.1/5.9.1/clang_64/bin/macdeployqt /Users/qt/nsp/unik-recursos/build_osx_clang64/unik.app -qmldir=/Users/qt/nsp/unik -no-strip -dmg
