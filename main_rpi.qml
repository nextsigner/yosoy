//import QtQuick 2.0
//import QtQuick.Controls 2.0
//import QtQuick.Layouts 1.3
//import QtQuick.Window 2.0
//import QtQuick.Dialogs 1.2
//import QtQuick.LocalStorage 2.0
//import QtQuick.Particles 2.0
//import QtQuick.Window 2.0
//import QtQuick.XmlListModel 2.0
//import QtQuick.Controls.Styles 1.4
////import QtMultimedia 5.9
////import QtQuick.Templates 2.2
////import QtWebView 1.1
////import Qt.labs.calendar 1.0
//import Qt.labs.folderlistmodel 2.2
//import Qt.labs.settings 1.0
////import LogView 1.0

//ApplicationWindow {
//    id: app
//    objectName: 'unik-main-errors'
//    visible: true
//    flags: Qt.Window | Qt.FramelessWindowHint
//    width: Screen.desktopAvailableWidth
//    height: Screen.desktopAvailableHeight

//    title: qsTr("uniK-status")

//    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
//    //Connections {target: unik;onUkStdChanged: logView.log(unik.ukStd);}
//    //Connections {target: unik;onStdErrChanged: logView.log(unik.getStdErr());}
//    property int fs: Qt.platform.os !=='android'?app.width*0.02:app.width*0.03
//    property color c1: "#1fbc05"
//    property color c2: "#4fec35"
//    property color c3: "white"
//    property color c4: "black"
//    property color c5: "#333333"
//    property int area: 0
//    Settings{
//        id: appSettingsUnik
//        category: 'conf-unik-main-errors'
//        property string languaje: 'English'
//        property int lvfs
//        onLvfsChanged: logView.log('')

//    }
//    Rectangle{
//        anchors.fill: parent
//        color: "#333"
//        Item{
//            id: xTools
//            width: app.fs*1.5
//            height: parent.height
//            z:99999
//            Column{
//                id: colTools
//                width: parent.width*0.8
//                anchors.horizontalCenter: parent.horizontalCenter
//                spacing:  Qt.platform.os !=='android'?width*0.5:width*0.25
//                anchors.verticalCenter: parent.verticalCenter

//                Boton{//Show Debug Panel
//                    id:btnShowDP
//                    w:parent.width
//                    h: w
//                    t: '\uf188'
//                    d:'Ver panel de la salida estandar de esta y otras instancias de unik para depurar errores y conocer eventos'
//                    b:app.area===0?app.c2:'#444'
//                    c: app.area===0?'black':'#ccc'
//                    onClicking: {
//                        app.area=0
//                    }
//                }
//                Boton{//Config
//                    w:parent.width
//                    h: w
//                    t: '\uf013'
//                    d:'Editar config.json de unik y yosoy'
//                    b:app.area===1?app.c2:'#444'
//                    c: app.area===1?'black':'#ccc'
//                    visible: parseFloat(version)>2.12
//                    onClicking: {
//                        app.area = 1
//                    }
//                }
//                Boton{//Actualizar yosoy
//                    id:btnUpdate
//                    w:parent.width
//                    h: w
//                    t: '\uf021'
//                    d:'Actualizar el còdigo fuente de yosoy desde GitHub.com'
//                    b: up ? 'red':app.c1
//                    c: up ? 'white':'#000'
//                    property bool up: false
//                    onClicking: {
//                        if(Qt.platform.os!=='android'){
//                            unik.restartApp("-git=https://github.com/nextsigner/yosoy-luz.git")
//                        }else{
//                            var gitDownloaded=unik.downloadGit('https://github.com/nextsigner/yosoy', appsDir+'/yosoy')
//                            if(gitDownloaded){
//                                var j=appsDir+'/temp_config.json'
//                                var c='{"mode":"-folder", "arg1": "'+appsDir+'/yosoy'+'"}'
//                                unik.setFile(j, c)
//                                unik.restartApp()
//                            }
//                        }
//                    }
//                }
//                Boton{//Restart
//                    w:parent.width
//                    h: w
//                    t: '\uf021'
//                    d:'Reiniciar unik'
//                    b:"#444444"
//                    c: app.c1
//                    onClicking: {
//                        unik.restartApp()
//                    }
//                    Text {
//                        text: "\uf011"
//                        font.family: "FontAwesome"
//                        font.pixelSize: parent.height*0.3
//                        anchors.centerIn: parent
//                        color: app.c2
//                    }
//                }
//                Boton{//Quit
//                    w:parent.width
//                    h: w
//                    t: "\uf011"
//                    d:'Apagar unik'
//                    b:"#444444"
//                    c: app.c1
//                    onClicking: {
//                        Qt.quit()
//                    }
//                }
//            }

//        }

//        LogView{
//            id: logView
//            width: parent.width-xTools.width
//            height: parent.height
//            visible: app.area===0
//            anchors.left: xTools.right
//            bgColor: app.c5
//        }
//        Rectangle{
//            id: xEditor
//            width: parent.width-xTools.width
//            height: parent.height
//            color: "#333333"
//            visible: app.area===1
//            anchors.left: xTools.right
//            onVisibleChanged: {
//                if(visible){
//                    txtEdit.text = unik.getFile(appsDir+'/config.json')
//                }
//            }
//            TextEdit{
//                id: txtEdit
//                width: parent.width*0.98
//                height: parent.height/3
//                anchors.horizontalCenter: parent.horizontalCenter
//                font.pixelSize: app.width*0.02
//                wrapMode: Text.WordWrap
//                Rectangle{
//                    anchors.fill: parent
//                    z: parent.z-1
//                }
//            }
//            Rectangle{
//                width: labelbtn2.contentWidth*1.2
//                height: app.width*0.02
//                anchors.bottom: parent.bottom
//                anchors.bottomMargin: app.width*0.005
//                anchors.left: parent.left
//                anchors.leftMargin: app.width*0.005
//                Text {
//                    id:labelbtn2
//                    text: "Cancel"
//                    font.pixelSize: app.width*0.015
//                    anchors.centerIn: parent
//                }
//                MouseArea{
//                    anchors.fill: parent
//                    onClicked: {
//                        app.area=0
//                    }
//                }
//            }

//            Rectangle{
//                width: labelbtnDelete.contentWidth*1.2
//                height: app.width*0.02
//                anchors.bottom: parent.bottom
//                anchors.bottomMargin: app.width*0.005
//                anchors.horizontalCenter: parent.horizontalCenter
//                Text {
//                    id:labelbtnDelete
//                    text: "Delete Config File"
//                    font.pixelSize: app.width*0.015
//                    anchors.centerIn: parent
//                }
//                MouseArea{
//                    anchors.fill: parent
//                    onClicked: {
//                        var p = appsDir+'/config.json'
//                        console.log("Config File Deleted: "+p)
//                        console.log("Unik have yosoy a default app.")
//                        unik.deleteFile(p)
//                        app.area=0
//                    }
//                }
//            }

//            Rectangle{
//                width: labelbtn3.contentWidth*1.2
//                height: app.width*0.02
//                anchors.bottom: parent.bottom
//                anchors.bottomMargin: app.width*0.005
//                anchors.right: parent.right
//                anchors.rightMargin: app.width*0.005
//                Text {
//                    id:labelbtn3
//                    text: "Set Config"
//                    font.pixelSize: app.width*0.015
//                    anchors.centerIn: parent
//                }
//                MouseArea{
//                    anchors.fill: parent
//                    onClicked: {
//                        var p = appsDir+'/config.json'
//                        console.log("Config Path: "+p)
//                        console.log("New Config Data: "+txtEdit.text)
//                        unik.setFile(p, txtEdit.text)
//                        app.area=0

//                        //xEditor.visible = false
//                    }
//                }
//            }
//        }
//    }
//    Component.onCompleted: {
//        if(Qt.platform.os==='windows'){
//            var a1 = Screen.desktopAvailableHeight
//            var altoBarra = a1-unik.frameHeight(app)
//            app.height = a1-altoBarra
//        }
//    }
//}
import QtQuick 2.7

import QtQuick.Controls 2.0


import QtQuick.Layouts 1.3
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Particles 2.0
import QtQuick.Window 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.0
//import QtQuick.Templates 2.2
//import QtWebView 1.1
import Qt.labs.calendar 1.0
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0

import QtGraphicalEffects 1.0
//import QtCanvas3D 1.1

//import QtPositioning 5.9
//import QtLocation 5.9

ApplicationWindow {
    id: app
    objectName: 'unik-main-errors'
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    title: qsTr("uniK-status")

    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    //Connections {target: unik;onUkStdChanged: logView.log(unik.ukStd);}
    //Connections {target: unik;onStdErrChanged: logView.log(unik.getStdErr());}
    property int fs: Qt.platform.os !=='android'?app.width*0.02:app.width*0.03
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"
    property int area: 0
    Settings{
        id: appSettingsUnik
        category: 'conf-unik-main-errors'
        property string languaje: 'English'
        property int lvfs
        onLvfsChanged: logView.log('')

    }
    Rectangle{
        anchors.fill: parent
        color: "#333"
        Item{
            id: xTools
            width: app.fs*1.5
            height: parent.height
            z:99999
            Column{
                id: colTools
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                spacing:  Qt.platform.os !=='android'?width*0.5:width*0.25
                anchors.verticalCenter: parent.verticalCenter

                Boton{//Show Debug Panel
                    id:btnShowDP
                    w:parent.width
                    h: w
                    t: '\uf188'
                    d:'Ver panel de la salida estandar de esta y otras instancias de unik para depurar errores y conocer eventos'
                    b:app.area===0?app.c2:'#444'
                    c: app.area===0?'black':'#ccc'
                    onClicking: {
                        app.area=0
                    }
                }
                Boton{//Config
                    w:parent.width
                    h: w
                    t: '\uf013'
                    d:'Editar cfg.json de unik y yosoy'
                    b:app.area===1?app.c2:'#444'
                    c: app.area===1?'black':'#ccc'
                    visible: parseFloat(version)>2.12
                    onClicking: {
                        app.area = 1
                    }
                }
                Boton{//Actualizar yosoy
                    id:btnUpdate
                    w:parent.width
                    h: w
                    t: '\uf021'
                    d:'Actualizar el còdigo fuente de yosoy desde GitHub.com'
                    b: up ? 'red':app.c1
                    c: up ? 'white':'#000'
                    property bool up: false
                    onClicking: {
                        if(Qt.platform.os!=='android'){
                            unik.restartApp("-git=https://github.com/nextsigner/yosoy-luz.git")
                        }else{
                            var gitDownloaded=unik.downloadGit('https://github.com/nextsigner/yosoy', appsDir+'/yosoy')
                            if(gitDownloaded){
                                var j=appsDir+'/temp_cfg.json'
                                var c='{"arg0":"-folder='+appsDir+'/yosoy'+'"}'
                                unik.setFile(j, c)
                                unik.restartApp()
                            }
                        }
                    }
                }
                Boton{//Restart
                    w:parent.width
                    h: w
                    t: '\uf021'
                    d:'Reiniciar unik'
                    b:"#444444"
                    c: app.c1
                    onClicking: {
                        unik.restartApp()
                    }
                    Text {
                        text: "\uf011"
                        font.family: "FontAwesome"
                        font.pixelSize: parent.height*0.3
                        anchors.centerIn: parent
                        color: app.c2
                    }
                }
                Boton{//Quit
                    w:parent.width
                    h: w
                    t: "\uf011"
                    d:'Apagar unik'
                    b:"#444444"
                    c: app.c1
                    onClicking: {
                        Qt.quit()
                    }
                }
            }

        }
        Rectangle{
            id: xTaLog
            width: parent.width-xTools.width
            height: parent.height
            color: "#333333"
            //visible: app.area===0
            anchors.left: xTools.right
            Flickable{
                id:fk
                width: parent.width
                height: parent.height
                contentWidth: taLog.width
                contentHeight: taLog.height
                Text {
                    id: taLog
                    text: qsTr("Unik Main Qml")
                    width: parent.width
                    height: contentHeight
                    color: app.c1
                    font.pixelSize: app.fs
                    wrapMode: Text.WordWrap
                    textFormat: Text.RichText
                    Connections{target: unik;onUkStdChanged:taLog.text+=(''+unikLog).replace(/\n/g, '<br />\n')}
                }
            }
        }
        Rectangle{
            id: xEditor
            width: parent.width-xTools.width
            height: parent.height
            color: "#333333"
            visible: app.area===1
            anchors.left: xTools.right
            onVisibleChanged: {
                if(visible){
                    txtEdit.text = unik.getFile(appsDir+'/cfg.json')
                }
            }
            TextEdit{
                id: txtEdit
                width: parent.width*0.98
                height: parent.height/3
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: app.width*0.02
                wrapMode: Text.WordWrap
                Rectangle{
                    anchors.fill: parent
                    z: parent.z-1
                }
            }
            Rectangle{
                width: labelbtn2.contentWidth*1.2
                height: app.width*0.02
                anchors.bottom: parent.bottom
                anchors.bottomMargin: app.width*0.005
                anchors.left: parent.left
                anchors.leftMargin: app.width*0.005
                Text {
                    id:labelbtn2
                    text: "Cancel"
                    font.pixelSize: app.width*0.015
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        app.area=0
                    }
                }
            }

            Rectangle{
                width: labelbtnDelete.contentWidth*1.2
                height: app.width*0.02
                anchors.bottom: parent.bottom
                anchors.bottomMargin: app.width*0.005
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id:labelbtnDelete
                    text: "Delete Config File"
                    font.pixelSize: app.width*0.015
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        var p = appsDir+'/cfg.json'
                        console.log("Config File Deleted: "+p)
                        console.log("Unik have yosoy a default app.")
                        unik.deleteFile(p)
                        app.area=0
                    }
                }
            }

            Rectangle{
                width: labelbtn3.contentWidth*1.2
                height: app.width*0.02
                anchors.bottom: parent.bottom
                anchors.bottomMargin: app.width*0.005
                anchors.right: parent.right
                anchors.rightMargin: app.width*0.005
                Text {
                    id:labelbtn3
                    text: "Set Config"
                    font.pixelSize: app.width*0.015
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        var p = appsDir+'/cfg.json'
                        console.log("Config Path: "+p)
                        console.log("New Config Data: "+txtEdit.text)
                        unik.setFile(p, txtEdit.text)
                        app.area=0

                        //xEditor.visible = false
                    }
                }
            }
        }
    }
    //    Timer{
    //        running: true
    //        repeat: true
    //        interval: 1000
    //        onTriggered: unik.setProperty("logViewVisible", true)
    //    }
    Component.onCompleted: {
        if(Qt.platform.os==='windows'){
            var a1 = Screen.desktopAvailableHeight
            var altoBarra = a1-unik.frameHeight(app)
            app.height = a1-altoBarra
        }
        //console.log(unikError)
        //console.log(unik.stdErr)
        var s=(''+unik.initStdString).replace(/\n/g, '<br />')
        var stdinit='<br /><b>Start Unik Init Message:</b>\u21b4<br />'+s+'<br /><b>End Unik Init Message.</b><br />\n'
        var txt =''
        txt += "<br /> <b>OS: </b>"+Qt.platform.os
        txt += 'Doc location: '+appsDir+'/<br />\n'
        txt += 'user: '+ukuser+'<br />\n'
        if(ukuser==='unik-free'){
            txt += 'key: '+ukkey+'<br />\n'
        }else{
            txt += 'key: '
            var k= (''+ukkey).split('')
            for(var i=0;i<k.length;i++){
                txt += '*'
            }
            txt += '<br />\n'
        }

        txt += "<br /><b>Unik Init Errors: </b><br />"
        var s2=(''+unikError).replace(/\n/g, '<br />')
        txt+=s2
        var e;
        if(unikError!==''){
            txt += '\n<b>Unik Errors:</b>\n'+unikError+'<br />\n'
        }else{
            txt += '\n<b>Unik Errors:</b>none<br>\n'
        }

        txt += 'sourcePath: '+sourcePath+'<br />\n'
        txt += '\n<b>cfg.json:</b>\n'+unik.getFile(appsDir+'/cfg.json')+'<br />\n'

        txt+="<br />"+(''+appStatus).replace(/\n/g, '<br />')

        stdinit+=txt
        taLog.text+=stdinit
    }
}
