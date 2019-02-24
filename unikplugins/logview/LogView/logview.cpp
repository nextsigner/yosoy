#include <QtQml/QQmlExtensionPlugin>
#include <QtQml/qqml.h>

class QExampleQmlPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri)
    {
        Q_ASSERT(uri == QLatin1String("LogView"));
        //qmlRegisterType<TimeModel>(uri, 1, 0, "Time");
    }
};

#include "logview.moc"
