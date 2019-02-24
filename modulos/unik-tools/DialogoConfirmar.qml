import QtQuick 2.0
import QtQuick.Controls 2.0
Item {
    id: raiz
    height: col.height+app.fs
    property alias consulta: cons.text
    property alias titulo: tit.text
    property string ctx: 'AceptarCancelar'
    property int estadoEntrada: 0
    property int estadoSalida: 0
    //ES 0 cancelado
    //ES 1 aceptado

    onVisibleChanged: {
        if(!visible){
            ctx = 'AceptarCancelar'
            //estadoEntrada=0
        }
    }
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
            }
            Text {
                id: cons
                font.pixelSize: app.fs
                color: app.c2
                width: raiz.width*0.8
                //height: col.height-app.fs*1.4-app.fs*3-app.fs*0.5
                //height: contentHeight+app.fs*2
                wrapMode: Text.WordWrap
            }
            Row{
                anchors.right: parent.right
                anchors.rightMargin: app.fs*0.5
                height: app.fs*1.4
                spacing: app.fs*0.5
                Button{
                    height: app.fs*1.4
                    text: raiz.ctx === 'AceptarCancelar' ? "Cancelar" : "No"
                    font.pixelSize: app.fs
                    background: Rectangle{color:app.c2; radius: app.fs*0.3;}
                    onClicked: {
                        raiz.estadoSalida = 0
                        raiz.visible = false
                    }
                }
                Button{
                    height: app.fs*1.4
                    text: raiz.ctx === 'AceptarCancelar' ? "Aceptar" : "Si"
                    font.pixelSize: app.fs
                    background: Rectangle{color:app.c2; radius: app.fs*0.3;}
                    onClicked: {
                        raiz.estadoSalida = 1
                        raiz.visible = false
                    }
                }

            }
        }
    }
}
