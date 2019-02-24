import QtQuick 2.0
import QtQuick.Controls 2.0
import LogView 1.0
import uk 1.0
ApplicationWindow {
    id: app
    objectName: 'qmlandia'
    visible: true
    visibility: 'Maximized'

    Rectangle{
        anchors.fill: parent
        color: '#ff8833'
        LogView{
            id: logView
            width:  parent.width
            height:  400
            anchors.bottom: parent.bottom
            fontSize: 20
            topHandlerHeight: 6
            showUnikControls: true
        }
    }
    Timer{
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            var d = new Date(Date.now())
            console.log('Qmlandia: '+d.getTime()+'<br>')
        }
    }

}
