import QtQuick 2.0
import QtQuick.Controls 2.0
Item {
    id: raiz
    height: col.height+app.fs
    property alias info: info.text
    property alias tit: tit.text
    Rectangle{
        anchors.fill: raiz
        color: app.c5
        border.width: 1
        border.color: app.c2
        radius: app.fs*0.2

        Column{
            id:col
            width: parent.width-app.fs
            //height: parent.height-app.fs
            anchors.centerIn: parent
            spacing: app.fs
            Text {
                id: tit
                font.pixelSize: app.fs
                color: app.c2
                text: '<b>Información</b>'
            }
            Text {
                id: info
                font.pixelSize: app.fs
                color: app.c2
                width: raiz.width*0.8
                wrapMode: Text.WordWrap
            }
            Row{
                anchors.right: parent.right
                anchors.rightMargin: app.fs*0.5
                height: app.fs*1.4
                spacing: app.fs*0.5
                Button{
                    height: app.fs*1.4
                    text:  "Aceptar"
                    font.pixelSize: app.fs
                    background: Rectangle{color:app.c2; radius: app.fs*0.3;}
                    onClicked: {
                        raiz.visible = false
                    }
                }

            }
        }
    }
}
