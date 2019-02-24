#include "uk.h"

UK::UK(QObject *parent) : QObject(parent)
{
    lsim<<"g"<<"h"<<"i"<<"j"<<"k"<<"l"<<"m"<<"n"<<"o"<<"p"<<"q"<<"r"<<"s"<<"t"<<"u"<<"v"<<"w"<<"x"<<"y"<<"z";
    lnum<<"11"<<"33"<<"66"<<"77"<<"88"<<"99"<<"20"<<"30"<<"40"<<"60"<<"70"<<"80"<<"90"<<"12"<<"21"<<"57"<<"82"<<"92"<<"84"<<"72";
    file = new QFile();
#ifndef Q_OS_ANDROID
#ifdef __arm__
    rpiGpio = new mmapGpio();
#endif
#endif
}

UK::~UK()
{
    db.close();
}

void UK::setHost(QString nh)
{
    h = nh;
    if(debugLog){
        qInfo()<<"Set host:"<<h;
    }
}

QString UK::host()
{
    return h;
}
void UK::ukClose(QQuickCloseEvent *close){
    if(close){
        qInfo("ApplicationWindow closed.");
        db.close();
    }
}

void UK::engineExited(int n)
{
    QByteArray ld;
    ld.append("Unik Qml Engine exited with code: ");
    ld.append(QString::number(n));
    qInfo()<<ld;
    db.close();
}

void UK::engineQuited(QObject *)
{
    db.close();
}

int UK::getScreenWidth()
{
    QScreen *screen = QGuiApplication::primaryScreen();
    QRect  screenGeometry = screen->geometry();
    return screenGeometry.width();
}

int UK::getScreenHeight()
{
    QScreen *screen = QGuiApplication::primaryScreen();
    QRect  screenGeometry = screen->geometry();
    return screenGeometry.height();
}

void UK::setUnikStartSettings(const QString params)
{
    QSettings settings;
    settings.setValue("uss",params);
}

QList<QString> UK::getUnikStartSetting()
{
    QSettings settings;
    QList<QString> ret;
    QStringList p=settings.value("uss").toString().split(",");
    for (int i = 0; i < p.size(); ++i) {
        ret.append(p.at(i));
    }
    return ret;
}

void UK::setWorkSpace(QString ws)
{
    QSettings settings;
    settings.setValue("ws", ws);
    QString duplFolderModel;
#ifdef Q_OS_WIN
    duplFolderModel.append("file:///");
    duplFolderModel.append(ws);
    _engine->rootContext()->setContextProperty("appsDir", duplFolderModel);
#else
    _engine->rootContext()->setContextProperty("appsDir", ws);
#endif

}

void UK::definirCarpetaTrabajo(QString et)
{
    setWorkSpace(et);
}

bool UK::folderToUpk(QString folder, QString upkName, QString user, QString key, QString folderDestination)
{
    return mkUpk(folder.toUtf8(), upkName.toUtf8(), user.toUtf8(), key.toUtf8(), folderDestination.toUtf8());
}

bool UK::carpetaAUpk(QString carpeta, QString nombreUpk, QString usuario, QString clave, QString carpetaDestino)
{
    return folderToUpk(carpeta, nombreUpk, usuario, clave, carpetaDestino);
}

bool UK::downloadRemoteFolder(QString urlFolder, QString list, QString dirDestination)
{
    QStringList m0 = list.split("|");
    if(m0.size()==0){
        return false;
    }
    QDir dir0(dirDestination);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }

    for (int i = 0; i < m0.size(); ++i) {
        QByteArray rd;
        rd.append(dirDestination);
        rd.append("/");
        rd.append(m0.at(i));
        QByteArray ro;
        ro.append(urlFolder);
        ro.append("/");
        ro.append(m0.at(i));
        ro.append("?r=");
        ro.append(QDateTime::currentDateTime().toString("zzz"));
        QByteArray code;
        code.append(getHttpFile(ro));
        QFile qml(rd);
        if(qml.exists()){
            qml.remove();
        }
        if(qml.open(QIODevice::WriteOnly)){
            if(debugLog){
                if(debugLog){
                    lba="";
                    lba.append("File ");
                    lba.append(rd);
                    lba.append(" downloaded.");
                    log(lba);
                }
            }
            qml.write(code);
            qml.close();
        }else{
            if(debugLog){
                lba="";
                lba.append("Error downloading QML  ");
                lba.append(ro);
                log(lba);
            }
        }
    }
    return true;
}

bool UK::mkUpk(QByteArray folder, QByteArray upkName, QByteArray user, QByteArray key, QByteArray folderDestination)
{
    QByteArray dataUpk1="";
    QByteArray sep;
    sep.append(user);
    sep.append(key);
    QByteArray log1;
    log1.append("Making upk from folder ");
    log1.append(folder);
    log1.append(" with upkName: ");
    log1.append(upkName);
    qInfo()<<log1;

    //Primeras 2 letras a hexadecimal
    QByteArray hsep;
    hsep.append(QString(QCryptographicHash::hash(sep,QCryptographicHash::Md5)));

    //Ubicaciòn final de upk
    QByteArray urlUPK;
    urlUPK.append(folderDestination);
    urlUPK.append("/");
    urlUPK.append(upkName);
    urlUPK.append(".upk");
    QFile upk(urlUPK);

    //Creando carpeta destino
    qInfo()<<"Making folder to upk: "<<folder;
    QDir dir(folder);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    dir.setFilter(QDir::Files | QDir::NoDotAndDotDot | QDir::NoSymLinks);
    qInfo()<<"Scanning: "<<dir.path();
    //Iterando la lista de archivos
    QStringList fileList = dir.entryList();
    qInfo()<<"For reading "<<fileList.count()<<" files...";
    for (int i=0; i<fileList.count(); i++){
        //qDebug()<<"Upkando: "<<fileList[i];
        QByteArray ro;
        ro.append(folder);
        ro.append("/");
        ro.append(fileList[i]);
        QFile archOrig(ro);
        if(archOrig.size()>0&&!QString(fileList[i]).contains(".qmlc")){
            if(!archOrig.open(QIODevice::ReadOnly)){
                qInfo()<<"Read error "<<ro;
                return false;
            }else{
                qInfo()<<"Reading: "<<ro;
            }

            //Preparando separador
            QByteArray s1;
            s1.append(hsep);
            QByteArray nsep;
            //nsep.append(hsep);
            if(i!=0){
                nsep.append(s1);
                nsep.append("X-X");
            }
            nsep.append(fileList[i]);
            nsep.append(s1);
            nsep.append("X+X");

            dataUpk1.append(nsep);
            dataUpk1.append(archOrig.readAll());
        }else{
            qInfo()<<"File not has data: "<<fileList[i];
        }
    }

    //Abriendo archivo upk
    QFile upk2(urlUPK);
    if(!upk2.open(QIODevice::WriteOnly)){
        qInfo()<<"Error! not open upk: "<<urlUPK;
        return false;
    }else{
        qInfo()<<"File creation upk: "<<urlUPK;
    }

    QString dataUpk2=encPrivateData(dataUpk1, user, key);

    QTextStream entradaUpk(&upk2);
    entradaUpk.setCodec("UTF-8");
    entradaUpk<<dataUpk2;
    upk2.close();
    return true;
}

bool UK::upkToFolder(QByteArray upk, QByteArray user, QByteArray key, QByteArray folderDestination)
{
    QFile upkFile(upk);

    //Eliminar el upk existente
    if(!upkFile.exists()){
        if(debugLog){
            lba="";
            lba.append("Upk file not exist: ");
            lba.append(upk);
            log(lba);
        }
        return false;
    }else{
        if(debugLog){
            qDebug()<<"Upk file exist in: "<<upk;
        }
    }

    if(!upkFile.open(QIODevice::ReadOnly)){
        if(debugLog){
            qDebug()<<"Upk file not open or not permission: "<<upk;
        }
        return false;
    }else{
        if(debugLog){
            qDebug()<<"Upk file open in: "<<upk;
        }
    }

    QByteArray sep;
    sep.append(user);
    sep.append(key);

    QByteArray hsep;
    hsep.append(QString(QCryptographicHash::hash(sep,QCryptographicHash::Md5)));

    //Preparando separador 1
    QByteArray s1;
    s1.append(hsep);
    QByteArray nsep;
    nsep.append(s1);
    nsep.append("X-X");

    QTextStream stream(&upkFile);
    stream.setCodec("UTF-8");
    int nl=0;
    QByteArray fileData;
    do{
        fileData.append(stream.read(1));
        nl++;
    }while (nl<upkFile.size());
    upkFile.close();

    QString dec;
    dec.append(decData(fileData, user, key));
    QStringList l1=dec.split(nsep);
    for (int i = 0; i < l1.size(); ++i) {
        QString f=l1.at(i);

        QByteArray nsep2;
        nsep2.append(s1);
        nsep2.append("X+X");

        QStringList m0=f.split(nsep2);
        if(m0.size()!=2||m0.size()>2){
            qDebug()<<"upkToFolder fail in each "<<i <<" data segments "<<m0.size();
            return false;
        }
        QByteArray urlNf;
        urlNf.append(folderDestination);
        urlNf.append("/");
        urlNf.append(m0.at(0));

        QFile f1(urlNf);
        if(f1.open(QIODevice::WriteOnly)){
            QByteArray d;
            d.append(m0.at(1));
            f1.write(d);
        }
        f1.close();
    }
    return true;
}

bool UK::isFree(QString upk)
{
    QFile upkFile(upk);
    if(!upkFile.open(QIODevice::ReadOnly)){
        if(debugLog){
            lba="";
            lba.append("isFree() revision Upk file not open or not permission: ");
            lba.append(upk);
            log(lba);
        }
        return false;
    }else{
        if(debugLog){
            lba="";
            lba.append("isFree() revision Upk file open in: ");
            lba.append(upk);
            log(lba);
        }
    }

    QByteArray sep;
    sep.append("unik-free");
    sep.append("free");

    QByteArray hsep;
    hsep.append(QString(QCryptographicHash::hash(sep,QCryptographicHash::Md5)));

    //Preparando separador 1
    QByteArray s1;
    s1.append(hsep);
    QByteArray nsep;
    nsep.append(s1);
    nsep.append("X-X");

    QTextStream stream(&upkFile);
    stream.setCodec("UTF-8");
    int nl=0;
    QByteArray fileData;
    do{
        fileData.append(stream.read(1));
        nl++;
    }while (nl<upkFile.size());
    upkFile.close();
    QString dec;
    dec.append(decData(fileData, "unik-free", "free"));
    QStringList l1=dec.split(nsep);
    for (int i = 0; i < l1.size(); ++i) {
        QString f=l1.at(i);

        QByteArray nsep2;
        nsep2.append(s1);
        nsep2.append("X+X");

        QStringList m0=f.split(nsep2);
        if(m0.size()!=2||m0.size()>2){
            qDebug()<<"upkToFolder fail in each "<<i <<" data segments "<<m0.size();
            return false;
        }else{
            return true;
        }
    }
    return false;
}

bool UK::loadUpk(QString upkLocation, bool closeAppLauncher, QString user, QString key)
{
    //QString c1 = upkLocation.toString();
    QString appName="";
    QString dupl="";
    QStringList m0 = upkLocation.split("/");
    QString ext = upkLocation.mid(upkLocation.size()-4, upkLocation.size()-1);
    QString c1;
    if(m0.size()>=1&&ext==".upk"){
        QString c0 = m0.at(m0.size()-1);
        c1 = c0.replace(".upk", "");
        if(c1==""||c1=="/"||c1=="\\"||c1=="\\\\"){
            return false;
        }else{
            appName=c1;
            if(debugLog){
                qDebug()<<"loadUpk appName: "<<appName;
            }
        }
        QByteArray upk;
        upk.append("/");
        upk.append(appName);
        upk.append(".upk");
        dupl = upkLocation.replace(upk, "");
    }
    QByteArray tempFolder;
    tempFolder.append(QDateTime::currentDateTime().toString("hhmmss"));
    QString pq;
    pq.append(getPath(2));
    pq.append("/");
    pq.append(tempFolder);
    //qDebug()<<"loadUpk Temp Folder: "<<pq;

    QFile arch(upkLocation);
    bool esLocal=arch.exists();
    if(esLocal){
        if(debugLog){
            qDebug()<<"loadUpk local: "<<appName;
        }
        if(upkToFolder(upkLocation.toUtf8(),  user.toUtf8(), key.toUtf8(), pq.toUtf8())){
            if(debugLog){
                qDebug()<<appName<< " extract sucessful";
            }
            _engine->rootContext()->setContextProperty("appName", appName);
            QByteArray mainQml;
            mainQml.append(pq);
            mainQml.append("/main.qml");
            if(closeAppLauncher){
                QObject *rootQml = _engine->rootObjects().at(0);
                rootQml->setProperty("closedModeLaunch", true);
                rootQml->setProperty("visible", false);
            }
            _engine->load(QUrl::fromLocalFile(mainQml));

        }else{
            if(debugLog){
                qDebug()<<appName<< " NO extracted";
            }

        }
    }else{
        if(debugLog){
            qDebug()<<"loadUpk remote intent: "<<appName;
        }
    }
    return false;
}

bool UK::downloadGit(QByteArray url, QByteArray localFolder)
{
    QString u;
    u.append(url);
    QStringList mUrl0=u.split("/");
    if(mUrl0.size()<2){
        qInfo()<<"downloadGit() fail! This url git is no valid!";
        return false;
    }
    QString u2 = mUrl0.at(mUrl0.size()-1);
    QString module=u2.replace(".git", "");
    if(u.mid(u.size()-4, 4)!=".git"){
        u.append(".git");
    }
    QString urlZipGit;
    QString carpetaDestino;
    QStringList m0 = u.split(".git");
    if(m0.size()<2){
        qInfo()<<"Url no valid: "<<url;
        qInfo()<<"Use: https://github.com/<user>/<repository>.git";

    }else{
        QStringList m1=u.split("/");
        QString cd0=m1.at(m1.size()-1);
        carpetaDestino = cd0.replace(".git", "");

        bool modoCodeload=true;
        QString url0;
        if(modoCodeload){
            url0=u.replace(".git", "/zip/master");
            urlZipGit=url0.replace("https://github.com/", "https://codeload.github.com/");

            QDateTime rdt = QDateTime::currentDateTime();
            urlZipGit.append("?r=");
            urlZipGit.append(QString::number(rdt.currentMSecsSinceEpoch()));
        }else{
            //url of download zip no codeload
            //https://github.com/nextsigner/qt_qml_chat_server/archive/master.zip

            url0=u.replace(".git", "/archive/master.zip");
            urlZipGit=url0;
        }
        qInfo("Downloading zip file: "+urlZipGit.toUtf8());
    }


    qInfo("Downloading from GitHub: "+url);
    qInfo("Download Folder Location: "+carpetaDestino.toUtf8());
    QDateTime a = QDateTime::currentDateTime();
    QByteArray tempFile;
    tempFile.append(getPath(2));
    tempFile.append("/");
#ifndef __arm__
    tempFile.append(QString::number(a.toSecsSinceEpoch()));
#else
    tempFile.append(QString::number(a.toMSecsSinceEpoch()));
#endif
    tempFile.append(".zip");
    qInfo("temp zip location "+tempFile);
    qInfo()<<"Url Zip Git: "<<urlZipGit;



    bool d=downloadZipFile(urlZipGit.toUtf8(), tempFile);
    if(!d){
        qDebug("Git Zip not downloaded.");
        return false;
    }
    qInfo("Git Zip downloaded.");

#ifdef Q_OS_WIN32
    QByteArray carpDestinoFinal;
    carpDestinoFinal.append(localFolder);
    QDir fdf1(carpDestinoFinal);
    if(!fdf1.exists()){
        fdf1.mkpath(".");
    }
    qInfo()<<"Downloading Git Zip into: "<<carpDestinoFinal;
    qInfo()<<"Downloading Git Zip Module: "<<module;
    QString nfdf2;
    nfdf2.append(carpDestinoFinal);
    nfdf2.append("/");
    nfdf2.append(module);
    qInfo()<<"Downloading Git Zip Module Location: "<<nfdf2;
    QDir fdf2(nfdf2);
    if(!fdf2.exists()){
        fdf2.mkpath(".");
    }

    QuaZip zip(tempFile.constData());
    zip.open(QuaZip::mdUnzip);

    QuaZipFile file(&zip);

    QString carpeta="aaa";
    int v=0;
    for(bool f=zip.goToFirstFile(); f; f=zip.goToNextFile()) {
        if(v>=zip.getFileNameList().size()){
            break;
        }
        file.open(QIODevice::ReadOnly);
        //qInfo()<<"Zip filename: "<<zip.getFileNameList();
        if(v==0){
            carpeta=QString(zip.getFileNameList().at(0));
            //qInfo()<<"Carpeta de destino Zip: "<<carpeta;
        }else{
            QString nfn;
            nfn.append(carpDestinoFinal);
            nfn.append("/");
            nfn.append(zip.getFileNameList().at(v));
            QString nfn2 = nfn.replace("-master/", "/");
            QString nfn3 = nfn2.replace(" ", "%20");

            if(nfn3.at(nfn3.size()-1)!="/"){
                qInfo()<<"Destino de archivo: "<<nfn3;
                QFile nfile(nfn3);
                if(!nfile.open(QIODevice::WriteOnly)){
                    qInfo()<<"Error al abrir archivo "<<nfn3;
                }else{
                    nfile.write(file.readAll());
                    nfile.close();
                }
            }else{
                qInfo()<<"Destino de carpeta: "<<nfn3;
                QDir dnfn(nfn3);
                dnfn.mkpath(".");
            }
        }
        file.close();
        v++;
    }
    zip.close();
#endif
#ifdef Q_OS_OSX
    QByteArray carpDestinoFinal;
    carpDestinoFinal.append(localFolder);
    QDir fdf1(carpDestinoFinal);
    if(!fdf1.exists()){
        fdf1.mkpath(".");
    }
    qInfo()<<"Downloading Git Zip into: "<<carpDestinoFinal;
    qInfo()<<"Downloading Git Zip Module: "<<module;
    QString nfdf2;
    nfdf2.append(carpDestinoFinal);
    nfdf2.append("/");
    nfdf2.append(module);
    qInfo()<<"Downloading Git Zip Module Location: "<<nfdf2;
    QDir fdf2(nfdf2);
    if(!fdf2.exists()){
        fdf2.mkpath(".");
    }

    QuaZip zip(tempFile.constData());
    zip.open(QuaZip::mdUnzip);

    QuaZipFile file(&zip);

    QString carpeta="aaa";
    int v=0;
    for(bool f=zip.goToFirstFile(); f; f=zip.goToNextFile()) {
        if(v>=zip.getFileNameList().size()){
            break;
        }
        file.open(QIODevice::ReadOnly);
        //qInfo()<<"Zip filename: "<<zip.getFileNameList();
        if(v==0){
            carpeta=QString(zip.getFileNameList().at(0));
            qInfo()<<"Carpeta de destino Zip: "<<carpeta;
        }else{
            QString nfn;
            nfn.append(carpDestinoFinal);
            nfn.append("/");
            nfn.append(zip.getFileNameList().at(v));
            QString nfn2 = nfn.replace("-master/", "/");
            QString nfn3 = nfn2.replace(" ", "%20");

            if(nfn3.at(nfn3.size()-1)!="/"){
                qInfo()<<"Destino de archivo: "<<nfn3;
                QFile nfile(nfn3);
                if(!nfile.open(QIODevice::WriteOnly)){
                    qInfo()<<"Error al abrir archivo "<<nfn3;
                }else{
                    nfile.write(file.readAll());
                    nfile.close();
                }
            }else{
                qInfo()<<"Destino de carpeta: "<<nfn3;
                QDir dnfn(nfn3);
                dnfn.mkpath(".");
            }
        }
        file.close();
        v++;
    }
    zip.close();
#endif
#ifdef Q_OS_LINUX
    QByteArray carpDestinoFinal;
#ifndef Q_OS_ANDROID
    //carpDestinoFinal.append("\"");
#endif
    carpDestinoFinal.append(localFolder);
    //carpDestinoFinal.append("/");
    //carpDestinoFinal.append(module);
#ifndef Q_OS_ANDROID
    //carpDestinoFinal.append("\"");
#endif
    qInfo()<<"Local Folder: "<<carpDestinoFinal;
    QString nFolder=carpDestinoFinal;
    nFolder.append("/");
    nFolder.append(module);
    QDir fdf(nFolder);
    if(!fdf.exists()){
        fdf.mkpath(".");
    }
    QFile zipFile(tempFile);
    if(zipFile.exists()){
        qInfo("Zip File "+tempFile+" exist.");
    }else{
        qInfo("Zip File "+tempFile+" not exist.");
        return false;
    }

#ifndef Q_OS_ANDROID

#else
    QByteArray cl;
    cl.append("unzip ");
    //cl.append("\");
    cl.append(tempFile);
#endif

#ifdef Q_OS_ANDROID
    QuaZip zip(tempFile.constData());
    zip.open(QuaZip::mdUnzip);

    QuaZipFile file(&zip);

    QString carpeta="aaa";
    int v=0;
    for(bool f=zip.goToFirstFile(); f; f=zip.goToNextFile()) {
        if(v>=zip.getFileNameList().size()){
            break;
        }
        file.open(QIODevice::ReadOnly);
        //qInfo()<<"Zip filename: "<<zip.getFileNameList();
        if(v==0){
            carpeta=QString(zip.getFileNameList().at(0));
            //qInfo()<<"Carpeta de destino Zip: "<<carpeta;
        }else{
            QString nfn;
            nfn.append(carpDestinoFinal);
            nfn.append("/");
            nfn.append(zip.getFileNameList().at(v));
            QString nfn2 = nfn.replace("-master/", "/");
            QString nfn3 = nfn2.replace(" ", "%20");

            if(nfn3.at(nfn3.size()-1)!="/"){
                qInfo()<<"Destino de archivo: "<<nfn3;
                QFile nfile(nfn3);
                if(!nfile.open(QIODevice::WriteOnly)){
                    qInfo()<<"Error al abrir archivo "<<nfn3;
                }else{
                    nfile.write(file.readAll());
                    nfile.close();
                }
            }else{
                qInfo()<<"Destino de carpeta: "<<nfn3;
                QDir dnfn(nfn3);
                dnfn.mkpath(".");
            }
        }
        file.close();
        v++;
    }
    zip.close();
#else
    QuaZip zip(tempFile.constData());
    zip.open(QuaZip::mdUnzip);

    QuaZipFile file(&zip);

    QString carpeta="aaa";
    int v=0;
    for(bool f=zip.goToFirstFile(); f; f=zip.goToNextFile()) {
        if(v>=zip.getFileNameList().size()){
            break;
        }
        file.open(QIODevice::ReadOnly);
        if(v==0){
            carpeta=QString(zip.getFileNameList().at(0));
            qInfo()<<"Carpeta de destino Zip: "<<carpeta;
        }else{
            QString nfn;
            nfn.append(carpDestinoFinal);
            nfn.append("/");
            nfn.append(zip.getFileNameList().at(v));
            QString nfn2 = nfn.replace("-master/", "/");
            QString nfn3 = nfn2.replace(" ", "%20");
            QByteArray banfn3;
            banfn3.append(nfn3.at(nfn3.size()-1));
            if(banfn3!="/"){
                qInfo()<<"Destino de archivo: "<<nfn3;
                QFile nfile(nfn3);
                if(!nfile.open(QIODevice::WriteOnly)){
                    qInfo()<<"Error al abrir archivo "<<nfn3;
                }else{
                    nfile.write(file.readAll());
                    nfile.close();
                }
            }else{
                qInfo()<<"Destino de carpeta: "<<nfn3;
                QDir dnfn(nfn3);
                dnfn.mkpath(".");
            }
        }
        file.close();
        v++;
    }
    zip.close();
#endif
#ifdef Q_OS_OSX
    QByteArray carpDestinoFinal;
    carpDestinoFinal.append(localFolder);
    //carpDestinoFinal.append("/");
    //carpDestinoFinal.append(carpetaDestino);

    QByteArray cl;
    cl.append("unzip -o ");
    cl.append(tempFile);
    //cl.append(" ");
    //cl.append(" nivelfluido-master/* ");
    cl.append(" -d ");
    cl.append(getPath(2));
    cl.append("/");
    cl.append(carpetaDestino);
    log("Run "+cl);
    run(cl);
    while (proc->waitForFinished(250)&&proc->isOpen()) {
        log(".");
    }
    //sleep(5);
    cl = "cp -R ";
    cl.append(getPath(2));
    cl.append("/");
    cl.append(carpetaDestino);
    cl.append("/");
    cl.append(carpetaDestino);
    cl.append("-master/ ");
    //cl.append(carpetaDestino);
    //cl.append("-master");
    cl.append(" ");
    cl.append(carpDestinoFinal);
    cl.append("/");
    cl.append(carpetaDestino);
    //cl.append(carpDestinoFinal);
    //cl.append("/");
    //cl.append(carpetaDestino);
    //cl.append(" -f");
    //cl.append("-master");
    log(cl);
    run(cl);
#endif
#endif


    return true;
}

void UK::restartApp()
{

#ifndef Q_OS_ANDROID
#ifndef Q_OS_IOS
    qApp->quit();
    //QProcess::startDetached(qApp->arguments()[0], qApp->arguments());
    QProcess::startDetached(qApp->arguments()[0], QStringList());
#endif
#else
    //qApp->quit();
    //QProcess::startDetached(qApp->arguments()[0], qApp->arguments());

    auto activity = QtAndroid::androidActivity();
    auto packageManager = activity.callObjectMethod("getPackageManager", "()Landroid/content/pm/PackageManager;");

    auto activityIntent = packageManager.callObjectMethod("getLaunchIntentForPackage",
                                                          "(Ljava/lang/String;)Landroid/content/Intent;",
                                                          activity.callObjectMethod("getPackageName",
                                                                                    "()Ljava/lang/String;").object());

    auto pendingIntent = QAndroidJniObject::callStaticObjectMethod("android/app/PendingIntent", "getActivity",
                                                                   "(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;",
                                                                   activity.object(), jint(0), activityIntent.object(),
                                                                   QAndroidJniObject::getStaticField<jint>("android/content/Intent",
                                                                                                           "FLAG_ACTIVITY_CLEAR_TOP"));

    auto alarmManager = activity.callObjectMethod("getSystemService",
                                                  "(Ljava/lang/String;)Ljava/lang/Object;",
                                                  QAndroidJniObject::getStaticObjectField("android/content/Context",
                                                                                          "ALARM_SERVICE",
                                                                                          "Ljava/lang/String;").object());

    alarmManager.callMethod<void>("set",
                                  "(IJLandroid/app/PendingIntent;)V",
                                  QAndroidJniObject::getStaticField<jint>("android/app/AlarmManager", "RTC"),
                                  jlong(QDateTime::currentMSecsSinceEpoch() + 1500), pendingIntent.object());

    //qApp->quit();
#endif
    emit restartingApp();
}

void UK::restartApp(QString args)
{
    qApp->quit();
    QStringList al = args.split(",");
    QProcess::startDetached(qApp->arguments()[0], al);
}

bool UK::run(QString commandLine)
{
#ifndef Q_OS_ANDROID
    proc = new QProcess(this);
    connect(proc, SIGNAL(readyReadStandardOutput()),this, SLOT(salidaRun()));
    connect(proc, SIGNAL(readyReadStandardError()),this, SLOT(salidaRunError()));
    proc->start(commandLine);
    if(proc->isOpen()){
        setRunCL(true);
        QString msg;
        msg.append("Run: ");
        msg.append(commandLine);
        setUkStd(msg);
        return true;
    }else{
        QString msg;
        msg.append("No Run: ");
        msg.append(commandLine);
        setUkStd(msg);
        setRunCL(false);
    }
#endif
    return false;
}

void UK::writeRun(QString data)
{
    proc->write(data.toUtf8());
}

bool UK::ejecutarLineaDeComandoAparte(QString lineaDeComando)
{
#ifndef Q_OS_ANDROID
    proc = new QProcess(this);
    connect(proc, SIGNAL(readyReadStandardOutput()),this, SLOT(salidaRun()));
    connect(proc, SIGNAL(readyReadStandardError()),this, SLOT(salidaRunError()));
    proc->startDetached(lineaDeComando);
    if(proc->isOpen()){
        setRunCL(true);
        qInfo()<<"Ejecutando "<<lineaDeComando;
        return true;
    }else{
        qInfo()<<"No se està ejecutando "<<lineaDeComando;
        setRunCL(false);
    }
#endif
    return false;
}

void UK::salidaRun()
{
    log(proc->readAllStandardOutput());
}

void UK::salidaRunError()
{
    log(proc->readAllStandardError());
}

void UK::finalizaRun(int e)
{
    QByteArray s;
    s.append("command line finished with status ");
    s.append(QString::number(e));
    log(s);
    proc->close();
}

void UK::log(QByteArray d)
{
    QString d2;
    d2.append(d);
    if(!_engine->rootContext()->property("setInitString").toBool()){
        initStdString.append(d2.toHtmlEscaped());
        initStdString.append("\n");
    }
    setUkStd(d2);
}

void UK::sleep(int ms)
{
    QThread::sleep(ms);
}

QString UK::getPath(int path)
{
    QString r=".";
    if(path==0){//App location Name
        r = QFileInfo(QCoreApplication::applicationFilePath()).fileName();
    }
#ifdef Q_OS_WIN
    if(path==1){//App location
        r = qApp->applicationDirPath();
    }
#endif
#ifdef Q_OS_OSX
    if(path==1){//App location
        r = qApp->applicationDirPath();
    }
#endif
#ifdef Q_OS_LINUX
    if(path==1){//App location
        r = QDir::currentPath();
    }
#endif
    if(path==2){//Temp location
        r = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
        qInfo("getPath(2): "+r.toUtf8());
    }
    if(path==3){//Doc location
#ifndef Q_OS_ANDROID
        r = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
#else
        //r="/sdcard/Documents";
        QStringList systemEnvironment = QProcess::systemEnvironment();
        bool sdcard=false;
        for (int i = 0; i < systemEnvironment.size(); ++i) {
            QString cad;
            cad.append(systemEnvironment.at(i));
            if(cad.contains("EXTERNAL_STORAGE=/sdcard")){
                sdcard=true;
            }
        }
        qInfo()<<"uap systemEnvironment: "<<systemEnvironment;
        qInfo()<<"uap sdcard: "<<sdcard;
        if(sdcard){
            r="/sdcard/Documents";
        }else{
            r="/storage/emulated/0/Documents";
        }
        QDir doc(r);
        if(!doc.exists()){
            qInfo()<<"[1] /sdcard/Documents no exists";
            doc.mkdir(".");
            /*if(!doc.exists()){
                r="/storage/emulated/0/Documents";
                doc.setCurrent(r);
                doc.mkdir(".");
                qInfo()<<"[2] /storage/emulated/0/Documents no exists";
            }else{
                qInfo()<<"[2] /storage/emulated/0/Documents exists";
            }*/
        }else{
            qInfo()<<"[1] /sdcard/Documents exists";
        }
#endif

    }
    if(path==4){//AppData location
        r = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    }
    if(path==5){//Current Dir
        r = QDir::currentPath();
    }
    if(path==6){//Current Desktop
        r = QStandardPaths::standardLocations(QStandardPaths::DesktopLocation).at(0);
    }
    if(path==7){//Current Home
        r = QStandardPaths::standardLocations(QStandardPaths::HomeLocation).at(0);
    }
    QDir dir(r);
    if (!dir.exists()) {
        if(debugLog){
            lba="";
            lba.append("Making folder ");
            lba.append(r);
            log(lba);
        }
        dir.mkpath(".");
    }else{
        if(debugLog){
            lba="";
            lba.append("Folder ");
            lba.append(r);
            lba.append(" exist.");
        }
    }
    return r;
}

QString UK::encData(QByteArray d, QString user, QString key)
{
    QString ret;
    QByteArray upkData;
    QByteArray r="6226";
    QByteArray r2="6226";
    QByteArray ru;
    QString cdt = QDateTime::currentDateTime().toString("z");
    if(QString(cdt.at(0))=="1"||QString(cdt.at(0))=="2"||QString(cdt.at(0))=="3"){
        //funciona
        //r="9cc9";
        r=rA1;
        //r2="1dd1";
        r2=rA2;
    }else if(QString(cdt.at(0))=="1"||QString(cdt.at(0))=="2"||QString(cdt.at(0))=="3"){
        //funciona
        //        r="9dd9";
        //        r2="1cc1";
        r=rB1;
        r2=rB2;
    }else{
        //funciona
        //        r="6dd6";
        //        r2="2cc2";
        r=rC1;
        r2=rC2;
    }
    QByteArray segUser;
    segUser.append(user);
    for (int i = 0; i < 40-user.size()-1; ++i) {
        segUser.append("|");
    }
    segUser.append("-");
    QByteArray segKey;
    segKey.append(key);
    for (int i = 0; i < 20-key.size(); ++i) {
        segKey.append("|");
    }
    QByteArray suH=segUser.toHex();
    QByteArray suHC;
    for (int i = 0; i < suH.size(); ++i) {
        QString uc0;
        uc0.append(suH.at(i));
        if(uc0.contains(r.at(0))){
            suHC.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            suHC.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            suHC.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            suHC.append(r2.at(3));
        }else{
            suHC.append(uc0);
        }
    }

    QByteArray skH=segKey.toHex();
    QByteArray skHC;
    for (int i = 0; i < skH.size(); ++i) {
        QString uc0;
        uc0.append(skH.at(i));
        if(uc0.contains(r.at(0))){
            skHC.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            skHC.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            skHC.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            skHC.append(r2.at(3));
        }else{
            skHC.append(uc0);
        }
    }
    ru.append(suHC);
    ru.append(skHC);
    QString nru;
    nru.append(ru);
    QString cru1 = nru;//.replace("7c7c7c7c7c7c7c7c7c7c", "783d33333b793d31307c");
    QString cru2;
    if(cru1.contains("7c7c7c7c7c7c7c7c7c7c")){
        cru2 = cru1.replace("7c7c7c7c7c7c7c7c7c7c", "783d33333b793d31307c");
    }else if(cru1.contains("7c7c7c7c7c")){
        cru2 = cru1.replace("7c7c7c7c7c", "7a3d313b7c");
    }else{
        cru2=cru1;
    }

    QByteArray ru2;
    ru2.append(cru2);
    QString ret0="";
    ret0.append(r);
    ret0.append(r2);
    ret0.append(ru2);
    QString c;
    c.append(d);
    QByteArray codeUtf8;
    codeUtf8.append(c.toUtf8());
    QString code;
    code.append(codeUtf8.toHex());
    QByteArray encode;
    for (int i = 0; i < code.size(); ++i) {
        QString uc0 = code.at(i);
        if(uc0.contains(r.at(0))){
            encode.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            encode.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            encode.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            encode.append(r2.at(3));
        }else{
            encode.append(uc0);
        }
    }
    ret0.append("||||||");
    ret0.append("I");
    ret0.append(encode);
    ret0.append("O");
    ret0.append(ru);
    return compData(ret0);
}

QString UK::decData(QByteArray d0, QString user, QString key)
{
    QString ret;
    QString pd=QString(d0);
    QByteArray d;
    d.append(desCompData(pd));

    QByteArray arch;
    QByteArray nom;
    int tipo=0;
    QByteArray r;
    QByteArray r2;
    QString passData;
    QByteArray passDataBA;
    bool passDataWrite=false;

    for(int i = 0; i < d.size(); ++i) {
        QString l;
        l.append(d.at(i));
        QByteArray enc;
        if(l.contains(r.at(0))){
            enc.append(r.at(1));
        }else if(l.contains(r.at(2))){
            enc.append(r.at(3));
        }else if(l.contains(r2.at(0))){
            enc.append(r2.at(1));
        }else if(l.contains(r2.at(2))){
            enc.append(r2.at(3));
        }else{
            enc.append(l);
        }
        if(l.contains("O"))
        {
            tipo=0;
        }else if(l.contains("I")){
            tipo=1;
            if(!passDataWrite){
                QByteArray decSegUK;
                for (int i2 = 0; i2 < passDataBA.size(); ++i2) {
                    QString l2;
                    l2.append(passDataBA.at(i2));
                    if(l2.contains(r.at(0))){
                        decSegUK.append(r.at(1));
                    }else if(l2.contains(r.at(2))){
                        decSegUK.append(r.at(3));
                    }else if(l2.contains(r2.at(0))){
                        decSegUK.append(r2.at(1));
                    }else if(l2.contains(r2.at(2))){
                        decSegUK.append(r2.at(3));
                    }else{
                        decSegUK.append(l2);
                    }
                }
                passData.append(QByteArray::fromHex(decSegUK));
                QString pd2 = passData.replace("x=33;r=60|","|");
                QString pd3 = pd2.replace("z=6;|","|");
                QStringList m0 = pd3.split("|-");
                if(m0.size()>1){
                    QString cu = m0.at(0);
                    QString ck = m0.at(1);
                    QString nuser = cu.replace("|", "");
                    QString nkey = ck.replace("|", "");
                    if(user!=nuser||key!=nkey){
                        return "";
                    }
                }else{
                    if(debugLog){
                        lba="";
                        lba.append("Error extract! pass data not found");
                        log(lba);
                    }
                    return "";
                }
            }
            passDataWrite=true;
        }else  if(i<4){
            r.append(l);
        }else  if(i>=4&&i<8){
            r2.append(l);
        }else  if(i>=8&&i<=67+60){
            passDataBA.append(l);
        }else{
            if(tipo==0){
                //nom.append(enc);
            }else{
                arch.append(enc);
            }
        }
    }
    QString nRet;
    nRet.append(QByteArray::fromHex(arch));
    return nRet;
}

QQuickWindow *UK::mainWindow(int n)
{
    if(!_engine->rootObjects().isEmpty()&&_engine->rootObjects().size()>=n){
        QObject *aw0 = _engine->rootObjects().at(n);
        QQuickWindow *window = qobject_cast<QQuickWindow*>(aw0);
        return window;
    }else{
        QObject *aw0 = _engine->rootObjects().at(0);
        QQuickWindow *window2 = qobject_cast<QQuickWindow*>(aw0);
        return window2;
    }
}

void UK::setProperty(const QString name, const QVariant &value)
{
    _engine->rootContext()->setProperty(name.toUtf8().constData(), value);
}

QVariant UK::getProperty(const QString name)
{
    return _engine->rootContext()->property(name.toUtf8());
}

bool UK::isRPI()
{
#ifdef __arm__
#ifndef Q_OS_ANDROID
    return true;
#else
    return false;
#endif
#else
    return false;
#endif
}

QByteArray UK::getHttpFile(QByteArray url)
{
    QEventLoop eventLoop;
    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));
    QNetworkRequest req(QUrl(url.constData()));

    QNetworkReply *reply = mgr.get(req);
    connect(reply,SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(downloadProgress(qint64,qint64)));
    eventLoop.exec();
    QByteArray err;
    if (reply->error() == QNetworkReply::NoError) {

        return reply->readAll();
        delete reply;
    }else if (reply->error() == QNetworkReply::ContentNotFoundError) {
        err.append("Error:404");
        return err;
        delete reply;
    }else{
        if(debugLog){
            lba="";
            lba.append("Failure ");
            lba.append(reply->errorString());
            log(lba);
        }
        err.append(reply->errorString());
        return err;
        delete reply;
    }
    return "";
}

void UK::httpReadyRead()
{
    //...
}

bool UK::downloadZipFile(QByteArray url, QByteArray ubicacion)
{
    log("downloading zip file from: "+url);
    uZipUrl=QString(url);
    uZipSize=-1;
    QEventLoop eventLoop0;
    QNetworkAccessManager mgr0;
    QObject::connect(&mgr0, SIGNAL(finished(QNetworkReply*)), &eventLoop0, SLOT(quit()));
    QNetworkRequest req0(QUrl(url.constData()));
    QNetworkReply *reply0 = mgr0.get(req0);

    connect(
                reply0, &QNetworkReply::metaDataChanged,
                [=]( ) {
        uZipSize=reply0->header(QNetworkRequest::ContentLengthHeader).toInt();
        reply0->deleteLater();
    }
    );


    QEventLoop eventLoop;
    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));
    QNetworkRequest req(QUrl(url.constData()));
    QNetworkReply *reply = mgr.get(req);
    connect(reply,SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(downloadZipProgress(qint64,qint64)));
    //QNetworkReply *reply = mgr.get(req);
    // QThread::sleep(3000);
    eventLoop.exec();
    if (reply->error() == QNetworkReply::NoError) {
        QFile other(ubicacion);
        other.open(QIODevice::WriteOnly);
        other.write(reply->readAll());
        other.flush();
        other.close();
        return true;
    }else{
        if(debugLog){
            QByteArray log100;
            log100.append("Failure ");
            log100.append(reply->errorString());
            log(log100);
        }
        reply->deleteLater();
        return false;
        delete reply;
    }
    return false;
}

void UK::sendFile(QString file, QString phpReceiver)
{
    if(debugLog){
        lba="";
        lba.append("Starting sending data...");
        log(lba);
    }
    QNetworkAccessManager *am = new QNetworkAccessManager(this);
    QByteArray origen;
    origen.append(file);
    QStringList l = file.split("/");
    QByteArray destino;
    destino.append(l.at(l.size()-1));
    QStringList l2 = phpReceiver.split("/");
    if(l2.size()<2){
        return;
    }
    QString path(origen);
    QMimeDatabase dbMt;
    QMimeType type = dbMt.mimeTypeForFile(path);
    if(debugLog){
        lba="";
        lba.append("Mime type: ");
        lba.append(type.name());
        log(lba);
    }
    QByteArray urlReceiver;
    urlReceiver.append(phpReceiver);
    QNetworkRequest request(QUrl(urlReceiver.constData()));
    QString bound="margin";
    QByteArray data;
    data.append("--");
    data.append(bound);
    data.append("\r\n");
    data.append("Content-Disposition: form-data; name=\"action\"\r\n\r\n");
    data.append(l2.at(l2.size()-1));
    data.append("\r\n");
    data.append("--" + bound + "\r\n");
    data.append("Content-Disposition: form-data; name=\"uploaded\"; filename=\""+destino+"\"\r\n");
    data.append("Content-Type: ");
    data.append(type.name());
    data.append("\r\n\r\n");
    if(debugLog){
        lba="";
        lba.append("Origen: ");
        lba.append(origen);
        lba.append(" Destino: ");
        lba.append(destino);
        lba.append(" Ruta: ");
        lba.append(path);
        log(lba);
    }
    QFile localFile(path);
    if (!localFile.open(QIODevice::ReadOnly)){
        if(debugLog){
            lba="";
            lba.append("Error while opening file.");
            log(lba);
        }
        return;
    }else{
        if(debugLog){
            lba="";
            lba.append("Opening file...");
            log(lba);
        }
    }
    data.append(localFile.readAll());
    data.append("\r\n");
    data.append("--" + bound + "--\r\n");
    request.setRawHeader(QString("Accept-Charset").toUtf8(), QString("ISO-8859-1,utf-8;q=0.7,*;q=0.7").toUtf8());
    request.setRawHeader(QString("Content-Type").toUtf8(),QString("multipart/form-data; boundary="+bound).toUtf8());
    request.setRawHeader(QString("Content-Length").toUtf8(), QString::number(data.length()).toUtf8());
    respuentaSendDatos  = am->post(request,data);
    //qDebug() << data.data();
    connect(respuentaSendDatos, SIGNAL(finished()), this, SLOT(sendFinished()));
    connect(respuentaSendDatos,SIGNAL(uploadProgress(qint64,qint64)), this, SLOT(uploadProgress(qint64,qint64)));
}

void UK::uploadProgress(qint64 bytesSend, qint64 bytesTotal)
{
    //double porc = (((double)bytesSend)/bytesTotal)*100;
    // int porc= (int)((bytesSend * 100) / bytesTotal);
    /*#ifdef Q_OS_LINUX

#ifdef Q_OS_ANDROID
    double porc = (((double)bytesSend)/bytesTotal)*100;
#else
    int porc= (int)((bytesSend * 100) / bytesTotal);
#endif

#endif
#ifdef Q_OS_WIN
    double porc = (((double)bytesSend)/bytesTotal)*100;
#endif
#ifdef Q_OS_OSX
    double porc = (((double)bytesSend)/bytesTotal)*100;
#endif
    QString d1;
    d1.append(QString::number(porc));
    QStringList sd1=d1.split(".");
    setPorc(QString(sd1.at(0)).toInt(), 1);*/
    double porc = (((double)bytesSend)/bytesTotal)*100;
    QString d1;
    d1.append(QString::number(porc));
    QStringList sd1=d1.split(".");
    QByteArray nl;
    nl.append("upload ");
    nl.append(uZipUrl);
    nl.append(" %");
    nl.append(sd1.at(0));
    log(nl);
}

void UK::downloadProgress(qint64 bytesSend, qint64 bytesTotal)
{
    //double porc = (((double)bytesSend)/bytesTotal)*100;
    //int porc= (int)((bytesSend * 100) / bytesTotal);
    /*qint32 bs=qint32(bytesSend);
    qint32 bt=qint32(bytesTotal);
#ifdef Q_OS_LINUX
#ifdef Q_OS_ANDROID
    double porc = (((double)bs)/bt)*100;
#else
    int porc= (int)((bytesSend * 100) / bytesTotal);
#endif
#endif
#ifdef Q_OS_WIN
    double porc = (((double)bytesSend)/bytesTotal)*100;
#endif
#ifdef Q_OS_OSX
    double porc = (((double)bytesSend)/bytesTotal)*100;
#endif
    QString d1;
    d1.append(QString::number(porc));
    QStringList sd1=d1.split(".");
    setPorc(QString(sd1.at(0)).toInt(), 0);*/
    double porc = (((double)bytesSend)/bytesTotal)*100;
    QString d1;
    d1.append(QString::number(porc));
    QStringList sd1=d1.split(".");
    QByteArray nl;
    nl.append("download ");
    nl.append(uZipUrl);
    nl.append(" %");
    nl.append(sd1.at(0));
    log(nl);
}
void UK::sendFinished()
{
    if(debugLog){
        lba="";
        lba.append("Sending data finished!\nResponse: ");
        lba.append(respuentaSendDatos->readAll());
        log(lba);
    }
    setUploadState(respuentaSendDatos->readAll());
}

#ifndef Q_OS_ANDROID
void UK::initWebSocketServer(const QByteArray ip, const int port, const QByteArray serverName)
{
    emit initWSS(ip, port, serverName);
}

bool UK::startWSS(const QByteArray ip, const int port, const QByteArray serverName)
{
    QHostAddress addr(ip.constData());
    _server=new QWebSocketServer(QStringLiteral("Unik QWebChannel Standalone Server"),
                                 QWebSocketServer::NonSecureMode);
    if (!_server->listen(addr, port)) {
        qFatal("Failed to open web socket server.");
        return false;
    }
    _clientWrapper=new WebSocketClientWrapper(_server);
    QObject::connect(_clientWrapper, &WebSocketClientWrapper::clientConnected,
                     _channel, &QWebChannel::connectTo);
    _engine->rootContext()->setContextProperty("cw", _clientWrapper);
    return true;
}
#endif
bool UK::sqliteInit(QString pathName)
{
    bool ret=false;
    if(db.isOpen()){
        db.close();
    }
    db = QSqlDatabase::addDatabase("QSQLITE");
    QByteArray rutaBD;
    rutaBD.append(pathName);
    db.setDatabaseName(rutaBD.constData());
    if(!db.open()){
        if(debugLog){
            lba="";
            lba.append("Sqlite open error");
            log(lba);
        }
    }else{
        if(debugLog){
            lba="";
            lba.append("Sqlite open ");
            lba.append(rutaBD);
            log(lba);
        }
    }
    return ret;
}

bool UK::sqlQuery(QString query)
{
    QSqlQuery q;
    q.prepare(query);
    if(q.exec()){
        if(debugLog){
            lba="";
            lba.append("sql query exec: ");
            lba.append(query);
            log(lba);

            QByteArray d;
            d.append("sql query exec: ");
            d.append(query);
            log(d);
        }
        return true;
    }
    if(debugLog){
        lba="";
        lba.append("Last command sqlite failed: ");
        lba.append(query);
        lba.append(" \nError SQL! ");
        lba.append(q.lastError().text());
        log(lba);
    }
    return false;
}

QList<QObject *> UK::getSqlData(QString query)
{
    QList<QObject*> ret;
    QSqlQuery consultar;
    consultar.prepare(query);
    int cantcols=0;
    if(consultar.exec()){
        cantcols = consultar.record().count();
        ret.clear();
        if(debugLog){
            qDebug()<<"Sql query is exec...";
            qInfo("Sql query is exec...");
            QString cc;
            cc.append("Column count: ");
            cc.append(QString::number(cantcols));
            qInfo(cc.toUtf8());
        }
        int v=0;
        while (consultar.next()) {
            Row *r = new Row(this);
            for (int i = 0; i < cantcols; ++i) {
                r->col.append(consultar.value(i).toString());
                v++;
            }
            ret.append(r);
        }
        if(debugLog){
            QByteArray cc;
            cc.append("Row count result: ");
            cc.append(QString::number(v));
            cc.append(" ");
            cc.append("Column count result: ");
            cc.append(QString::number(cantcols));
            log(cc);
        }
    }else{
        if(debugLog){
            lba="";
            lba.append("Sql query no exec: ");
            lba.append(consultar.lastError().text());
            log(lba);
        }
    }
    return ret;
}

bool UK::mysqlInit(QString hostName, QString dataBaseName, QString userName, QString password, int firtOrSecondDB)
{
    bool ret=false;
    if(firtOrSecondDB==1){
        firstDB = QSqlDatabase::addDatabase("QMYSQL");
        firstDB.setHostName(hostName);
        firstDB.setDatabaseName(dataBaseName);
        firstDB.setUserName(userName);
        firstDB.setPassword(password);
        ret = firstDB.open();
    }else{
        secondDB = QSqlDatabase::addDatabase("QMYSQL");
        secondDB.setHostName(hostName);
        secondDB.setDatabaseName(dataBaseName);
        secondDB.setUserName(userName);
        secondDB.setPassword(password);
        ret = secondDB.open();
    }
    return ret;
}

void UK::setMySqlDatabase(QString databaseName, int firtOrSecondDB)
{
    if(firtOrSecondDB==1){
        firstDB.setDatabaseName(databaseName);
    }else{
        secondDB.setDatabaseName(databaseName);
    }
}

void UK::sqliteClose()
{
    db.removeDatabase(QSqlDatabase::database().connectionName());
    db.close();

}

void UK::cd(QString folder)
{
    QDir::setCurrent(folder);
    _engine->addImportPath(QDir::currentPath());
    _engine->addPluginPath(QDir::currentPath());
    qInfo()<<"Set current dir: "<<QDir::currentPath();
}
void UK::deleteFile(QByteArray f)
{
    QFile arch(f);
    arch.remove();
}

bool UK::setFile(QByteArray n, QByteArray d)
{
    QFile file(n);
    if (!file.open(QIODevice::WriteOnly)) {
        lba="";
        lba.append("Cannot open file for writing: ");
        lba.append(file.errorString());
        log(lba);
        return false;
    }
    QTextStream out(&file);
    out.setCodec("UTF-8");
    out << d;
    file.close();
    return true;
}

QString UK::getFile(QByteArray n)
{
    QString r;
    QFile file(n);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        return "error";
    }
    return file.readAll();
}

bool UK::mkdir(const QString path)
{
    QDir dir0(path);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }
    return dir0.exists();
}

QString UK::getUpkTempPath()
{
    QString pq;
    pq.append(QStandardPaths::writableLocation(QStandardPaths::TempLocation));
    pq.append("/");
    pq.append(QDateTime::currentDateTime().toString("hhmmss"));
    pq.append("/");
    if(debugLog){
        lba="";
        lba.append("Temp folder of Qmls: ");
        lba.append(pq);
        //log(lba);
    }
    QDir dir0(pq);
    if (!dir0.exists()) {
        dir0.mkpath(".");
    }
    return pq;
}

QString UK::getUpksLocalPath()
{
    QSettings s;
    QString dupl;
    dupl.append(s.value("ws").toString());
    QDir dirUnikPackLocation(dupl);
    if (!dirUnikPackLocation.exists()) {
        dirUnikPackLocation.mkpath(".");
    }
    return dupl;
}

bool UK::fileExist(QByteArray fileName)
{
    QFile a(fileName);
    return a.exists();
}


#ifdef Q_OS_WIN
bool UK::createLink(QString execString, QString arguments, QString lnkLocationFileName, QString description, QString workingDirectory)
{
    QDir d1(workingDirectory);
    if(!d1.exists()){
        return false;
    }
    QString up;
    up.append(getPath(1));
    up.append("/unik.exe");
    QByteArray upf;
    upf.append(up);
    QByteArray vbs = "";
    /*vbs.append("set WshShell = WScript.CreateObject(\"WScript.Shell\") \n") ;
    vbs.append("strDesktop = WshShell.SpecialFolders(\"Desktop\")  \n") ;
     vbs.append("set oShellLink = WshShell.CreateShortcut( \""+lnkLocationFileName+"\")  \n") ;
              vbs.append("oShellLink.TargetPath = \""+upf+"\"  \n") ;
              vbs.append("oShellLink.WindowStyle = 1  \n") ;
              vbs.append("oShellLink.Hotkey = \"CTRL+SHIFT+R\"  \n") ;
              vbs.append("oShellLink.IconLocation = \"unik.exe, 0\"  \n") ;
              vbs.append("oShellLink.Description = \"Unik Qml Engine\"  \n") ;
              vbs.append("oShellLink.WorkingDirectory = strDesktop  \n") ;
              vbs.append("oShellLink.Save  \n") ;*/

    vbs.append("set WshShell = WScript.CreateObject(\"WScript.Shell\")\n");
    vbs.append("set objShell = CreateObject(\"Shell.Application\")\n");
    vbs.append("set oShellLink = WshShell.CreateShortcut(\""+lnkLocationFileName+"\")\n");
    vbs.append("oShellLink.TargetPath = \""+execString+"\"\n");
    vbs.append("oShellLink.Arguments = \""+arguments+"\"\n");
    vbs.append("oShellLink.WindowStyle = 1\n");
    QByteArray d;
    d.append(description.toUtf8());
    vbs.append("oShellLink.Description = \""+d+"\"\n");
    vbs.append("oShellLink.WorkingDirectory = \""+workingDirectory+"\"\n");
    vbs.append("oShellLink.Save\n");
    QByteArray url;
    url.append(getPath(2));
    url.append("/createLnk.vbs");
    setFile(url, vbs);
    run("cmd /c start "+url);
    qDebug()<<"vbs: "<<url;
    qDebug()<<"vbs data: "<<vbs;
    return true;
}
#endif
#ifdef Q_OS_OSX

#endif
#ifdef Q_OS_LINUX
bool UK::createLink(QString execString, QString desktopLocationFileName, QString name, QString comment)
{
    return createLink(execString, desktopLocationFileName, name, comment, "");
}

bool UK::createLink(QString execString, QString desktopLocationFileName, QString name, QString comment, QString iconPath)
{

    QByteArray desktopFile = "";
    desktopFile.append("[Desktop Entry]\n");
    desktopFile.append("Name="+name+"\n");
    desktopFile.append("Comment="+comment+"\n");
    desktopFile.append("Exec="+execString+"\n");
    QString cf;
    cf.append(iconPath);
    if(cf.isEmpty()){
        cf.append(getPath(4));
        cf.append("/img/unik.png");
    }
    desktopFile.append("Icon="+cf+"\n");
    desktopFile.append("Terminal=false\n");
    desktopFile.append("Type=Application\n");
    QByteArray url;
    url.append(desktopLocationFileName);
    setFile(url, desktopFile);
    run("chmod a+x "+url);
    return true;
}
#endif


QString UK::toHtmlEscaped(QString htmlCode)
{
    return htmlCode.toHtmlEscaped();
}

void UK::crearPDF(QString captura, QString url, int orientacion)
{
    QPdfWriter writer(url);
    QPainter painter(&writer);
    writer.setPageSize(QPagedPaintDevice::A4);
    writer.setPageOrientation(QPageLayout::Portrait);
    writer.setCreator("unik");
    //ESTO SETEADO EN 300 OBLIGA A ESCALAR * 4 LAS IMAGENES
    writer.setResolution(1200);//si esta en 600 va writer.logicalDpiX()*8*2
    //qDebug()<<"Resolucion de QPdfWriter: "<<writer.resolution();
    //qDebug()<<"QPdfWriter Logical DPI X: "<<writer.logicalDpiX();
    //qDebug()<<"QPdfWriter Logical DPI Y: "<<writer.logicalDpiY();
    if(orientacion==1){
        painter.drawPixmap(QRect(0,0,writer.logicalDpiX()*8,writer.logicalDpiY()*11.4),QPixmap(captura));
    }else{
        QMatrix rm;
        rm.rotate(90);
        QPixmap pixmapTemp(captura);
        QPixmap pixmap = pixmapTemp.transformed(rm);
        pixmap.scaled(pixmapTemp.height(), pixmapTemp.width());
        painter.drawPixmap(QRect(0,0,writer.logicalDpiX()*8,writer.logicalDpiY()*11.4),pixmap);
    }
    painter.end();
}



Q_INVOKABLE void UK::initRpiGpio()
{
    #ifdef UNIK_COMPILE_RPI
    rpiGpio = new mmapGpio();
    #endif
}

Q_INVOKABLE void UK::setPinType(int pin, int type)
{
    #ifdef UNIK_COMPILE_RPI
    if(type!=0&&type!=1){
        return;
    }
    if(type==0){
        rpiGpio->setPinDir(pin,mmapGpio::OUTPUT);
    }else{
        rpiGpio->setPinDir(pin,mmapGpio::INPUT);
    }
    #endif
}

Q_INVOKABLE void UK::setPinState(int pin, int state)
{
    #ifdef UNIK_COMPILE_RPI
    if(state!=0&&state!=1){
        return;
    }
    if(state==0){
        rpiGpio->writePinLow(pin);
    }else{
        rpiGpio->writePinHigh(pin);
    }
    #endif
}

Q_INVOKABLE unsigned int UK::readPin(unsigned int pin)
{
    #ifdef UNIK_COMPILE_RPI
    return rpiGpio->readPin(pin);
    #else
    return 0;
    #endif
}

Q_INVOKABLE void UK::writePinHigh(unsigned int pinnum)
{
    #ifdef UNIK_COMPILE_RPI
    rpiGpio->writePinHigh(pinnum);
    #endif
}

Q_INVOKABLE void UK::writePinLow(unsigned int pinnum)
{
    #ifdef UNIK_COMPILE_RPI
    rpiGpio->writePinLow(pinnum);
    #endif
}
Q_INVOKABLE bool UK::pinIsHigh(int pin){
    #ifdef UNIK_COMPILE_RPI
    unsigned int pinVal;
    pinVal = rpiGpio->readPin(pin);
    if(pinVal == mmapGpio::HIGH){
        return false;
    }
    return true;
#else
    return false;
#endif
}


QString UK::encPrivateData(QByteArray d, QString user, QString key)
{
    QString ret;
    QByteArray upkData;
    QByteArray r="6226";
    QByteArray r2="6226";
    QByteArray ru;
    QString cdt = QDateTime::currentDateTime().toString("z");
    if(QString(cdt.at(0))=="1"||QString(cdt.at(0))=="2"||QString(cdt.at(0))=="3"){
        r=rpA1;
        r2=rpA2;
    }else if(QString(cdt.at(0))=="1"||QString(cdt.at(0))=="2"||QString(cdt.at(0))=="3"){
        r=rpB1;
        r2=rpB2;
    }else{
        r=rpC1;
        r2=rpC2;
    }
    QByteArray segUser;
    segUser.append(user);
    for (int i = 0; i < 40-user.size()-1; ++i) {
        segUser.append("|");
    }
    segUser.append("-");
    QByteArray segKey;
    segKey.append(key);
    for (int i = 0; i < 20-key.size(); ++i) {
        segKey.append("|");
    }
    QByteArray suH=segUser.toHex();
    QByteArray suHC;
    for (int i = 0; i < suH.size(); ++i) {
        QString uc0;
        uc0.append(suH.at(i));
        if(uc0.contains(r.at(0))){
            suHC.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            suHC.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            suHC.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            suHC.append(r2.at(3));
        }else{
            suHC.append(uc0);
        }
    }

    QByteArray skH=segKey.toHex();
    QByteArray skHC;
    for (int i = 0; i < skH.size(); ++i) {
        QString uc0;
        uc0.append(skH.at(i));
        if(uc0.contains(r.at(0))){
            skHC.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            skHC.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            skHC.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            skHC.append(r2.at(3));
        }else{
            skHC.append(uc0);
        }
    }
    ru.append(suHC);
    ru.append(skHC);
    QString nru;
    nru.append(ru);
    QString cru1 = nru;//.replace("7c7c7c7c7c7c7c7c7c7c", "783d33333b793d31307c");
    QString cru2;
    if(cru1.contains("7c7c7c7c7c7c7c7c7c7c")){
        cru2 = cru1.replace("7c7c7c7c7c7c7c7c7c7c", "783d33333b793d31307c");
    }else if(cru1.contains("7c7c7c7c7c")){
        cru2 = cru1.replace("7c7c7c7c7c", "7a3d313b7c");
    }else{
        cru2=cru1;
    }

    QByteArray ru2;
    ru2.append(cru2);

    QString ret0="";
    ret0.append(r);
    ret0.append(r2);
    ret0.append(ru2);
    QString c;
    c.append(d);
    QByteArray codeUtf8;
    codeUtf8.append(c.toUtf8());
    QString code;
    code.append(codeUtf8.toHex());
    QByteArray encode;
    for (int i = 0; i < code.size(); ++i) {
        QString uc0 = code.at(i);
        if(uc0.contains(r.at(0))){
            encode.append(r.at(1));
        }else if(uc0.contains(r.at(2))){
            encode.append(r.at(3));
        }else if(uc0.contains(r2.at(0))){
            encode.append(r2.at(1));
        }else if(uc0.contains(r2.at(2))){
            encode.append(r2.at(3));
        }else{
            encode.append(uc0);
        }
    }

    ret0.append("||||||");
    ret0.append("I");
    ret0.append(encode);
    ret0.append("O");
    ret0.append(ru);

    return compData(ret0);
}

QString UK::decPrivateData(QByteArray d0, QString user, QString key)
{
    QString ret;

    QString pd=QString(d0);
    QByteArray d;
    d.append(desCompData(pd));

    QByteArray arch;
    QByteArray nom;
    int tipo=0;
    QByteArray r;
    QByteArray r2;
    QString passData;
    QByteArray passDataBA;
    bool passDataWrite=false;

    for (int i = 0; i < d.size(); ++i) {
        QString l;
        l.append(d.at(i));
        QByteArray enc;
        if(l.contains(r.at(0))){
            enc.append(r.at(1));
        }else if(l.contains(r.at(2))){
            enc.append(r.at(3));
        }else if(l.contains(r2.at(0))){
            enc.append(r2.at(1));
        }else if(l.contains(r2.at(2))){
            enc.append(r2.at(3));
        }else{
            enc.append(l);
        }
        if(l.contains("O"))
        {
            tipo=0;
        }else if(l.contains("I")){
            tipo=1;
            if(!passDataWrite){
                QByteArray decSegUK;
                for (int i2 = 0; i2 < passDataBA.size(); ++i2) {
                    QString l2;
                    l2.append(passDataBA.at(i2));
                    if(l2.contains(r.at(0))){
                        decSegUK.append(r.at(1));
                    }else if(l2.contains(r.at(2))){
                        decSegUK.append(r.at(3));
                    }else if(l2.contains(r2.at(0))){
                        decSegUK.append(r2.at(1));
                    }else if(l2.contains(r2.at(2))){
                        decSegUK.append(r2.at(3));
                    }else{
                        decSegUK.append(l2);
                    }
                }
                passData.append(QByteArray::fromHex(decSegUK));
                QString pd2 = passData.replace("x=33;r=60|","|");
                QString pd3 = pd2.replace("z=6;|","|");
                QStringList m0 = pd3.split("|-");
                if(m0.size()>1){
                    QString cu = m0.at(0);
                    QString ck = m0.at(1);
                    QString nuser = cu.replace("|", "");
                    QString nkey = ck.replace("|", "");
                    if(user!=nuser||key!=nkey){
                        return "";
                    }
                }else{
                    if(debugLog){
                        lba="";
                        lba.append("Error extract! pass data not found.");
                        log(lba);
                    }
                    return "";
                }
            }
            passDataWrite=true;
        }else  if(i<4){
            if(l=="0"){
                r.append("d");
            }else if(l=="2"){
                r.append("9");
            }else if(l=="3"){
                r.append("9");
            }else{
                r.append(l);
            }
        }else  if(i>=4&&i<8){
            if(l=="4"){
                r2.append("c");
            }else if(l=="3"){
                r2.append("1");
            }else if(l=="2"){
                r2.append("1");
            }else{
                r2.append(l);
            }
        }else  if(i>=8&&i<=67+60){
            passDataBA.append(l);
        }else{
            if(tipo==0){
                //nom.append(enc);
            }else{
                arch.append(enc);
            }
        }
    }
    QString nRet;
    nRet.append(QByteArray::fromHex(arch));
    return nRet;
}

QString UK::compData(QString d)
{
    QString nd=d;
    for (int i = 0; i < lsim.size(); ++i) {
        QByteArray rs;
        rs.append(lsim.at(i));
        QByteArray rn;
        rn.append(lnum.at(i));
        QString ad = nd;
        nd=ad.replace(rn, rs);
    }
    return nd;
}

QString UK::desCompData(QString d)
{
    QString nd=d;
    for (int i = 0; i < lsim.size(); ++i) {
        QByteArray rs;
        rs.append(lsim.at(i));
        QByteArray rn;
        rn.append(lnum.at(i));
        QString ad = nd;
        nd=ad.replace(rs, rn);
    }
    return nd;
}

void UK::downloadZipProgress(qint64 bytesSend, qint64 bytesTotal)
{

    /*qint32 bs=qint32(bytesSend);
    qint32 bt=qint32(bytesTotal);
    if(bt<0){
        bt=uZipSize;
    }
#ifdef Q_OS_LINUX
#ifdef Q_OS_ANDROID
     double porc = (((double)bs)/bt)*100;
#else
    int porc= (int)((bytesSend * 100) / bt);
#endif

#endif
#ifdef Q_OS_WIN
    double porc = (((double)bytesSend)/bt)*100;
#endif
#ifdef Q_OS_OSX
    double porc = (((double)bytesSend)/bt)*100;
#endif*/
    double porc;
    if(bytesTotal==-1){
        porc = 1.0;
    }else if(bytesTotal==-1&&uZipSize!=-1){
        porc = (((double)bytesSend)/uZipSize)*100;
    }else{
        porc = (((double)bytesSend)/bytesTotal)*100;
    }
    QString d1;
    d1.append(QString::number(porc));
    QStringList sd1=d1.split(".");
    QByteArray nl;
    nl.append("download git ");
    nl.append(uZipUrl);
    nl.append(" %");
    nl.append(sd1.at(0));
    log(nl);
}

#ifdef Q_OS_WIN
int UK::frameHeight(QObject *window)
{
    QQuickWindow *qw = qobject_cast<QQuickWindow *>(window);
    if(qw)
        return qw->frameGeometry().height();
    return QRect().height();
}

int UK::frameWidth(QObject *window)
{
    QQuickWindow *qw = qobject_cast<QQuickWindow *>(window);
    if(qw)
        return qw->frameGeometry().width();
    return QRect().width();
}
#endif
