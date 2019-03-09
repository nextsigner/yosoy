import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
ApplicationWindow{
    id: appSplash
    objectName: 'awsplash'
    visible: true
    visibility: "FullScreen"
    color: "white"
    property bool ver: true
    property color c1: "#1fbc05"
    property color c2: "#4fec35"

    Connections {target: unik;onUkStdChanged:log.setTxtLog(''+unik.ukStd);}
    Connections {target: unik;onUkStdChanged: log.setTxtLog(''+unik.ukStd); }

    onClosing: {
        //close.accepted = false
    }

    Timer{
        running: true
        repeat: true
        interval: 10
        onTriggered: {
            if(!splashvisible){
                appSplash.color = "transparent"
                r.visible=false
            }
        }
        //onTriggered: appSplash.visible=false
    }
    Rectangle{
        id:r
        width: parent.width
        height: xTxtLog.height-logo.height
        color: "transparent"
        anchors.centerIn: parent
        Behavior on opacity{
            NumberAnimation{
                duration:500
            }
        }
        Image {
            id: logo
            width: parent.width*0.25
            height: width
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.centerIn: parent
            source: "qrc:/resources/logo_yosoy_500x500.png"
            opacity: 0.0
            Behavior on opacity {
                NumberAnimation{
                    duration: 1500
                }
            }
        }
        Text{
            text: "by <b>@nextsigner</b>"
            font.pixelSize: 14
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 46
            opacity: logo.opacity
        }
        Rectangle{
            id:xTxtLog
            opacity: logo.opacity
            width: Screen.desktopAvailableWidth<Screen.desktopAvailableHeight ? Screen.desktopAvailableWidth*0.9 : Screen.desktopAvailableHeight*0.9
            height: log.contentHeight
            anchors.top: logo.bottom
            anchors.topMargin: -4
            anchors.horizontalCenter: r.horizontalCenter
            color: "white"
            radius: 6
            border.width: 1
            border.color: 'black'
            clip:true
            Rectangle{
                id:pb
                height: parent.height*0.1
                width: 0
                color: 'red'
                anchors.bottom: parent.bottom
            }
            Text{
                id: log
                color: 'black'
                width: appSplash.width<appSplash.height ? appSplash.width*0.9 : appSplash.height*0.9
                height: contentHeight
                wrapMode: Text.WordWrap
                font.pixelSize: 10
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                function setTxtLog(t){
                    var  d=(''+t).replace(/\n/g, ' ')
                    var p=true
                    if(d.indexOf('Socket')>=0){
                        p=false
                    }else if(d.indexOf('download git')>=0){
                        var m0=''+d.replace('download git ','')
                        var m1=m0.split(' ')
                        if(m1.length>1){
                            var m2=(''+m1[1]).replace('%','')
                            //unik.setFile('/home/nextsigner/nnn', ''+m2)
                            var m3=parseInt(m2.replace(/ /g,''))
                            pb.width=pb.parent.width/100*m3
                        }

                    }
                    if(p){
                        log.text=t
                    }
                }
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                appSplash.color = "transparent"
                r.visible=false
            }
        }
    }
    Component.onCompleted: {
        logo.opacity=1.0
        console.log("Splash Android running...")
    }
}
