#include "uniklogobject.h"

UnikLogObject::UnikLogObject(QObject *parent) : QObject(parent)
{

}

void UnikLogObject::setLog(QByteArray l)
{
    emit logReceived(l);
}
