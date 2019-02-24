message(macos.pri is loaded)
    qmakeforce.target = dummy
    qmakeforce.commands = rm -f Makefile
    qmakeforce.depends = FORCE
    PRE_TARGETDEPS += $$qmakeforce.target
    QMAKE_EXTRA_TARGETS += qmakeforce
    message(Developing from Macos)


    #DestDir for a unik probe
    FOLDER_ROOT=$$replace(PWD,/LogView, /build/LogView)
    DESTDIR=$$FOLDER_ROOT

    EXTRA_BINFILES += \
    $${PWD}/qmldir \
    $${PWD}/Boton.qml \
    $${PWD}/LineResizeTop.qml \
    $${PWD}/LogView.qml
    for(FILE,EXTRA_BINFILES){
        QMAKE_POST_LINK += $$QMAKE_COPY $$quote($$FILE) $$quote($$DESTDIR) $$escape_expand(\\n\\t)
        message($$quote(Copyng cp $${FILE} $${DESTDIR}$$escape_expand(\n\t)))
    }


message(DESTDIR: $$DESTDIR)
message(OUT_PWD: $$OUT_PWD)
