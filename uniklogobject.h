#ifndef UNIKLOGOBJECT_H
#define UNIKLOGOBJECT_H

#include <QObject>

class UnikLogObject : public QObject
{
    Q_OBJECT
public:
    explicit UnikLogObject(QObject *parent = nullptr);
    void setLog(QByteArray l);

signals:
    void logReceived(QByteArray l);
public slots:
};

#endif // UNIKLOGOBJECT_H
