#include "myeditor.h"

MyEditor::MyEditor(QWidget *parent) :
    QTextEdit(parent)
{
    this->setHtml("<h1>Hello World</h1>");
    this->setGeometry(0,0,300,100);
    this->show();
}

MyEditor::~MyEditor() {

}
