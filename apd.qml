import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.2
ApplicationWindow {
    id: apd
    objectName: 'apd'
    visibility:  "Maximized"
    color: "red"
    property int fs: width<height?(Qt.platform.os !=='android'?apd.width*0.02:apd.width*0.06):(Qt.platform.os !=='android'?apd.width*0.02:apd.width*0.03)
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"

    Text {
        id: not
        font.pixelSize: apd.fs
        color: 'white'
        anchors.centerIn: parent
        text: span?'Error!\nUnik no tiene permisos de escritura\en '+pws:'Error!\nUnik does not have write permission\in '+pws
        property bool span: true
        width: apd.width*0.85
        wrapMode: Text.WordWrap
    }
    MouseArea{
        anchors.fill: parent
        onClicked: Qt.quit()
    }
    Timer{
        running: true
        repeat: true
        interval: 3000
        onTriggered: {
            not.span=!not.span
        }
    }

}



