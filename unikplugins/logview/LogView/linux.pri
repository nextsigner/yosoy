message(linux.pri is loaded)
    qmakeforce.target = dummy
    qmakeforce.commands = rm -f Makefile
    qmakeforce.depends = FORCE
    PRE_TARGETDEPS += $$qmakeforce.target
    QMAKE_EXTRA_TARGETS += qmakeforce
!contains(QMAKE_HOST.arch, arm.*):{
    message(Developing from GNU/Linux)

    DESTDIR= $$[QT_INSTALL_QML]/LogView

    #DestDir for a unik probe
    DESTDIR=../build


    EXTRA_BINFILES += \
    $${PWD}/qmldir \
    $${PWD}/Boton.qml \
    $${PWD}/LineResizeTop.qml \
    $${PWD}/LogView.qml
    for(FILE,EXTRA_BINFILES){
        QMAKE_POST_LINK += $$QMAKE_COPY $$quote($$FILE) $$quote($$DESTDIR) $$escape_expand(\\n\\t)
        message($$quote(Copyng cp $${FILE} $${DESTDIR}$$escape_expand(\n\t)))
    }
}else{
    DESTDIR= $$PWD/build_LogView_linux_rpi/qml
    message(Destino GNU/Linux RPI3 $$DESTDIR)
}
message(DESTDIR: $$DESTDIR)
message(OUT_PWD: $$OUT_PWD)
