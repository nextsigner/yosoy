message(windows.pri is loaded)

FILE_VERSION_NAME=windows_version
QT += webengine
DESTDIR = ../build_win_unik_32
RC_FILE = unik.rc
LIBS += -L$$PWD/../libvlc-qt/lib/ -lVLCQtCore -lVLCQtWidgets -lVLCQtQml
 INCLUDEPATH += $$PWD/../libvlc-qt/include
 DEPENDPATH += $$PWD/../libvlc-qt/include

FILE_VERSION_NAME=$$replace(PWD, /unik,/build_win_unik_32/windows_version)
FILE_VERSION_NAME3=$$replace(PWD, /unik,/build_win_unik_32/windows_version)
FILE_VERSION_NAME2=\"$$FILE_VERSION_NAME\"
write_file(windows_version, APPVERSION)
message(File version location: $$FILE_VERSION_NAME2)

#Building Quazip from Windows 8.1
INCLUDEPATH += $$PWD/quazip
DEFINES+=QUAZIP_STATIC
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c

EXTRA_BINFILES += $$PWD/windows_version
EXTRA_BINFILES_WIN = $${EXTRA_BINFILES}
EXTRA_BINFILES_WIN ~= s,/,\\,g
DESTDIR_WIN = $$replace(PWD, /unik,/build_win_unik_32/windows_version)
DESTDIR_WIN ~= s,/,\\,g
for(FILE,EXTRA_BINFILES_WIN){
        QMAKE_POST_LINK +=$$quote(cmd /c copy /y $${FILE} $${DESTDIR_WIN}$$escape_expand(\n\t))
}
