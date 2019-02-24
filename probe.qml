import QtQuick 2.9
import QtQuick.Controls 2.0
//import LogView 1.0
ApplicationWindow {
    id: app
    objectName: 'qmlandia'
    visible: true
    visibility: 'Maximized'
    //Connections {target: unik;onUkStdChanged: log.text+=('ff'+unikLog).replace(/\n/g, ' ');}
    /*UK{id:uk}
    Connections {target: uk;onUkStdChanged: log.text=(''+uk.ukStd).replace(/\n/g, ' ');}
    Connections {target: uk;onStdErrChanged: log.text=(''+uk.getStdErr()).replace(/\n/g, ' ');}

*/

    //Connections {target: unik;onUkStdChanged: log.text+=('ff'+unik.getUkStd()).replace(/\n/g, ' ');}
    //Connections {target: unik;onStdErrChanged: log.text+=('sss'+unik.ukStd).replace(/\n/g, ' ');}


    Rectangle{
        anchors.fill: parent
        color: 'blue'
        //UK{id:uk}

        /*Text{
            id:log
            color:'white'
            font.pixelSize: 20
            anchors.centerIn: parent
        }*/
//        LogView{
//            id: logView
//            anchors.fill: parent
//            fontColor: "red"
//            fontSize: 30

//        }
    }
    Timer{
        running: true
        repeat: true
        interval: 5000
        onTriggered: {
            //var d = new Date(Date.now())
            //console.log('Probe LogView--->'+d.getTime())
            unik.setUploadState('-git=https://github.com/nextsigner/unik-ws-android-client-1.git')
            unik.restartApp()
        }
    }
    Component.onCompleted:  {

    }
}
