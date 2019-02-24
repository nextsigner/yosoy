TEMPLATE = lib
CONFIG += plugin
QT += qml
TARGET  = logview

LIBNAME=LogView

linux{
    !android{
        include(linux.pri)
    }else{
            DESTDIR=$$[QT_INSTALL_QML]/$${LIBNAME}
            message(Destino Android $$DESTDIR)

            OBJECTS_DIR = $$PWD/../../../.obj
            MOC_DIR = $$PWD/../../../.moc
            RCC_DIR = $$PWD/../../../.r
            message(----> $${DESTDIR})

            target.path=$${DESTDIR}/
            target.files=$${PWD}/*.qml
            INSTALLS += target
    }
}
macos{
    include(macos.pri)
}
win32{
    qmakeforce.target = dummy
    qmakeforce.commands = cmd /c del Makefile ##to force rerun of qmake
    qmakeforce.depends = FORCE
    PRE_TARGETDEPS += $$qmakeforce.target
    QMAKE_EXTRA_TARGETS += qmakeforce
    #DESTDIR= ../unik-recursos/build_win_unik_32/qml/LogView
    DESTDIR= ../../../unik-recursos/build_win_unik_32/qml/LogView
    message(Destino Windows $$DESTDIR)
}

SOURCES += logview.cpp

win32 {
    #...
    EXTRA_BINFILES += \
        $$PWD/qmldir \
        $$PWD/Boton.qml \
        $$PWD/LineResizeTop.qml \
        $$PWD/LogView.qml
    EXTRA_BINFILES_WIN = $${EXTRA_BINFILES}
    EXTRA_BINFILES_WIN ~= s,/,\\,g
        DESTDIR_WIN = $${DESTDIR}
    DESTDIR_WIN ~= s,/,\\,g
    for(FILE,EXTRA_BINFILES_WIN){
                QMAKE_POST_LINK +=$$quote(cmd /c copy /y $${FILE} $${DESTDIR_WIN}$$escape_expand(\n\t))
    }
}

OTHER_FILES+= ../main.qml

android{
DISTFILES += \
    LogView.qml \
    Boton.qml \
    LineResizeTop.qml \
    linux.pri
}

DISTFILES += \
    macos.pri
