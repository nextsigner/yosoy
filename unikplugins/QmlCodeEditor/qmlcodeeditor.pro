TEMPLATE = lib
CONFIG += plugin
QT += qml gui quick widgets
TARGET  = qmlcodeeditor

linux{
    !android{
 qmakeforce.target = dummy
  qmakeforce.commands = rm -f Makefile ##to force rerun of qmake
  qmakeforce.depends = FORCE
  PRE_TARGETDEPS += $$qmakeforce.target
  QMAKE_EXTRA_TARGETS += qmakeforce
DESTDIR= /media/nextsigner/ZONA-A1/nsp/unik/unik/qml/QmlCodeEditor
        message(Destino GNU/Linux NO Android $$DESTDIR)
    }
}
win32{
    qmakeforce.target = dummy
    qmakeforce.commands = cmd /c del Makefile ##to force rerun of qmake
    qmakeforce.depends = FORCE
    PRE_TARGETDEPS += $$qmakeforce.target
    QMAKE_EXTRA_TARGETS += qmakeforce
    DESTDIR= H:/nsp/unik/build_win_unik_32/qml/QmlCodeEditor
    message(Destino Windows $$DESTDIR)
}
#DESTDIR = /home/nextsigner/Escritorio/prueba/LogView


SOURCES += qmlcodeeditor.cpp \
    myeditor.cpp
#QMAKE_PRE_LINK += $$quote(rm -R $${OUT_PWD}/*.o$$escape_expand(\n\t))
#message(-->$${OUT_PWD})
linux{    
    EXTRA_BINFILES += \
        $$PWD/qmldir \
        $$PWD/Boton.qml \
        $$PWD/LineResizeTop.qml \
        $$PWD/QmlCodeEditor.qml
    for(FILE,EXTRA_BINFILES){
        QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
    }
}

win32 {
    #...
    EXTRA_BINFILES += \
        $$PWD/qmldir \
        $$PWD/Boton.qml \
        $$PWD/LineResizeTop.qml \
        $$PWD/QmlCodeEditor.qml
    EXTRA_BINFILES_WIN = $${EXTRA_BINFILES}
    EXTRA_BINFILES_WIN ~= s,/,\\,g
        DESTDIR_WIN = $${DESTDIR}
    DESTDIR_WIN ~= s,/,\\,g
    for(FILE,EXTRA_BINFILES_WIN){
                QMAKE_POST_LINK +=$$quote(cmd /c copy /y $${FILE} $${DESTDIR_WIN}$$escape_expand(\n\t))
    }
}

DISTFILES += \
    QmlCodeEditor.qml \
    LineResizeTop.qml \
    qmldir

HEADERS += \
    myeditor.h
