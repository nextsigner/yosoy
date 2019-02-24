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
import QtMultimedia 5.9
//import QtQuick.Templates 2.2
import QtWebView 1.1
import uk 1.0
//import "file://home/qt/des/chex/src/" as Mm

/*
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Particles 2.0
import QtQuick.Window 2.3
import QtQuick.XmlListModel 2.0
import QtQuick.Controls.Styles 1.4
import QtWebView 1.1
import oc 1.0
import QtGraphicalEffects 1.0
*/

ApplicationWindow {
    id: app
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    title: qsTr("uniK-status")
    property int fs: app.width*0.025
    UK{id:uk}
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Rectangle{
        anchors.fill: parent
        color: "#333"
        Flickable{
            id:flick
            width: parent.width
            height: parent.height
            contentWidth: parent.width
            contentHeight: txtEstado.contentHeight
            Text {
                id: txtEstado
                width: parent.width*0.96
                height: contentHeight
                wrapMode: Text.WordWrap
                //text: "<b>"+unikError+"</b>"
                font.pixelSize: parent.width*0.015
                color: "white"
                anchors.centerIn: parent

            }
        }

        Row{
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            height: app.fs*2
            spacing: app.fs*2

            Rectangle{
                width: labelbtn1.contentWidth*1.2
                height: app.width*0.02
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id:labelbtn1
                    text: "Edit Config"
                    font.pixelSize: app.width*0.015
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        xEditor.visible = true
                    }
                }
            }

            Rectangle{
                width: labelbtnDelete.contentWidth*1.2
                height: app.width*0.02
               anchors.verticalCenter: parent.verticalCenter
                Text {
                    id:labelbtnDelete
                    text: "Delete Config"
                    font.pixelSize: app.width*0.015
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        unik.deleteFile(appsDir+'/cfg.json')
                        unik.restartApp()
                    }
                }
            }

            Rectangle{
                width: app.fs*2
                height: width
                Text {
                    text: "UT"
                    font.pixelSize: parent.width*0.4
                    font.family: 'FontAwesome'
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        var p=''+appsDir+'/cfg.json'
                        var c = '{"arg0":"-folder='+appsDir+'/yosoy'+'"}'
                        unik.setFile(p, c)
                        unik.restartApp()
                    }
                }
            }
            Rectangle{
                width: app.fs*2
                height: width
                Text {
                    text: "X"
                    font.pixelSize: parent.width*0.8
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        Qt.quit()
                    }
                }
            }


        }
        Rectangle{
            id: xEditor
            width: parent.width
            height: parent.height
            color: "#333333"
            visible: false
            onVisibleChanged: {
                if(visible){
                    txtEdit.text = uk.getFile(appsDir+'/cfg.json')
                }
            }
            TextEdit{
                id: txtEdit
                width: parent.width*0.98
                height: parent.height/3
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: app.width*0.02
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
                        xEditor.visible = false
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
                        uk.setFile(p, txtEdit.text)
                        xEditor.visible = false
                    }
                }
            }

        }


        /*Boton{//Launch yosoy
            id:btnLaunchUT
            w:app.fs
            h: w
            t: 'UT'
            b:app.area===0?app.c2:app.c1
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            //f: 'FontAwesome'
            onClicking: {
                unik.restartApp()
            }
        }*/

    }


    Component.onCompleted: {
        console.log("OS: "+Qt.platform.os)
        console.log("Error: "+unikError)
        var txt =''
        txt += 'unik version: '+version+'\n'
        txt += 'AppName: '+appName+'\n'
        var e;
        if(unikError!==''){
            txt += '\nErrors:\n'+unikError+'\n'
        }else{
            txt += '\nErrors: none\n'
        }
        //txt += '\nErrors:\n'+unikError+'\n'
        txt += 'Doc location: '+appsDir+'\n'
        txt += 'host: '+host+'\n'
        txt += 'user: '+ukuser+'\n'
        txt += 'key: '+ukkey+'\n'
        txt += 'sourcePath: '+sourcePath+'\n'
        txt += '\ncfg.json:\n'+uk.getFile(appsDir+'/cfg.json')+'\n'

        //txt += '\nuserhost: ['+userhost+']\n'

        txtEstado.text = txt
        console.log(txt)

    }
}
