#ifndef ROW_H
#define ROW_H

#include <QObject>

class Row : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList col READ getCol WRITE setCol)
public:
    explicit Row(QObject *parent = nullptr);
    QStringList col;
    void setCol(QStringList c){
        col = c;
    }
    QStringList getCol(){
        return col;
    }

signals:

public slots:
};

#endif // ROW_H
