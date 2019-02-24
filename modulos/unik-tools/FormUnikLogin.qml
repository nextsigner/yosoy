import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0


Rectangle{
    id: raiz
    color: 'transparent'
    signal loginEvent(bool l)
    ColumnLayout{
        id: col1
        anchors.centerIn: parent
        Layout.preferredWidth: app.width*0.8
        Layout.preferredHeight: parent.height*0.5
        Layout.fillHeight: true
        Layout.fillWidth: true
        spacing: app.fs


        RowLayout{
            id: row1
            Layout.fillWidth: true
            Layout.preferredWidth:app.width*0.8
            Layout.preferredHeight: app.fs
            spacing: app.fs
            Text {
                id: txtSetUser
                font.pixelSize: app.fs
                color: app.c1
                text: '<b>Usuario o Correo:</b>'
                clip: true
            }
            Rectangle{
                id:xtiSetUser
                Layout.minimumWidth: app.width*0.8-txtSetUser.width-app.fs                    //Layout.maximumWidth: (parent.parent.parent.width-txtSetUser.width-app.fs)*0.6
                Layout.minimumHeight: app.fs*1.6
                Layout.maximumHeight: app.fs*1.6
                anchors.verticalCenter: txtSetUser.verticalCenter
                border.width: 1
                border.color: app.c1
                radius: height*0.3
                clip: true
                color: app.c2
                TextInput{
                    id: tiSetUser
                    font.pixelSize: app.fs
                    width: parent.width*0.99
                    height: app.fs
                    anchors.centerIn: parent
                    maximumLength: 60
                    KeyNavigation.tab: tiSetKey
                }

            }
        }


        RowLayout{
            id: row3
            Layout.fillWidth: true
            Layout.preferredWidth:app.width*0.8
            Layout.preferredHeight: app.fs
            spacing: app.fs
            Text {
                id: txtSetKey
                font.pixelSize: app.fs
                color: app.c1
                text: '<b>Clave:</b>'
                clip: true
            }
            Rectangle{
                id:xtiSetKey
                Layout.minimumWidth: app.width*0.8-txtSetKey.width-app.fs                    //Layout.maximumWidth: (parent.parent.parent.width-txtSetUser.width-app.fs)*0.6
                Layout.minimumHeight: app.fs*1.6
                Layout.maximumHeight: app.fs*1.6
                anchors.verticalCenter: txtSetKey.verticalCenter
                border.width: 1
                border.color: app.c1
                color: app.c2
                radius: height*0.3
                clip: true
                TextInput{
                    id: tiSetKey
                    font.pixelSize: app.fs
                    width: parent.width*0.99
                    height: app.fs
                    anchors.centerIn: parent
                    maximumLength: 60
                    echoMode: TextInput.Password
                    KeyNavigation.tab: botCancelar
                }
            }
        }
        RowLayout{
            Layout.fillWidth: true
            Layout.preferredWidth: app.width*0.8
            Layout.minimumHeight:  app.fs
            spacing: 0
            CheckBox{
                id: recordarme
                width: app.fs
                height: app.fs
            }

            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: app.fs
            }
            Button{
                id: botCancelar
                Layout.preferredWidth: app.fs*6
                Layout.preferredHeight: 50
                font.pixelSize: app.fs*0.8
                background: Rectangle{color:parent.p ? app.c1 : app.c2;}
                text: p ? '<b>Cancelar</b>' : 'Cancelar'
                property bool p: false
                onPressed: {
                    p = true
                }
                onReleased: {
                    p = false
                }
                onClicked: {
                    app.logueado = false
                    raiz.visible = false
                }
                KeyNavigation.tab: botAceptar
                Keys.onReturnPressed: {
                    app.logueado = false
                    raiz.visible = false
                }
            }
            Item{
                Layout.fillWidth: true
                Layout.maximumWidth: app.fs
                Layout.preferredHeight: app.fs
            }
            Button{
                id: botAceptar
                Layout.preferredWidth: app.fs*6
                Layout.preferredHeight: 50
                font.pixelSize: app.fs*0.8
                background: Rectangle{color:parent.p ? app.c1 : app.c2;}
                text: p ? '<b>Login</b>' : 'Login'
                property bool p: false
                onPressed: {
                    p = true
                }
                onReleased: {
                    p = false
                }
                onClicked: {
                    loguin(tiSetUser.text, tiSetKey.text, true)
                }
                KeyNavigation.tab: tiSetUser
                Keys.onReturnPressed: {
                    loguin(tiSetUser.text, tiSetKey.text, true)
                }

            }
        }
    }

    function loguin(u, k, reset){
        if(u!==''){
            var passFile = unik.getPath(4)+'/pass'
            var url =  host+'/modulos/login.php?email='+u+'&clave='+k
            var ret = parseInt(unik.getHttpFile(url))
            //console.log("Url Login: "+url)
            //console.log("Ret: "+ret)
            if(ret===-1){
                app.userLogin = ""
                //console.log('Usuario no existente')
                unik.log('Login não é bem sucedido! / Login no se ha producido con èxito! / Login is not successful!')
                unik.log('Login
devido a falha em nome de usuário e senha / Login falla por error en usuario y clave incorrectas / Login fail in user and password data.')
            }else if(ret>0){
                //console.log('Logueado!')
                unik.log('Login é bem sucedido! / Login se ha producido con èxito! / Login is successful!')
                app.logueado = true
                raiz.visible = false
                app.userLogin = u
                if(recordarme.checked){
                    var passEnc = unik.encData(u+','+k, 'au', 'ak')
                    unik.setFile(passFile, passEnc)
                }else{
                    if(reset){
                        unik.setFile(passFile, '')
                    }
                }
            }else if(ret===-2){
                app.userLogin = ""
                console.log('Error de clave de acceso')
                unik.log('Login não é bem sucedido! / Login no se ha producido con èxito! / Login is not successful!')

            }else{
                app.userLogin = ""
                console.log('Error al loguear: Estado desconocido')
                unik.log('Login não é bem sucedido! / Login no se ha producido con èxito! / Login is not successful!')
                unik.log('Login
devido a falha em nome de usuário e senha / Login falla por error en usuario y clave incorrectas / Login fail in user and password data.')
            }
        }
    }
    function init() {
        var passFile = unik.getPath(4)+'/pass'
        var dataPass = unik.decData(unik.getFile(passFile), 'au', 'ak')
        //console.log('DecPass: '+
        if(dataPass!==''){
            var m0 = (''+dataPass).split(',')
            loguin(m0[0], m0[1], false)
        }else{
             //unik.log('unik-tools não é login / unik-tools no està logueado / unik-tools is not login')
        }
    }
}

