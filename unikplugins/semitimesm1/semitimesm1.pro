TEMPLATE = lib
CONFIG += plugin
QT += qml

DESTDIR = /home/nextsigner/Escritorio/prueba/SemitimesM1
TARGET  = semitimesm1

SOURCES += semitimesm1.cpp
#QMAKE_PRE_LINK += $$quote(rm -R $${OUT_PWD}/*.o$$escape_expand(\n\t))
#message(-->$${OUT_PWD})
#QMAKE_CLEAN += "$$slasher("$${OUT_PWD}/*.*")"
#QMAKE_CLEAN += \Q
linux{
    #...
    EXTRA_BINFILES += \
        $$PWD/qmldir \
        $$PWD/SemitimesM1.qml
    for(FILE,EXTRA_BINFILES){
        QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
    }
}

win32 {
    #...
    EXTRA_BINFILES += \
        $${THIRDPARTY_PATH}/glib-2.0/win32/bin/libglib-2.0.dll \
        $${THIRDPARTY_PATH}/glib-2.0/win32/bin/libgmodule-2.0.dll
    EXTRA_BINFILES_WIN = $${EXTRA_BINFILES}
    EXTRA_BINFILES_WIN ~= s,/,\\,g
        DESTDIR_WIN = $${DESTDIR}
    DESTDIR_WIN ~= s,/,\\,g
    for(FILE,EXTRA_BINFILES_WIN){
                QMAKE_POST_LINK +=$$quote(cmd /c copy /y $${FILE} $${DESTDIR_WIN}$$escape_expand(\n\t))
    }
}
