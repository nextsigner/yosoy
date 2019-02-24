#ifndef MYEDITOR
#define MYEDITOR

#include <QtGui>
#include <QTextEdit>


class MyEditor : public QTextEdit
{
    Q_OBJECT

public:
    explicit MyEditor(QWidget *parent = 0);
    ~MyEditor();


};

#endif // MYEDITOR
