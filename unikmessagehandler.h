#ifndef UNIKMESSAGEHANDLER_H
#define UNIKMESSAGEHANDLER_H

#include <QObject>
#include <QtMessageHandler>

class unikMessageHandler : public QObject
{
    Q_OBJECT
public:
    explicit unikMessageHandler(QObject *parent = nullptr);

signals:

public slots:
};

#endif // UNIKMESSAGEHANDLER_H
