#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>

#include <QQuickImageProvider>
#include <QSettings>

#ifndef Q_OS_ANDROID
#include <stdio.h>
#include <stdlib.h>
#endif

#ifdef Q_OS_WIN
#include <VLCQtCore/Common.h>
#include <VLCQtQml/QmlVideoPlayer.h>
#endif

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>
#include <QDateTime>
#include <QtWidgets/QMessageBox>
#include <QStandardPaths>
#include <QPluginLoader>
#include <QtWidgets/QMessageBox>
#include "uk.h"
#ifndef Q_OS_ANDROID
#include "qmlclipboardadapter.h"
#ifndef __arm__
#include <QtWebEngine/QtWebEngine>
#endif
#else
#include <android/log.h>
#include <QtWebView>
#include <QtAndroid>
#endif

#include "chatserver.h"
#include "unikargsproc.h"
#include "uniklogobject.h"


#ifdef Q_OS_ANDROID
    #ifndef __arm__
        UK *u0;
    #endif
#endif

        UnikLogObject ulo;


QByteArray debugData;
QString debugPrevio;
bool abortar=false;
#ifndef  Q_OS_ANDROID
UK u;
//A debug log method for send messages to QML LogView and stdout aplication
void unikStdOutPut(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QTextStream out(stdout);
    QByteArray localMsg = msg.toLocal8Bit();
    debugData="";
    abortar=false;
    switch (type) {
    case QtDebugMsg:
        debugData.append("Unik Debug: (");
        debugData.append(msg);
        if(context.file!=NULL){
            fprintf(stderr, "Debug: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
            debugData.append(",");
            debugData.append(context.file);
            debugData.append(",");
            debugData.append(QString::number(context.line));
            debugData.append(",");
            debugData.append(context.function);
        }else{
            fprintf(stderr, "Debug: %s\n", localMsg.constData());
        }
        debugData.append(")\n");
        break;
    case QtInfoMsg:
        debugData.append("Unik Info: (");
        debugData.append(msg);
        if(context.file!=NULL){
            fprintf(stderr, "Info: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
            debugData.append(",");
            debugData.append(context.file);
            debugData.append(",");
            debugData.append(QString::number(context.line));
            debugData.append(",");
            debugData.append(context.function);
        }else{
            fprintf(stderr, "Info: %s\n", localMsg.constData());
        }
        debugData.append(")\n");
        break;
    case QtWarningMsg:
        debugData.append("Unik Warning: (");
        debugData.append(msg);
        if(context.file!=NULL){
            fprintf(stderr, "Warning: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
            debugData.append(",");
            debugData.append(context.file);
            debugData.append(",");
            debugData.append(QString::number(context.line));
            debugData.append(",");
            debugData.append(context.function);
        }else{
            fprintf(stderr, "Warning: %s\n", localMsg.constData());
        }
        debugData.append(")\n");
        break;
    case QtCriticalMsg:
        debugData.append("Unik Critical: (");
        debugData.append(msg);
        if(context.file!=NULL){
            fprintf(stderr, "Critical: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
            debugData.append(",");
            debugData.append(context.file);
            debugData.append(",");
            debugData.append(QString::number(context.line));
            debugData.append(",");
            debugData.append(context.function);
        }else{
            fprintf(stderr, "Critical: %s\n", localMsg.constData());
        }
        debugData.append(")\n");
        break;
    case QtFatalMsg:
        debugData.append("Unik Fatal: (");
        debugData.append(msg);
        debugData.append(",");
        debugData.append(context.file);
        debugData.append(",");
        debugData.append(context.line);
        debugData.append(",");
        debugData.append(context.function);
        debugData.append(")\n");
        abortar=true;
    }
    u.log(debugData);
#ifdef Q_OS_WIN
    out << debugData;
#endif
    if(abortar){
        //abort();
    }
}
#else
static void android_message_handler(QtMsgType type,
                                    const QMessageLogContext &context,
                                    const QString &message)
{
    android_LogPriority priority = ANDROID_LOG_DEBUG;
    switch (type) {
    case QtDebugMsg: priority = ANDROID_LOG_DEBUG; break;
    case QtWarningMsg: priority = ANDROID_LOG_WARN; break;
    case QtCriticalMsg: priority = ANDROID_LOG_ERROR; break;
    case QtFatalMsg: priority = ANDROID_LOG_FATAL; break;
    };

    __android_log_print(priority, "Qt", "%s", qPrintable(message));
   #ifndef __arm__
        u0->log(message.toUtf8());
    #else
    ulo.setLog(message.toUtf8());
    #endif
}
#endif
int main(int argc, char *argv[])
{
#ifdef Q_OS_LINUX
    qputenv("LD_PRELOAD","/usr/lib/x86_64-linux-gnu/libnss3.so");
     qInfo()<<"LD_PRELOAD: "<<qgetenv("LD_PRELOAD");
#endif

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationDisplayName("yosoy");
    app.setApplicationName("yosoy");
    app.setOrganizationDomain("http://www.unikode.org/");
    app.setOrganizationName("unikode.org");

    QDir cAppPath=QDir::current();

    UnikArgsProc uap;//Object for to process arguments
    bool showLaunch=true;
    for (int i = 0; i < argc; ++i) {
        QByteArray a;
        a.append(argv[i]);
        uap.args.append(a);
        if(a=="-nl"){
            showLaunch=false;
        }
        qInfo()<<"UAP ADDING ARG "<<i<<" : "<<argv[i];
    }
    uap.init();
    showLaunch=uap.showLaunch;
    qInfo()<<"UAP argv: "<<uap.args;
    qInfo()<<"UAP showLaunch: "<<uap.showLaunch;

#ifdef Q_OS_ANDROID
    UK u; //For other OS this declaration is defined previus the main function
    u.setObjectName("uk3");
    auto  result = QtAndroid::checkPermission(QString("android.permission.CAMERA"));
            if(result == QtAndroid::PermissionResult::Denied){
                QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.CAMERA"}));
                if(resultHash["android.permission.CAMERA"] == QtAndroid::PermissionResult::Denied)
                    return 0;
            }
            auto  result2 = QtAndroid::checkPermission(QString("android.permission.WRITE_EXTERNAL_STORAGE"));
                if(result2 == QtAndroid::PermissionResult::Denied){
                    QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.WRITE_EXTERNAL_STORAGE"}));
                    if(resultHash["android.permission.WRITE_EXTERNAL_STORAGE"] == QtAndroid::PermissionResult::Denied)
                        return 0;
                }
                auto  result3 = QtAndroid::checkPermission(QString("android.permission.READ_EXTERNAL_STORAGE"));
                    if(result3 == QtAndroid::PermissionResult::Denied){
                        QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.READ_EXTERNAL_STORAGE"}));
                        if(resultHash["android.permission.READ_EXTERNAL_STORAGE"] == QtAndroid::PermissionResult::Denied)
                            return 0;
                    }
                    auto  result4 = QtAndroid::checkPermission(QString("android.permission.INTERNET"));
                        if(result4 == QtAndroid::PermissionResult::Denied){
                            QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.INTERNET"}));
                            if(resultHash["android.permission.INTERNET"] == QtAndroid::PermissionResult::Denied)
                                return 0;
                        }
#endif


    QString nomVersion="";
#ifdef Q_OS_LINUX
#ifdef Q_OS_ANDROID
    nomVersion="android_version";
#else
#ifdef __arm__
    nomVersion="linux_rpi_version";
#else
    nomVersion="linux_version";
#endif
#endif
#endif
#ifdef Q_OS_WIN
    //carpComp.append(QString(UNIK_CURRENTDIR_COMPILATION));
    nomVersion="windows_version";
#endif
#ifdef Q_OS_OSX
    //carpComp.append("/Users/qt/nsp/unik-recursos/build_osx_clang64/unik.app/Contents/MacOS");
    nomVersion="macos_version";
#endif  
    QString nv;
    QString fvp;
#ifdef Q_OS_ANDROID
    fvp.append("assets:");
#else
    fvp.append(qApp->applicationDirPath());
#endif
    fvp.append("/");
    fvp.append(nomVersion);
    qDebug() << "UNIK FILE VERSION: " << fvp;
    QFile fileVersion(fvp);
    fileVersion.open(QIODevice::ReadOnly);
    nv = fileVersion.readAll();
    fileVersion.close();

    qDebug() << "UNIK VERSION: " << nv;
    app.setApplicationVersion(nv.toUtf8());
    bool updateDay=false;
    QSettings settings;
#ifdef _WIN32
    if (AttachConsole(ATTACH_PARENT_PROCESS)) {
        freopen("CONOUT$", "w", stdout);
        freopen("CONOUT$", "w", stderr);
    }
#endif


    QByteArray user="unik-free";
    QByteArray key="free";
    QByteArray appArg1="";
    QByteArray appArg2="";
    QByteArray appArg3="";
    QByteArray appArg4="";
    QByteArray appArg5="";
    QByteArray appArg6="";

#ifndef __arm__
    #ifdef UNIK_COMPILE_ANDROID_X86
        QByteArray urlGit="https://github.com/nextsigner/yosoy-luz";
        QByteArray moduloGit="yosoy-luz";
    #else
        QByteArray urlGit="https://github.com/nextsigner/yosoy-luz";
        QByteArray moduloGit="yosoy-luz";
    #endif
#else
#ifdef Q_OS_ANDROID
    QByteArray urlGit="https://github.com/nextsigner/yosoy-luz";
    QByteArray moduloGit="yosoy-luz";
#else
    QByteArray urlGit="https://github.com/nextsigner/yosoy-luz-rpi";
    QByteArray moduloGit="yosoy-luz-rpi";
#endif
#endif
    QByteArray modoDeEjecucion="indefinido";
    QByteArray lba="";
    QString listaErrores;

    QString dim="";
    QString pos="";

    bool modeFolder=false;
    bool modeFolderToUpk=false;
    bool modeRemoteFolder=false;
    bool modeUpk=false;
    bool modeGit=false;
    bool modeGitArg=false;
    bool updateUnikTools=false;
    bool debugLog=false;
    bool setPass=false;
    bool setPass1=false;
    bool setPass2=false;
    bool makeUpk=false;
    bool wss=false;
    bool params=false;


#ifdef Q_OS_ANDROID
    QtWebView::initialize();
#else
#ifndef __arm__
    QtWebEngine::initialize();
#endif
#endif

    QQmlApplicationEngine engine;
    u.setEngine(&engine);//Set engine for a variable access into the unik main instance.

    //Setting any unik vars for a QML interaction.
    engine.rootContext()->setContextProperty("engine", &engine);
    engine.rootContext()->setContextProperty("unik", &u);
    engine.rootContext()->setContextProperty("console", &u);
    engine.rootContext()->setContextProperty("unikLog", u.ukStd);
    engine.rootContext()->setContextProperty("unikError", listaErrores);

    //Setting any vars...
    engine.rootContext()->setContextProperty("wait", u.wait);
    engine.rootContext()->setContextProperty("splashvisible", u.splashvisible);
    engine.rootContext()->setContextProperty("setInitString", u.setInitString);

    //Clipboard function for GNU/Linux, Windows and Macos
#ifndef Q_OS_ANDROID
    QmlClipboardAdapter clipboard;
    engine.rootContext()->setContextProperty("clipboard", &clipboard);
#endif


    //Register VLC Video Player for Windows
#ifdef Q_OS_WIN
    qmlRegisterType<VlcQmlVideoPlayer>("VLCQt", 1, 0, "VlcVideoPlayer");
#endif


    //Install a Message Handler for GNU/Linux, Windows and Macos
#ifndef Q_OS_ANDROID
    qInstallMessageHandler(unikStdOutPut);
#else
    #ifndef __arm__
        u0=&u;
        qInstallMessageHandler(android_message_handler);
    #else
        qInstallMessageHandler(android_message_handler);
    #endif
#endif



    //Path WorkSpace
    QByteArray pws;
    pws.append(uap.ws);
    qInfo()<<"Path Unik: "<<pws;

    QString pq;
    pq.append(pws);
#ifndef __arm__
    #ifdef UNIK_COMPILE_ANDROID_X86
        pq.append("/yosoy-luz/");
    #else
        pq.append("/yosoy-luz/");
    #endif
#else
#ifdef Q_OS_ANDROID
    pq.append("/yosoy-luz/");
#else
    pq.append("/yosoy-luz-rpi/");
#endif
#endif
    QDir::setCurrent(pq);


    //Setting the application executable name.
    QString appExec = argv[0];
    qInfo()<<"appExec: "<<appExec;
    engine.rootContext()->setContextProperty("appExec", appExec);


    //This register is deprecated.  It will be eliminated.
    qmlRegisterType<UK>("uk", 1, 0, "UK");



    //Load the splah QML file.
#ifdef Q_OS_ANDROID
    engine.load("qrc:/SplashAndroid.qml");
#else
#ifndef __arm__
    engine.load("qrc:/Splash.qml");
#else
    engine.load("://Splash.qml");
#endif
#endif

    //Example Connection for unik engine into uk.cpp method.
    //QObject::connect(&engine, SIGNAL(warnings(QList<QQmlError>)), &u, SLOT(errorQML(QList<QQmlError>)));


    //Iterator for setting all application arguments from app args or cfg.json.
    for (int i = 0; i < uap.args.length(); ++i) {
        if(uap.args.at(i)==QByteArray("-debug")){
            debugLog=true;
        }
        QString arg;
        arg.append(uap.args.at(i));
        if(arg.contains("-user=")){
            QStringList marg = arg.split("-user=");
            if(marg.size()==2){
                user = "";
                user.append(marg.at(1));
            }
            setPass1=true;
        }
        if(arg.contains("-key=")){
            QStringList marg = arg.split("-key=");
            if(marg.size()==2){
                key = "";
                key.append(marg.at(1));
            }
            setPass2=true;
        }
        if(arg.contains("-dir=")){
            QStringList marg = arg.split("-dir=");
            if(marg.size()==2){
                QString ncp;
                ncp.append(marg.at(1));
                QDir fscd(ncp);
                if(!fscd.exists()){
                    fscd.mkdir(ncp);
                }
                QDir::setCurrent(ncp);

#ifndef Q_OS_WIN
                engine.addImportPath(QDir::currentPath());
                engine.addPluginPath(QDir::currentPath());
#else
                QString pip;
                pip.append("file:///");
                pip.append(QDir::currentPath());
                engine.addImportPath(pip);
                engine.addPluginPath(pip);
#endif
                qInfo()<<"-dir="<<marg.at(1);
                showLaunch=false;
                uap.showLaunch=false;
            }
        }
        //>-folder
        if(arg.contains("-folder=")){
            QStringList marg = arg.split("-folder=");
            if(marg.size()==2){
                modoDeEjecucion="-folder";
                appArg1="";
                appArg1.append(marg.at(0));
                appArg2="";
                appArg2.append(marg.at(1));
                QString ncp;
                ncp.append(appArg2);
                QDir fscd(ncp);
                if(!fscd.exists()){
                    fscd.mkdir(ncp);
                }
                QDir::setCurrent(ncp);
                showLaunch=false;
                uap.showLaunch=false;
                modeFolder=true;
                makeUpk=false;
                qInfo()<<"[-folder 1] Running in mode -folder="<<ncp;
                qInfo()<<"[-folder 2] Current application directory: "<<QDir::currentPath();
                updateDay=false;
                updateUnikTools=false;
                params=true;
            }
        }
        //<-folder

        if(arg.contains("-git=")){
            QStringList marg = arg.split("-git=");
            if(marg.size()==2){
                QString pUrlGit1;
                pUrlGit1.append(marg.at(1));
                lba="";
                lba.append("-git=");
                lba.append(marg.at(1));
                qInfo()<<lba;
                urlGit = "";
                if(pUrlGit1.contains(".git")||pUrlGit1.mid(pUrlGit1.size()-4, pUrlGit1.size())==".git"){
                    urlGit.append(pUrlGit1.mid(0, pUrlGit1.size()-4));
                }else{
                    urlGit.append(pUrlGit1);
                }
                QString pUrlGit2 = pUrlGit1;
                QStringList m100 = pUrlGit2.split("/");
                if(m100.size()>1){
                    //moduloGit="";
                    //moduloGit.append(m100.at(m100.size()-1));
                    QString mg1=QString(m100.at(m100.size()-1));
                    QString mg2=mg1.replace(".git","");
                    moduloGit="";
                    moduloGit.append(mg2);
                    modeGitArg=true;
                }
                showLaunch=false;
                uap.showLaunch=false;
                modeGit=true;
                params=true;
            }
        }
        if(arg.contains("-ws=")){
            QStringList marg = arg.split("-ws=");
            QString nws;
            nws.append(marg.at(1));
            if(marg.size()==2){
                qInfo()<<"Setting WorkSpace by user ws: "<<nws;
                bool nWSExist=false;
                QDir nWSDir(nws);
                if(nWSDir.exists()){
                    nWSExist=true;
                }else{
                    qInfo()<<"Making custom WorkSpace "<<nWSDir.currentPath();
                    nWSDir.mkpath(".");
                    if(nWSDir.exists()){
                        qInfo()<<"Custom WorkSpace now is ready: "<<nws;
                        nWSExist=true;
                    }
                }
                if(nWSExist){
                    qInfo()<<"Finishing the custom WorkSpace setting.";
                    u.setWorkSpace(nws);
                    pws.clear();
                    pws.append(nws);
                    modeGit=true;
                }
                params=true;
            }
        }
        if(arg.contains("-dim=")){
            QStringList marg = arg.split("-dim=");
            if(marg.size()==2){
                QString md0;
                md0.append(marg.at(1));
                QStringList md1=md0.split("x");
                if(md1.size()==2){
                    u.log("Dim: "+md0.toUtf8());
                    dim=md1.at(0)+"x"+md1.at(1);
                }
            }
            params=true;
        }
        if(arg.contains("-pos=")){
            QStringList marg = arg.split("-pos=");
            if(marg.size()==2){
                QString mp0;
                mp0.append(marg.at(1));
                QStringList mp1=mp0.split("x");
                if(mp1.size()==2){
                    u.log("Pos: x="+mp0.toUtf8());
                    pos=mp1.at(0)+"x"+mp1.at(1);
                }
                params=true;
            }
        }
        if(arg.contains("-wss")){
            wss=true;
            qInfo()<<"WebSocket Server init request...";
            params=true;
        }
    }

#ifndef Q_OS_ANDROID
    QWebChannel channel;
    u._channel=&channel;
    WebSocketClientWrapper *clientWrapper;
    u._clientWrapper=clientWrapper;
    ChatServer* chatserver = new ChatServer(&app);
    u._chatserver=chatserver;
    engine.rootContext()->setContextProperty("cs", u._chatserver);
    engine.rootContext()->setContextProperty("cw", u._clientWrapper);
    if(wss){
        QObject::connect(&u, &UK::initWSS, [=](const QByteArray ip, const int port, const QByteArray serverName){
            qInfo()<<"Unik Server Request: "<<ip<<":"<<port<<" Server Name: "<<serverName;

            QWebSocketServer *server;
            u._server=server;
            bool wsss=u.startWSS(ip, port, serverName);//WebSocketsServerStarted
            u._channel->registerObject(serverName.constData(), chatserver);
            qInfo()<<"Unik WebSockets Server Started: "<<wsss;

        });
    }
#else
    QWebChannel channel;
    u._channel=&channel;
    WebSocketClientWrapper *clientWrapper;
    u._clientWrapper=clientWrapper;
    ChatServer* chatserver = new ChatServer(&app);
    u._chatserver=chatserver;
    engine.rootContext()->setContextProperty("cs", u._chatserver);
    engine.rootContext()->setContextProperty("cw", u._clientWrapper);
#endif
    QObject::connect(&u, &UK::restartingApp, [=](){
        qApp->quit();
    });
    QObject::connect(&ulo, SIGNAL(logReceived(QByteArray)),
                                &u, SLOT(log(QByteArray)));




    //Setting debugLog as true by default.
    lba="";
    lba.append("unik debug enabled: ");
    lba.append(debugLog ? "true" : "false");
    qInfo()<<lba;
    u.debugLog = debugLog;
    u.debugLog=debugLog;

    //Define if any pass data was setted from args.
    if(setPass1&&setPass2){
        setPass=true;
    }
    engine.rootContext()->setContextProperty("ukuser", user);
    engine.rootContext()->setContextProperty("ukkey", key);


    //ApplicationWindow Magnitude Data
    if(dim!=""){
        engine.rootContext()->setContextProperty("dim", dim);
    }
    if(pos!=""){
        engine.rootContext()->setContextProperty("pos", pos);
    }

    QByteArray upkFileName;
    QString upkActivo="";

    QString unikFolder;
#ifndef Q_OS_ANDROID
    unikFolder.append(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));
#else
    unikFolder.append(u.getPath(3));
#endif
    unikFolder.append("/yosoy");
    QDir dirUnik(unikFolder);
    if(!dirUnik.exists()){
        dirUnik.mkpath(".");
    }
#ifdef Q_OS_ANDROID
    QByteArray mf;
    mf.append(unikFolder);
    mf.append("/yosoy-luz/main.qml");
    QFile m(mf);
    if(!m.exists()){
        //bool autd=u.downloadGit("https://github.com/nextsigner/yosoy-luz", unikFolder.toUtf8());
    }
#else
    if(!modeGit){
        QString cut;
#ifndef __arm__
        cut.append(u.getFile(pws+"/yosoy-luz/main.qml"));
        QByteArray utf;//yosoy-luz folder
        utf.append(pws);
        if(!cut.contains("objectName: \'yosoy-luz\'")){
            qInfo()<<"yosoy-luz have any fail! repairing..."<<pws;
            bool autd=u.downloadGit("https://github.com/nextsigner/yosoy-luz.git", pws);
#else
        cut.append(u.getFile(pws+"/yosoy-luz-rpi/main.qml"));
        if(!cut.contains("objectName: \'yosoy-luz\'")){
            qInfo("yosoy-luz have any fail! repairing..."+unikFolder.toUtf8());
            bool autd=u.downloadGit("https://github.com/nextsigner/yosoy-luz-rpi.git", unikFolder.toUtf8());
#endif
            if(autd){
                qInfo()<<"yosoy-luz repared.";
            }else{
                qInfo()<<"yosoy-luz is not repared.";
            }
        }else{
            qInfo("yosoy-luz module is ready!");
        }
    }
#endif


    //Define the Main Module Location
    QString mainModName;
    mainModName.append(unikFolder);
#ifndef Q_OS_ANDROID
    mainModName.append("/yosoy-luz");
#else
    mainModName.append("/yosoy-luz");
#endif

#ifdef __arm__
#ifndef Q_OS_ANDROID
    mainModName.append("-rpi");
#endif
#endif


    //Checking if exist the Main Module Path.
    qInfo()<<"Checking UTP exists...";
    QDir dirWS(unikFolder);
    QDir dirUnikToolsLocation(mainModName);
    QFile mainFile(mainModName+"/main.qml");
    if (!dirWS.exists()||!dirUnikToolsLocation.exists()||!mainFile.exists()) {
        dirWS.mkpath(".");
        qInfo()<<"Making folder "<<unikFolder;
        if(!dirUnikToolsLocation.exists()){
            dirUnikToolsLocation.mkpath(".");
        }
        bool unikToolDownloaded=false;
#ifndef __arm__
    #ifndef Q_OS_ANDROID
        unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/yosoy-luz", unikFolder.toUtf8());
    #endif
#else
#ifdef Q_OS_ANDROID
        if(showLaunch||uap.showLaunch){
            unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/yosoy-luz", unikFolder.toUtf8());
        }
#else
        unikToolDownloaded=u.downloadGit("https://github.com/nextsigner/yosoy-luz-rpi", unikFolder.toUtf8());
#endif
#endif


        //Log the Main Module Download Status.
        lba="";
#ifndef Q_OS_ANDROID
        lba.append("yosoy-luz ");
#else
        lba.append("yosoy-luz ");
#endif
        if(unikToolDownloaded){
            lba.append("downloaded.");
        }else {
            lba.append("is not downloaded!");
        }
        qInfo()<<lba;
    }else{
        qInfo()<<"Folder "<<unikFolder<<" pre existent.";
    }

    //Direct upk mode.
    if((argc == 2||argc == 3||argc == 4)&&!modeGit){
        QString argUpk;
        argUpk.append(argv[1]);
        QString ext=argUpk.mid(argUpk.size()-4,argUpk.size());
        if(ext==".upk"){
            qInfo()<<"Run mode upk direct file.";
            appArg1=QByteArray(argv[1]);
            modeUpk=true;
            updateUnikTools=false;
        }
    }

    //MODO -upk
    if((argc == 2||argc == 3||argc == 4||argc == 5||argc == 6)&&!modeGit&& QByteArray(argv[1])==QByteArray("-upk")){
        u.log("Loanding from mode -upk...");
        QString argUpk;
        argUpk.append(argv[2]);
        QString ext=argUpk.mid(argUpk.size()-4,argUpk.size());
        u.log("File extension: "+ext.toUtf8());
        if(ext==".upk"){
            if(debugLog){
                u.log("Run mode upk file.");
            }

            modeUpk=true;
            modeFolder=false;
            modeRemoteFolder=false;
            modeGit=false;
            modeFolderToUpk=false;
            updateUnikTools=false;
        }else{
            u.log("Upk file not valid: "+argUpk.toUtf8());
        }
    }

    //MODO -foldertoupk
    if((argc == 5||argc == 6) && QByteArray(argv[1])==QByteArray("-foldertoupk")){
        modoDeEjecucion="-foldertoupk";
        appArg1=QByteArray(argv[2]);
        appArg2=QByteArray(argv[3]);
        appArg3=QByteArray(argv[4]);

        modeFolderToUpk=true;
        makeUpk=false;
        updateUnikTools=false;
        if(debugLog){
            qInfo()<<"Prepare mode -foldertoupk.";
        }
    }

    //MODO -remoteFolder
    if((argc == 5 || argc == 6) && QByteArray(argv[1])==QByteArray("-remoteFolder")){
        modoDeEjecucion="-remoteFolder";
        /*appArg1=QByteArray(argv[2]);
        appArg2=QByteArray(argv[3]);
        appArg3=QByteArray(argv[4]);
        QByteArray ncf;
        ncf.append("{\"mode\":\"");
        ncf.append(argv[1]);
        ncf.append("\",");
        ncf.append("\"arg1\":\"");
        ncf.append(appArg1);
        ncf.append("\",");
        ncf.append("\"arg2\":\"");
        ncf.append(appArg2);
        ncf.append("\",");
        ncf.append("\"arg3\":\"");
        ncf.append(appArg3);
        ncf.append("\"}");
        QByteArray r;
        r.append(urlConfigJson);
        u.deleteFile(r);
        u.setFile(r, ncf);*/
        modeRemoteFolder=true;
        makeUpk=false;
        updateUnikTools=false;
    }

    //->Comienza configuracion OS
#ifdef Q_OS_LINUX
    QByteArray cf;
    cf.append(u.getPath(4));
    cf.append("/img");
    qInfo()<<"Unik Image Folder: "<<cf;
    QDir configFolder(cf);
    if(!configFolder.exists()){
        qInfo()<<"Making Unik Image Folder...";
        u.mkdir(cf);
    }
    QFile icon2(cf+"/unik.png");
    if(!icon2.exists()){
        QByteArray cf2;
        cf2.append(u.getPath(1));
        cf2.append("/unik.png");
        QFile icon(cf2);
        icon.copy(cf+"/unik.png");
        qInfo()<<"Copyng unik icon file: "<<cf2<<" to "<<cf+"/unik.png";
    }
#endif
    //<-Finaliza configuracion OS



    //Define temp folder name.
    QByteArray tempFolder;
    tempFolder.append(QDateTime::currentDateTime().toString("hhmmss"));

    QDir dir0(pq);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }
    QString appName;
    qInfo()<<"Count standar no uap arguments: "<<argc;
    if(modeUpk){
        qInfo("Mode Upk 1 procces...");
        if(debugLog){
            qDebug()<<"Upk filename: "<<appArg1;
            qDebug()<<"Upk user: "<<user;
            qDebug()<<"Upk key: "<<key;
        }
        QString sl2;
        sl2.append(appArg1);
        QString pathCorr;
        pathCorr = sl2.replace("\\", "/");
        QByteArray urlUpkCorr;
        urlUpkCorr.append(pathCorr);
        QStringList mAppName = sl2.split("/");
        QString nan = mAppName.at(mAppName.size()-1);
        //appName=nan.replace(".upk", "");
        if(pathCorr.mid(pathCorr.size()-4, pathCorr.size()-1)==QString(".upk")){
            QByteArray err;
            if(debugLog){
                lba="";
                lba.append("UPK detected: ");
                lba.append(pathCorr);
                qInfo()<<lba;
            }
        }
        QByteArray tf;
        tf.append(QDateTime::currentDateTime().toString("hhmmss"));
        pq="";
        pq.append(QStandardPaths::standardLocations(QStandardPaths::TempLocation).last());
        pq.append("/");
        pq.append(tf);
        u.mkdir(pq);
        pq.append("/");
        QFile upkCheck(urlUpkCorr);
        if(upkCheck.exists()&&u.upkToFolder(urlUpkCorr, user, key, pq.toUtf8())){
            if(debugLog){
                lba="";
                lba.append(argv[1]);
                lba.append(" extract successful...");
                qInfo()<<lba;
            }
            QStringList sl =sl2.split("/");
            QByteArray nAppName;
            nAppName.append(sl.at(sl.size()-1));
            upkActivo = nAppName;
            updateUnikTools=false;
            //engine2.rootContext()->setContextProperty("upkActivo", appName);
        }else{
            if(!upkCheck.exists()){
                listaErrores.append("Upk file does not exist!\n");
            }else{
                listaErrores.append("Upk unpack fail!\n");
                if(user!="unik-free"||key!="free"){
                    listaErrores.append("User or key pass error. \n \n");
                }
                if(debugLog){
                    lba="";
                    lba.append(argv[1]);
                    lba.append(" extract no successful...");
                    qInfo()<<lba;
                }
            }
        }
    }

    if(modeFolder){
        qInfo()<<"Running in folder mode: "<<appArg1<<" "<<appArg2<<" "<<appArg3;
        pq = "";
        pq.append(appArg2);
        pq.append("/");
        qInfo()<<"[-folder 22] appArg2="<<appArg2;
        qInfo()<<"[-folder 3] PQ="<<pq;
        qInfo()<<"[-folder 4] PWS="<<pws;
        /*QDir carpetaModeFolder(appArg2);
        QFile mainModeFolder(appArg2+"/main.qml");
        if(carpetaModeFolder.exists()&&mainModeFolder.exists()){
            u.log("Folder to -folder exist...");
            pq.append("/");
        }else{
            if(!carpetaModeFolder.exists()){
                u.log("Folder to -folder not exist...");
            }
            if(!mainModeFolder.exists()){
                u.log("main.qml to -folder not exist...");
            }
            pq="";
            pq.append(pws);
            qInfo()<<"[-folder 5] PQ="<<pq;
            engine.addImportPath(pq);
            engine.addPluginPath(pq);
#ifndef __arm__
            pq.append("/yosoy-luz/");
#else
#ifdef Q_OS_ANDROID
            pq.append("/yosoy-luz/");
#else
            pq.append("/yosoy-luz-rpi/");
#endif
#endif
        }*/
        qInfo()<<"[-folder 6] PQ="<<pq;
        u.mkdir(pq);
    }

    QString arg1Control;
    if(modeUpk){
        qInfo("Mode Upk 2 procces...");
        if(debugLog){
            lba="";
            lba.append("Prepare mode upk...");
            lba.append(" arg1: ");
            lba.append(appArg1);
            lba.append(" arg2: ");
            lba.append(user);
            lba.append(" arg3: ");
            lba.append(key);
            /*lba.append(" arg4: ");
            lba.append(appArg4);*/
            qInfo()<<lba;
        }

        //upk file
        QString arg1;
        arg1.append(appArg1);

        //Usuario
        QString arg2;
        arg2.append(user);

        //Clave
        QString arg3;
        arg3.append(key);

        //AppName
        QString arg4;
        arg4.append(arg1.replace(".upk", ""));


#ifdef Q_OS_WIN32
        QStringList sl =arg4.replace("\\","/").split("/");
#else
        QStringList sl =arg4.split("/");
#endif

        QByteArray nAppName;
        nAppName.append(sl.at(sl.size()-1));
        if(nAppName!=""){
            if(debugLog){
                lba="";
                lba.append("Run upkToFolder(\"");
                lba.append(arg1);
                lba.append("\", \"");
                lba.append(arg2);
                lba.append("\", \"");
                lba.append(arg3);
                lba.append("\", \"");
                lba.append(tempFolder);
                lba.append("\");");
                qInfo()<<lba;
            }
            if(u.upkToFolder(arg1.toUtf8(), user, key, tempFolder)){
                if(setPass){
                    //user = arg2.toLatin1();
                    //key = arg3.toLatin1();
                }
                lba="";
                lba.append(nAppName);
                lba.append(".upk extraido: ");
                lba.append(unikFolder);
                lba.append("/");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
                //appName = nAppName;
                //return 0;
            }else{
                lba="";
                lba.append("Error at extract ");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
            }
            upkFileName.append(unikFolder);
            upkFileName.append("/");
            upkFileName.append(nAppName);
            upkFileName.append(".upk");
            if(debugLog){
                lba="";
                lba.append("Upk filename: ");
                lba.append(upkFileName);
                qInfo()<<lba;
            }
            if(u.upkToFolder(upkFileName, user, key, pq.toUtf8())){
                if(debugLog){
                    lba="";
                    lba.append(nAppName);
                    lba.append(" extract successful...");
                    qInfo()<<lba;
                }
                upkActivo = nAppName;
                updateUnikTools=false;
                //engine2.rootContext()->setContextProperty("upkActivo", appName);
            }
            //rewriteUpk=true;
        }
    }
    if(modeFolderToUpk){
        if(debugLog){
            lba="";
            lba.append("Prepare mode folder to upk...");
            lba.append("arg1: ");
            lba.append(appArg1);
            lba.append(" arg2: ");
            lba.append(appArg2);
            lba.append(" arg3: ");
            lba.append(appArg3);
            lba.append(" arg4: ");
            lba.append(appArg4);
            qInfo()<<lba;
        }

        //Carpeta para upk
        QByteArray arg1;
        arg1.append(argv[2]);

        //Usuario
        QString arg2;
        arg2.append(user);

        //Clave
        QString arg3;
        arg3.append(key);

        //AppName
        QString arg4;
        arg4.append(arg1);
#ifdef Q_OS_WIN32
        QStringList sl =arg4.replace("\\","/").split("/");
#else
        QStringList sl =arg4.split("/");
#endif

        QByteArray nAppName;
        nAppName.append(sl.at(sl.size()-1));
        if(nAppName!=""){
            if(debugLog){
                lba="";
                lba.append("Run folderToUpk(\"");
                lba.append(arg1);
                lba.append("\", \"");
                lba.append(nAppName);
                lba.append("\", \"");
                lba.append(arg2);
                lba.append("\", \"");
                lba.append(arg3);
                lba.append("\", \"");
                lba.append(unikFolder);
                lba.append("\");");
                lba.append(" user: ");
                lba.append(user);
                lba.append(" key: ");
                lba.append(key);
                qInfo()<<lba;
            }

            qInfo()<<"folderToUpk: "<<arg1<<" "<<nAppName<<" "<<arg2<<" "<<arg3<<" "<<unikFolder;
            if(u.folderToUpk(arg1, nAppName, arg2, arg3, unikFolder)){
                if(setPass){
                    //user = arg2.toLatin1();
                    //key = arg3.toLatin1();
                }
                lba="";
                lba.append(nAppName);
                lba.append(".upk creado: ");
                lba.append(unikFolder);
                lba.append("/");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
                appName = nAppName;
            }else{
                lba="";
                lba.append("Error al crear ");
                lba.append(nAppName);
                lba.append(".upk");
                qInfo()<<lba;
            }
            upkFileName.append(unikFolder);
            upkFileName.append("/");
            upkFileName.append(appName);
            upkFileName.append(".upk");
            QByteArray fd;
            fd.append(u.getPath(2));
            fd.append("/");
            fd.append(tempFolder);
            QDir dfd(fd);
            dfd.mkpath(".");
            qInfo()<<"Upk filename: "<<upkFileName;
            qInfo()<<"Upk folder: "<<fd;
            if(u.upkToFolder(upkFileName, user, key, fd)){
                qInfo()<<appName<<" extract successful...";
                upkActivo = appName;
                updateUnikTools=false;
                pq.clear();
                pq.append(fd);
                pq.append("/");
                //engine2.rootContext()->setContextProperty("upkActivo", appName);
            }
            //rewriteUpk=true;
        }
    }
    if(modeRemoteFolder){
        QString urlRemoteFolder;
        urlRemoteFolder.append(QByteArray(appArg1));
        if(debugLog){
            qDebug()<<"unik working in mode: -remoteFolder";
            qDebug()<<"Remote Folder Url: "<<urlRemoteFolder;
        }
        u.downloadRemoteFolder(urlRemoteFolder, appArg2, appArg3);
        pq = "";
        pq.append(appArg3);
        makeUpk=false;
    }

    engine.rootContext()->setContextProperty("version", app.applicationVersion());
    engine.rootContext()->setContextProperty("host", u.host());
    engine.rootContext()->setContextProperty("appName", appName);
    engine.rootContext()->setContextProperty("upkExtractLocation", pq);
    engine.rootContext()->setContextProperty("sourcePath", pq);
    engine.rootContext()->setContextProperty("unikDocs", unikFolder);
    engine.rootContext()->setContextProperty("pws", pws);

    QString unikFolderFolderModel;
#ifdef Q_OS_WIN
    //unikFolderFolderModel.append("file:///");
    unikFolderFolderModel.append(unikFolder);
    engine.rootContext()->setContextProperty("appsDir", unikFolderFolderModel);
#else
    engine.rootContext()->setContextProperty("appsDir", unikFolder);
#endif
    //'file:///C:/Users/qt/Documents/unik'
#ifdef QT_DEBUG
#ifdef Q_OS_WIN
    /*if(argc > 3){ //SOLO FUNCIONA EN DEBUG
        qDebug()<<"Recibiendo "<<argc<<" argumentos: "<<argv[0];
        QByteArray arg1;
        arg1.append(argv[1]);
        QByteArray arg2;
        arg2.append(argv[2]);
        QByteArray arg3;
        arg3.append("file://");
        arg3.append(argv[3]);
        if(arg1=="-force"){
            qDebug()<<"Ejecutando -reset "<<argv[0]<<" "<<argv[1];

            engine.load(QUrl::fromLocalFile(arg2));// main.qml location
            QQmlComponent component(&engine, QUrl::fromLocalFile(arg2));
            engine.addImportPath(arg3);
            //engine.load(QUrl::fromLocalFile("H:/_qtos/des/unik-installer/main.qml"));
            //engine.addImportPath("file://H://_qtos/des/unik-installer");
        }
    }*/

#else
    engine.load(QUrl(QStringLiteral("/media/nextsigner/ZONA-A1/_qtos/des/unik-installer/main.qml")));
    QQmlComponent component(&engine, QUrl::fromLocalFile(arg2));
    engine.addImportPath("file://media/nextsigner/ZONA-A1/_qtos/des/unik-installer");
#endif

#else
    QString qmlImportPath;
    if(modeRemoteFolder){
        pq = "";
        pq.append(appArg3);
        pq.append("/");
    }

    QByteArray mainQml;
    mainQml.append(pq);
    mainQml.append("main.qml");
    qInfo()<<"[0] main: "<<mainQml;

    if(modeGit){
        lba="";
        lba.append("Updating from github: ");
        lba.append(urlGit);
        qInfo()<<lba;
        QByteArray tmpZipPath;
        tmpZipPath.append(pws);
        //u.mkdir(tmpZipPath);
        lba="";
        lba.append("Downloading Zip in folder ");
        lba.append(tmpZipPath);
        qInfo()<<lba;
        qInfo()<<"downloadGit() 1"<<urlGit;
        bool up=u.downloadGit(urlGit, tmpZipPath);
        if(up){
            lba="";
            lba.append("Zip downloaded.");
            qInfo()<<lba;
        }else{
            lba="";
            lba.append("Fail Zip download: ");
            lba.append(urlGit);
            qInfo()<<lba;
        }
        /*mainQml="";
        mainQml.append(QDir::currentPath());
        mainQml.append("/main.qml");*/
        qInfo()<<"[1] main: "<<mainQml;
        u.log("Updated: "+pq.toUtf8());
    }

    QByteArray log4;

    log4.append("\nExecute mode: ");
    log4.append(modoDeEjecucion);
    log4.append("\n");

    log4.append("unik version: ");
    log4.append(app.applicationVersion());
    log4.append("\n");

    log4.append("Work Space: ");
    log4.append(settings.value("ws").toString());
    log4.append("\n");

    log4.append("modeFolder: ");
    log4.append(modeFolder ? "true" : "false");
    log4.append("\n");

    log4.append("modeGit: ");
    log4.append(modeGit ? "true" : "false");
    log4.append("\n");

    log4.append("modeFolderToUpk: ");
    log4.append(modeFolderToUpk ? "true" : "false");
    log4.append("\n");

    log4.append("modeRemoteFolder: ");
    log4.append(modeRemoteFolder ? "true" : "false");
    log4.append("\n");

    log4.append("modeUpk: ");
    log4.append(modeUpk ? "true" : "false");
    log4.append("\n");

    log4.append("makeUpk: ");
    log4.append(makeUpk ? "true" : "false");
    log4.append("\n");

    log4.append("setPass: ");
    log4.append(setPass ? "true" : "false");
    log4.append("\n");

    log4.append("DebugMode: ");
    log4.append(debugLog ? "true" : "false");
    log4.append("\n");

    engine.rootContext()->setContextProperty("appStatus", log4);
    if(u.debugLog){
        qInfo()<<log4;
    }
#ifndef Q_OS_ANDROID
    if (!engine.rootObjects().isEmpty()){
        QObject *aw0 = engine.rootObjects().at(0);
        if(aw0->property("objectName")=="awsplash"){
            aw0->setProperty("ver", false);
        }
    }
#else

#endif
    if (!engine.rootObjects().isEmpty()){
        u.splashvisible=false;
        engine.rootContext()->setContextProperty("splashvisible", u.splashvisible);
    }
#ifdef Q_OS_WIN
    //qmlImportPath.append("C:/Users/qt/Documents/unik/yosoy-luz");
    qmlImportPath.append(pq);
    engine.addImportPath(qmlImportPath);
    engine.addPluginPath(qmlImportPath);
    qInfo()<<"Import Path: "<<qmlImportPath;
    qInfo()<<"Current Dir: "<<QDir::currentPath();
    qInfo()<<"1-->.>"<<engine.importPathList();
    qInfo()<<"2-->.>"<<engine.pluginPathList();
    qInfo()<<"3<<"<<QLibraryInfo::Qml2ImportsPath;

    if(uap.showLaunch||showLaunch){
        mainQml=":/appsListLauncher.qml";
    }
    qInfo()<<"Init unik: "<<mainQml;
    // engine.load(QUrl(QStringLiteral("qrc:/appsListLauncher.qml")));
    //engine.load(mainQml);
    engine.load(QUrl::fromLocalFile(mainQml));
    QQmlComponent component(&engine, QUrl::fromLocalFile(mainQml));
    /*QQuickWindow *window = qobject_cast<QQuickWindow*>(engine.rootObjects().at(0));
    if (!window) {
        qFatal("Error: Your root item has to be a window.");
        return -1;
    }
    window->show();
    QQuickItem *root = window->contentItem();

    QQmlComponent component(&engine, QUrl("qrc:/Button.qml"));
    QQuickItem *object = qobject_cast<QQuickItem*>(component.create());

    QQmlEngine::setObjectOwnership(object, QQmlEngine::CppOwnership);

    object->setParentItem(root);
    object->setParent(&engine);

    object->setProperty("color", QVariant(QColor(255, 255, 255)));
    object->setProperty("text", QVariant(QString("foo")));
    */

    //u.log("Unik Application initialized.");


#else
    qmlImportPath.append(pq);
    QString ncqmls;
    ncqmls.append(pq.mid(0,pq.size()-1).replace("/", "\\"));
    qmlImportPath.append(ncqmls);
    engine.addImportPath(pq);
    engine.addImportPath(QDir::currentPath());
    engine.addPluginPath("/sdcard/Documents/unik/unik-ws-android-client-1");
    engine.addPluginPath("assets:/lib/x86");

    QString unikPluginsPath;
    unikPluginsPath.append(u.getPath(1));
    unikPluginsPath.append("/unikplugins");
    engine.addImportPath(unikPluginsPath);
    qInfo()<<"Imports Paths List: "<<engine.importPathList();
    qInfo()<<"Plugins Paths List: "<<engine.pluginPathList();
#ifdef __arm__
    engine.addImportPath("/home/pi/unik/qml");
#endif


    //Probe file is for debug any components in the build operations. Set empty for release.
    QByteArray probe = "";
    //probe.append("qrc:/probe.qml");
    qInfo()<<"showLaunch: "<<showLaunch;
    qInfo()<<"uap.showLaunch: "<<uap.showLaunch;
    if(uap.showLaunch||showLaunch){
        mainQml="qrc:/appsListLauncher.qml";
    }
    qInfo()<<"Init unik: "<<mainQml;
    engine.load(probe.isEmpty() ? QUrl(mainQml) : QUrl(probe));
    QQmlComponent component(&engine, probe.isEmpty() ? QUrl(mainQml) : QUrl(probe));

    engine.addImportPath(qmlImportPath);
    QByteArray m1;
    m1.append(qmlImportPath);
    QByteArray m2;
    m2.append(mainQml);
#endif
#endif
    if (engine.rootObjects().length()<2&&component.errors().size()>0){
        u.log("Errors detected!");
        for (int i = 0; i < component.errors().size(); ++i) {
            listaErrores.append(component.errors().at(i).toString());
            listaErrores.append("\n");
        }
        //qDebug()<<"------->"<<component.errors();

#ifdef Q_OS_ANDROID
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
#else
#ifndef __arm__
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
#else
        engine.load("://main_rpi.qml");
#endif
#endif
    }
    //u.deleteFile(urlConfigJsonT.toUtf8());
#ifdef Q_OS_ANDROID
    QObject *aw = engine.rootObjects().at(0);//En Android es 0 cuando no carga splash.
#else
    if(engine.rootObjects().size()>1){
        QObject *aw = engine.rootObjects().at(1);
        QObject::connect(aw, SIGNAL(closing(QQuickCloseEvent *)), &u, SLOT(ukClose(QQuickCloseEvent *)));
        if(dim!=""){
            QStringList m=dim.split("x");
            if(m.size()==2){
                aw->setProperty("width", QString(m.at(0)).toInt());
                aw->setProperty("height", QString(m.at(1)).toInt());
            }
        }
        if(pos!=""){
            QStringList m=pos.split("x");
            if(m.size()==2){
                aw->setProperty("x", QString(m.at(0)).toInt());
                aw->setProperty("y", QString(m.at(1)).toInt());
            }
        }
    }
#endif

    //qInfo()<<"Executing from: "<<QDir::currentPath();
    //qInfo()<<"unik.getPath(5)= "<<u.getPath(5);
#ifndef Q_OS_ANDROID
    QByteArray uklData;
    uklData.append("-folder=");
    uklData.append(pws);
    uklData.append("/yosoy-luz");
    QByteArray uklUrl;
    uklUrl.append(pws);
    uklUrl.append("/link_yosoy-luz.ukl");
    u.setFile(uklUrl, uklData);
#else
    QByteArray uklData;
    uklData.append("-git=https://github.com/nextsigner/yosoy-luz.git");
    uklData.append(" -dir=");
    uklData.append(pws);
    uklData.append("/yosoy-luz");
    QByteArray uklUrl;
    uklUrl.append(pws);
    uklUrl.append("/link_yosoy-luz.ukl");
    u.setFile(uklUrl, uklData);
#endif

#ifdef Q_OS_WIN
    u.createLink(u.getPath(1)+"/unik.exe", "-git=https://github.com/nextsigner/yosoy-luz.git -folder="+pws+"/yosoy-luz -nl",  u.getPath(6)+"/yosoy-luz.lnk", "Ejecutar Unik con el Modulo yosoy-luz", "C:/");
#endif
    //u.createLink("unik", "/home/nextsigner/Escritorio/eee4.desktop",  "rrr777", "Pequeña 222vo", "/home/nextsigner/Imàgenes/ladaga.jpg");



    /*Atention! Not ejecute this method u.initWebSocketServer() with out the a correct load of the UnikWebSocketServerView or similar.*/
    //u.initWebSocketServer("127.0.0.1", 12345, "chatserver");

    //Set Unik Start Setting
    //u.setUnikStartSettings("-git=https://github.com/nextsigner/yosoy-luz.git, -nl");


#ifdef UNIK_COMPILE_RPI
    qInfo()<<"Estamos compilando en RPI!";
#endif
    return app.exec();
}
