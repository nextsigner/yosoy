import QtQuick 2.0
import QtQuick.Controls 2.0
Item {
    id: raiz    
    property alias titulo: tit.text
    property string currentFolder: ''
    property var arrayLangTexts: []
    onVisibleChanged: {
        if(visible){
           setLang()
        }else{

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
            height: parent.height-app.fs
            anchors.centerIn: parent
            spacing: app.fs
            Text {
                id: tit
                font.pixelSize: app.fs
                color: app.c2
                text: arrayLangTexts[5]
            }
            Text {
                id: cf
                font.pixelSize: app.fs*0.5
                color: app.c2
                text: currentFolder
            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: arrayLangTexts[2]+': '
                    font.pixelSize: app.fs
                    color: app.c1
                    anchors.verticalCenter: xTiUser.verticalCenter
                }
                Rectangle{
                    id: xTiUser
                    width: raiz.width*0.8
                    height: app.fs*1.2
                    border.width: 1
                    border.color: app.c1
                    color: 'transparent'
                    radius: app.fs*0.2
                    TextInput{
                        id: tiUser
                        width: parent.width-app.fs*0.5
                        height: app.fs
                        font.pixelSize: app.fs
                        color: app.c1
                        anchors.centerIn: parent
                        text: 'unik-free'                        
                    }
                }
            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: arrayLangTexts[3]+': '
                    font.pixelSize: app.fs
                    color: app.c1
                    anchors.verticalCenter: xTiKey.verticalCenter
                }
                Rectangle{
                    id: xTiKey
                    width: raiz.width*0.8
                    height: app.fs*1.2
                    border.width: 1
                    border.color: app.c1
                    color: 'transparent'
                    radius: app.fs*0.2
                    TextInput{
                        id: tiKey
                        width: parent.width-app.fs*0.5
                        height: app.fs
                        font.pixelSize: app.fs
                        color: app.c1
                        anchors.centerIn: parent
                        text: 'free'
                        echoMode: text==='free'?TextInput.Normal : TextInput.Password
                    }
                }
            }
            Row{
                anchors.right: parent.right
                anchors.rightMargin: app.fs*0.5
                height: app.fs*1.4
                spacing: app.fs*0.5
                Button{
                    height: app.fs*1.4
                    text: arrayLangTexts[4]
                    font.pixelSize: app.fs
                    background: Rectangle{color:app.c2; radius: app.fs*0.3;}
                    onClicked: {
                        tiUser.text='unik-free'
                        tiKey.text='free'
                    }
                    visible: tiUser.text!=='unik-free'||tiKey.text!=='free'
                }
                Button{
                    height: app.fs*1.4
                    text: arrayLangTexts[0]
                    font.pixelSize: app.fs
                    background: Rectangle{color:app.c2; radius: app.fs*0.3;}
                    onClicked: {                        
                        raiz.visible = false
                    }
                }
                Button{//To Upk
                    visible: tiUser.text!==''&&tiKey.text!==''
                    height: app.fs*1.4
                    text: arrayLangTexts[1]
                    font.pixelSize: app.fs
                    background: Rectangle{color:app.c2; radius: app.fs*0.3;}
                    onClicked: {
                        var m0=currentFolder.split('/')
                        var c = unik.mkUpk(currentFolder, m0[m0.length-1], tiUser.text, tiKey.text, appsDir+'')
                        //logView.log('Upk converted: '+c)
                        appSettings.logVisible = true
                        unik.setProperty("logViewVisible", true)
                        raiz.visible = !c
                    }
                }

            }
        }
    }
    Component.onCompleted: setLang()
    function setLang(){
        if(appSettings.languaje==='English'){
                arrayLangTexts = ['Cancel', 'Convert', 'User', 'Key', 'Set to Free','Convert Folder to UPK']
        }else{
                arrayLangTexts = ['Cancelar', 'Convertir', 'Usuario', 'Clave', 'Setear Para Libre', 'Convertir Carpeta a UPK']
        }
    }
}
