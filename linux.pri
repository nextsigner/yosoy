# Compile this project with Qt 5.11.3 on GNU/Linux, Windows or Macos
# For Android you needs compile into GNU/Linux with Android SDK
# and Android NDK r16b or later

message(linux.pri is loaded)

!android{
    message(Linux NO ANDROID)
    !contains(QMAKE_HOST.arch, arm.*):{
        QT += webengine webview
        DD1=$$replace(PWD, /unik,/build_unik_linux_5_11)
        DESTDIR= $$DD1
        message(Ubicaciòn del Ejecutable: $$DESTDIR)

        FILE_VERSION_NAME=$$replace(PWD, /unik,/build_unik_linux_64/linux_version)
        FILE_VERSION_NAME2=\"$$FILE_VERSION_NAME\"
        write_file(/tmp/linux_version, APPVERSION)
        message(File version location: $$FILE_VERSION_NAME2)

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
        /tmp/linux_version
        for(FILE,EXTRA_BINFILES){
            QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
            message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
        }

        #Deploy Command Line Example
        #linuxdeployqt /media/nextsigner/ZONA-A1/nsp/build_unik_linux/unik -qmldir=/media/nextsigner/ZONA-A1/nsp/unik -verbose=3

    #Copy resourses and translation folder manualy

    #TO CREATE APPIMAGE FILE
    #/home/nextsigner/Descargas/linuxdeployqt-continuous-x86_64.AppImage /media/nextsigner/ZONA-A1/nsp/build_unik_linux_5_11/unik -qmldir=/media/nextsigner/ZONA-A1/nsp/unik -appimage -always-overwrite
    }else{
        #Set Working Directory for RPI3 compilation in /home/pi/nsp
        DESTDIR= /home/pi/unik
        message(Current Executable Path: $$DESTDIR)
        message(Current Working Directory: $$PWD)
        SOURCES += mmapGpio.cpp
        HEADERS += mmapGpio.h

    COMPILEINRPI = 1
    DEFINES += UNIK_COMPILE_RPI=\\\"$$COMPILEINRPI\\\"

        #Building Quazip from Ubuntu 16.10
        #Compile quazip.pro and install with sudo make install from the $$OUT_PWD
        INCLUDEPATH += $$PWD/quazip
        LIBS += -lz
        LIBS+=-L/usr/local/zlib/lib
        INCLUDEPATH+=/usr/local/zlib/include
        HEADERS += $$PWD/quazip/*.h
        SOURCES += $$PWD/quazip/*.cpp
        SOURCES += $$PWD/quazip/*.c

        #COPIAR ARCHIVOS NECESARIOS EN RPI3
        QMAKE_POST_LINK += $$quote(mkdir $${DESTDIR}/qml$$escape_expand(\n\t))
        QMAKE_POST_LINK += $$quote(mkdir $${DESTDIR}/qml/LogView$$escape_expand(\n\t))

        EXTRA_BINFILES += \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/qmldir \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/liblogview.so \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/Boton.qml \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/LineResizeTop.qml \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/LogView.qml
        for(FILE,EXTRA_BINFILES){
            QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}/qml/LogView$$escape_expand(\n\t))
            message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
        }

        #COPIAR ARCHIVOS NECESARIOS EN RPI3 RAIZ
        EXTRA_BINFILES2 += \
        $$PWD/logo_unik.png
        for(FILE2,EXTRA_BINFILES2){
            QMAKE_POST_LINK += $$quote(cp $${FILE2} $${DESTDIR}$$escape_expand(\n\t))
            #message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
        }
    }
}else{
    message(QT_MESSAGELOGCONTEXT defined for Android)
    DEFINES += QT_MESSAGELOGCONTEXT

    FILE_VERSION_NAME=$$PWD/android/assets/android_version
    FILE_VERSION_NAME2=\"$$FILE_VERSION_NAME\"
    write_file(/tmp/android_version, APPVERSION)
    message(File version location: $$FILE_VERSION_NAME2)

    QMAKE_POST_LINK += $$quote(cp /tmp/android_version $${PWD}/android/assets/android_version$$escape_expand(\n\t))
}
