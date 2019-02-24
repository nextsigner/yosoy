import QtQuick 2.0
import QtQuick.Layouts 1.3
Item {
    id: raiz
    property alias w: raiz.width
    property alias h: raiz.height
    property alias t: txt.text
    property alias c: txt.color
    property string b:'red'
    property alias f: txt.font.family
    property int r:6
    property int tp: 0
    signal clicking
    Layout.preferredWidth:  w
    Layout.preferredHeight: h
    Rectangle{
        id: rect
        width:  raiz.width
        height: width
        color: 'transparent'
        radius: raiz.r
        anchors.centerIn: raiz
        border.width: 1
        border.color: txt.color
        Rectangle{
            id:bg
            color: raiz.b
            anchors.fill: parent
            border.width: 1
            border.color: txt.color
            radius: parent.radius
        }
        ParallelAnimation{
                id: an
                running: false
                NumberAnimation {
                    target: rect
                    property: "width"
                    from: rect.width*0.5
                    to: raiz.width
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
        }
    }
    MouseArea{
        id:ma
        anchors.fill: raiz
        property bool pre: false
        hoverEnabled: true
        onClicked: {
            ma.pre=false
            an.start()
            clicking()
        }
        onPressed: {ma.pre=true;tp.start()}
        onReleased: {ma.pre=false;tp.stop()}
        Timer{
            id: tp
            running: false
            repeat: false
            interval: 1500
            onTriggered: {
                    raiz.p = !raiz.p
            }
        }
    }
    Text {
        id: txt
        font.pixelSize: raiz.height*0.8
        anchors.centerIn: raiz
        font.family: "FontAwesome"
    }
}
