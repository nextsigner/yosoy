#ifndef UNIKARGSPROC_H
#define UNIKARGSPROC_H

#include <QObject>
#include <QSettings>
#include <QFileInfo>
#include <QDir>
#include <QProcess>
#include <QStandardPaths>
#include <QDebug>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>

class UnikArgsProc : public QObject
{
    Q_OBJECT
public:
    explicit UnikArgsProc(QObject *parent = nullptr);

    QStringList args;
    QString dp;//Documents Path
    QString ws;//Work Space
    QString cd;//Current Dir
    QString gm;//Git Module

    QString dim="";
    QString pos="";

    bool errorWritePermission=false;
    bool showLaunch=true;
    bool modeFolder=false;
    bool modeFolderToUpk=false;
    bool modeRemoteFolder=false;
    bool modeUpk=false;
    bool modeGit=false;
    bool modeGitArg=false;
    bool updateUnikTools=false;
    bool loadConfig=false;
    bool readConfig=true;
    bool debugLog=false;
    bool setPass=false;
    bool setPass1=false;
    bool setPass2=false;
    bool makeUpk=false;

signals:

public slots:
    void init();
    void procArgs();
    void procCfgArgs();
    void procUSSArgs();

private:
    QSettings settings;
};

#endif // UNIKARGSPROC_H
