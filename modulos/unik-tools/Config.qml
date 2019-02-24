import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
Rectangle {
    id: raiz
    width: parent.width
    height: parent.height
    color: app.c5
    property string prevPathWS:appsDir

        ColumnLayout{
            id:col
            width: parent.width-app.fs
            anchors.horizontalCenter: raiz.horizontalCenter
            spacing: app.fs
            Rectangle{
                id: tb
                Layout.fillWidth: true
                Layout.preferredHeight: app.fs*1.4
                color: app.c1
                Text {
                    id: txtTit
                    text: 'unik-configuration'
                    font.pixelSize: app.fs
                    color: app.c4
                    anchors.centerIn: parent
                }
            }
            RowLayout{
                spacing: app.fs*0.5
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: app.fs*1.2
                Text {
                    id: labelWS
                    text: 'Espacio de Trabajo:'
                    font.pixelSize: app.fs
                    color: app.c1
                }
                Rectangle{
                    id: xTiWS
                    //width: raiz.width-labelWS.contentWidth-botAplicarWS.width-app.fs*2
                    Layout.fillWidth: true
                    Layout.preferredHeight:  app.fs*1.2
                    color: "#333"
                    border.color: app.c2
                    radius: app.fs*0.1
                    clip: true
                    TextInput{
                        id: tiWS
                        width: parent.width*0.98
                        height: app.fs
                        font.pixelSize: app.fs
                        text: appsDir
                        anchors.centerIn: parent
                        Keys.onReturnPressed: {
                                        preSetWS(tiWS.text)
                        }
                        onTextChanged: {
                            preSetWS(tiWS.text)
                        }                        
                    }
                    Rectangle{
                        id: xMsgAplicado
                        width: parent.width
                        height:  parent.height
                        color: app.c2
                        border.color: app.c2
                        radius: app.fs*0.1
                        clip: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        opacity: 0.0
                        property bool apar: true
                        Behavior on opacity{
                            NumberAnimation{
                                id:dur
                                duration: 1000
                            }
                        }
                        Text{
                            id: msg
                            width: parent.width*0.98
                            height: app.fs
                            font.pixelSize: app.fs*0.8
                            text: 'Se ha aplicado el nuevo Espacio de Trabajo'
                            color: app.c5
                            anchors.centerIn: parent
                        }
                        Timer{
                            id:tmsg1
                            running: false
                            repeat: false
                            interval: 3000
                            onTriggered:  {dur.duration=1000; xMsgAplicado.opacity=0.0}
                        }
                    }
                }

                Boton{
                    Layout.preferredWidth:  app.fs*1.2
                    Layout.preferredHeight: app.fs*1.2
                    b:app.c2
                    c: "#333"
                    t: "..."
                    d: 'Seleccionar Carpeta para Espacio de Trabajo'
                    tp:1
                    onClicking: fileDialog.visible=true
                }
                Boton{
                    Layout.preferredWidth:  app.fs*1.2
                    Layout.preferredHeight: app.fs*1.2
                    b:app.c2
                    c: "#333"
                    t: "\uf0e2"
                    d: 'Deshacer cambios'
                    tp:1
                    onClicking: tiWS.text=raiz.prevPathWS
                }
                Boton{
                    Layout.preferredWidth:  app.fs*1.2
                    Layout.preferredHeight: app.fs*1.2
                    b:app.c2
                    c: "#333"
                    t: "\uf00c"
                    d: 'Utilizar este Espacio de Trabajo'
                    tp:1
                    enabled: tiWS.color===app.c1?true:false
                    opacity: enabled?1.0:0.5
                    onClicking: setWS(tiWS.text)
                }
            }
        }        
        FileDialog {
            id: fileDialog
            visible: false
            //modality: true ? Qt.WindowModal : Qt.NonModal
            title: 'Select New Work Space'
            selectExisting: true
            folder: shortcuts.home
            //folder: 'file:///'+appSettings.ucs
            selectMultiple: false
            selectFolder: true
            //nameFilters: [ "Archivo de texto (*.txt)", "Todos los archivos (*)" ]
            selectedNameFilter: "Todos los archivos (*)"
            sidebarVisible: true
            onAccepted: {
               fileDialog.visible=false

                var f=''
                if(Qt.platform.os==='windows'){
                    f=(''+fileUrls[0]).replace('file:///','')
                }else{
                    f=(''+fileUrls[0]).replace('file://','')
                }
                appSettings.ucs = fileUrls[0]
                tiWS.text=f
            }
            onRejected: { console.log("Rejected") }
        }
        Component.onCompleted: {
            fileDialog.folder = appSettings.ucs
        }

        function setWS(ws){
            if(unik.fileExist(ws)||unik.mkdir(ws)){
                unik.setWorkSpace(ws)
                dur.duration=1
                xMsgAplicado.opacity=1.0
                tmsg1.start()
                unik.log('New WorkSpace seted: '+ws)
            }
            tiWS.color = unik.fileExist(ws)?app.c1:"red"
        }
        function preSetWS(ws){
            //unik.mkdir(ws)
            tiWS.color = unik.fileExist(ws)?app.c1:"red"
        }
}
