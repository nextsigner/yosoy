#include <QtQml/QQmlExtensionPlugin>
#include <QtQml/qqml.h>
#include <QQuickItem>
#include <QtGui>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QGraphicsProxyWidget>
#include <QDebug>
#include <myeditor.h>

class MyPushButton : public QGraphicsProxyWidget
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    MyPushButton(QGraphicsItem* parent = 0)
        : QGraphicsProxyWidget(parent)
    {
        widget = new QPushButton("MyPushButton");
        widget->setAttribute(Qt::WA_NoSystemBackground);
        setWidget(widget);

        QObject::connect(widget, SIGNAL(clicked(bool)), this, SIGNAL(clicked(bool)));
    }

    QString text() const
    {
        return widget->text();
    }

    void setText(const QString& text)
    {
        if (text != widget->text()) {
            widget->setText(text);
            emit textChanged();
        }
    }

Q_SIGNALS:
    void clicked(bool);
    void textChanged();

private:
    QPushButton *widget;
};

class QExampleQmlPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    QExampleQmlPlugin() {
        //MyPushButton p;
        //MyEditor *e = new MyEditor();
        //e->show();
        //QWidget *w = new QWidget(this->parent());
        //WidgetAnchor w this->parent();
       pb=new MyPushButton();
       QGraphicsProxyWidget *proxy = new QGraphicsProxyWidget(this);
//      QGraphicsProxyWidget proxy;
//      proxy.setWidget(&pb);
//      proxy.setPos(-pb.sizeHint().width()/2, -pb.sizeHint().height()/2);
    }
    void registerTypes(const char *uri)
    {
        Q_ASSERT(uri == QLatin1String("QmlCodeEditor"));
        //Q_ASSERT(uri == QLatin1String("PushButtonItem"));
        qmlRegisterType<QExampleQmlPlugin>(uri, 1, 0, "MyEditor");
        qDebug()<<"---------------------------->"<<uri;
        //qmlRegisterType<PushButtonItem>(uri, 1, 0, "PushButtonItem");
    }
//    void initializeEngine(QQmlEngine *engine, const char *uri)
//    {
//        QQmlExtensionPlugin::initializeEngine(engine, uri);
//    }
  private:
    MyPushButton *pb;

};

#include "qmlcodeeditor.moc"
