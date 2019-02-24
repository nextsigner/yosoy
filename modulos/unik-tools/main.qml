import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import LogView 1.0

ApplicationWindow{
    id: app
    objectName: 'unik-tools'
    visible: true
    //swidth: 500
    //height: 500
    visibility: 'Maximized'
    title: "unik-tools"
    color: Qt.platform.os !=='android' && app.waiting?"transparent":app.c5
    //minimumWidth: 500
    //minimumHeight: 500z

    property int area: 0
    property bool closedModeLaunch: false
    property bool logueado: false
    property string userLogin: ''
    property string keyLog: ''
    //property bool waiting: wait

    //flags: Qt.platform.os !=='android' && app.waiting?Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint:1

    onVisibleChanged: {
        if(!visible&&closedModeLaunch){
            app.close()
        }
    }
    onClosing: {
        Qt.quit()
    }
    onWidthChanged: {
        if(Qt.platform.os==='android'){
            //xApp.rotation = app.width>app.height?0:90
        }else{
            appSettings.appWidth = width
            appSettings.appX = app.x
        }
    }
    onHeightChanged:  {
        if(Qt.platform.os==='android'){
            //xApp.rotation = app.width>app.height?0:90
        }else{
            appSettings.appHeight = height
            appSettings.appY = app.y
        }
    }
    onXChanged: {
        appSettings.appX = app.x
    }
    onYChanged: {
        appSettings.appY = app.y
    }
    onVisibilityChanged: {
        appSettings.appWS = app.visibility
    }

    property int fs: Qt.platform.os !=='android'?app.width*0.02:app.width*0.03
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#000000"

    property string appVigente: appName
    property string appSeleccionada: appName


    Settings{
        id: appSettings
        category: 'conf-unik-tools'
        property string languaje: 'English'
        property int appWidth: 500
        property int appHeight: 500
        property int appX: 0
        property int appY: 0
        property int appWS
        property int pyLineRH1
        property bool logVisible
        property string uGitUrl: 'https://github.com/nextsigner/unik-qml-blogger.git'
        property string uRS
        property string ucs: ''
//        Component.onCompleted: {
//            //unik.setProperty("logViewVisible", appSettings.logVisible)
//            var ukhost1=unik.getHttpFile('https://raw.githubusercontent.com/nextsigner/unik/master/data/unik_host')
//            unik.setHost(ukhost1)
//            console.log('1 Current Unik Host Domain: '+unik.host())
//         }
    }
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Item{
        id: xApp
        anchors.fill: parent
        //visible: !app.waiting
        Column{
            height: app.height
            Rectangle{//Top Tool Bar
                id: xTopBar
                width: app.width
                height: app.fs*1.4
                color: app.c5
                border.color: app.c4
                border.width: 1
                Rectangle{
                    width: app.fs
                    height: app.fs
                    radius: width*0.2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: app.fs
                    color: app.c5

                    Text {
                        id: userLoginIcon
                        text: "\uf2bd"
                        font.pixelSize: app.fs
                        font.family: "FontAwesome"
                        anchors.centerIn: parent
                        color: app.logueado ? app.c1 : "red"

                    }
                    Text {
                        id: userLoginId
                        text: app.userLogin
                        font.pixelSize: app.fs*0.5
                        anchors.left: userLoginIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                        color: app.c1
                        //visible: app.logueado

                    }
                    MouseArea{
                        id: maLogIcon
                        anchors.fill: parent
                        property bool p: false
                        onPressed: {
                            p = true
                            tpresslogout.start()
                        }
                        onReleased: {
                            p = false
                        }
                        onClicked: {
                            p = false
                            if(!app.logueado){
                                ful.visible = true
                            }
                        }
                        Timer{
                            id: tpresslogout
                            running: true
                            repeat: true
                            interval: 1500
                            onTriggered: {
                                if(maLogIcon.p){
                                    app.logueado = false
                                }
                            }
                        }
                    }
                }
                Text {
                    id: tit
                    text: "<b>unik-tools</b>"
                    font.pixelSize: app.fs
                    anchors.centerIn: parent
                    color: app.c1
                }
                Text {
                    id: txtAppVigente
                    text: "<b>Próximo inicio: </b>"+app.appVigente
                    font.pixelSize: app.fs
                    anchors.right: parent.right
                    anchors.rightMargin: app.fs*0.1
                    color: app.c1
                }
            }

            Item{
                id:rowAreas
                width: app.width
                height: app.height-xTopBar.height
                Item{
                    id: xTools
                    width: app.fs*1.5
                    height: parent.height
                    z:logView.z+1

                    Column{
                        id: colTools
                        width: parent.width*0.8
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing:  Qt.platform.os !=='android'?width*0.5:width*0.25
                        anchors.verticalCenter: parent.verticalCenter

                        Boton{//AppList
                            id:btnArea0
                            w:parent.width
                            h: w
                            t: '\uf0ca'
                            d:'Mostrar Lista de Aplicaciones dispobibles para instalar'
                            b:app.area===0?app.c2:app.c1
                            onClicking: {
                                app.area=0
                            }
                        }
//                        Boton{//DepsList
//                            id:btnAreaDeps
//                            w:parent.width
//                            h: w
//                            //f:"FontAwesome5Free"
//                            t: '\uf00a'
//                            d:'Instalar Dependencias'
//                            b:app.area===4?app.c2:app.c1
//                            onClicking: {
//                                app.area=4
//                            }
//                        }
                        Boton{//PageAppList
                            id:btnArea1
                            w:parent.width
                            h: w
                            t: '\uf022'
                            d:'Mostrar Lista de Aplicaciones y Còdigo disponible en el Espacio de Trabajo'
                            b:app.area===1?app.c2:app.c1
                            onClicking: {
                                app.area=1
                            }
                        }
                        Boton{//Help
                            id:btnArea2
                            w:parent.width
                            h: w
                            t: '\uf05a'
                            d:'Informaciòn, Ayuda y Documentaciòn'
                            b:app.area===2?app.c2:app.c1
                            onClicking: {
                                app.area=2
                            }
                        }
                        Boton{//Add git project
                            id:btnAddGit
                            w:parent.width
                            h: w
                            t: '\uf09b'
                            d:'Instalar una aplicaciòn desde una url GitHub.com'
                            b:pal.dgvisible?app.c2:app.c5
                            c:pal.dgvisible?app.c5:app.c2
                            //visible: parseInt(version)>=2.15
                            onClicking: {
                                app.area = 1
                                pal.dgvisible = !pal.dgvisible
                            }
                            Text {
                                text: '+'
                                font.family: "FontAwesome"
                                font.pixelSize: btnAddGit.height*0.3
                                anchors.centerIn: parent
                                color: btnAddGit.c
                            }
                        }
                        Boton{//Actualizar Unik-Tools
                            id:btnUpdate
                            w:parent.width
                            h: w
                            t: '\uf021'
                            d:'Actualizar el còdigo fuente de unik-tools desde GitHub.com'
                            b: up ? 'red':app.c1
                            c: up ? 'white':'#000'
                            property bool up: false
                            onClicking: {
                                if(!up){
                                    if(Qt.platform.os!=='android'){
                                        unik.restartApp("-git=https://github.com/nextsigner/unik-tools.git")
                                    }else{
                                        var gitDownloaded=unik.downloadGit('https://github.com/nextsigner/unik-tools', appsDir+'/unik-tools')
                                        if(gitDownloaded){
                                            var j=appsDir+'/temp_config.json'
                                            var c='{"mode":"-folder", "arg1": "'+appsDir+'/unik-tools'+'"}'
                                            unik.setFile(j, c)
                                            unik.restartApp()
                                        }
                                    }
                                }else{
                                    var args = '-folder '+appsDir+'/unik-tools'
                                    args += ' -dim='+app.width+'x'+app.height+' -pos='+app.x+'x'+app.y
                                    if(Qt.platform.os!=='android'){
                                        unik.restartApp(args)
                                    }else{
                                        gitDownloaded=unik.downloadGit('https://github.com/nextsigner/unik-tools', unik.getPath(3)+'/unik/unik-tools')
                                        if(gitDownloaded){
                                            var j=appsDir+'/temp_config.json'
                                            var c='{"mode":"-folder", "arg1": "'+appsDir+'/unik-tools'+'"}'
                                            unik.setFile(j, c)
                                            unik.restartApp()
                                        }
                                    }
                                }
                            }
                        }
                        Boton{//Show Debug Panel
                            id:btnShowDP
                            w:parent.width
                            h: w
                            t: '\uf188'
                            d:'Ver panel de la salida estandar de esta y otras instancias de unik para depurar errores y conocer eventos'
                            b:appSettings.logVisible?app.c2:'#444'
                            c: appSettings.logVisible?'black':'#ccc'
                            onClicking: {
                                appSettings.logVisible = !appSettings.logVisible
                            }
                        }
                        Boton{//Config
                            w:parent.width
                            h: w
                            t: '\uf013'
                            d:'Configurar unik y unik-tools'
                            b:"#444444"
                            c: app.c1
                            visible: parseFloat(version)>2.12
                            onClicking: {
                                app.area = 3
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
                                font.pixelSize: btnAddGit.height*0.3
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
                AppList{
                    id: appList
                    width: app.width-xTools.width
                    height: parent.height
                    visible: app.area===0
                    anchors.right: parent.right
                }
//                UnikInstallDependencies{
//                    id: unikDepsList
//                    width: app.width-xTools.width
//                    height: parent.height
//                    visible: app.area===4
//                }
                PageAppList{
                    id: pal
                    width: app.width-xTools.width
                    height: parent.height
                    visible: app.area===1
                    anchors.right: parent.right
                }
                Ayuda{
                    id: ayuda
                    width: app.width-xTools.width
                    height: parent.height
                    visible: app.area===2
                    anchors.right: parent.right
                }
                Config{
                    id: config
                    width: app.width-xTools.width
                    height: parent.height
                    visible: app.area===3
                    anchors.right: parent.right
                }
                LogView{
                    id:logView
                    height: appSettings.pyLineRH1
                    width: parent.width-xTools.width
                    topHandlerHeight:4
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    visible: appSettings.logVisible
                    onHeightChanged: appSettings.pyLineRH1=height
                    onYChanged: {
                        //appSettings.pyLineRH1=y
                    }
                }
                DialogoInformar{
                    id:dialogoInformar
                    width: parent.width*0.6
                    //height: parent.height*0.5
                    anchors.centerIn: parent
                    visible: false
                }
            }




        }

        FormUnikLogin{
            id: ful
            visible: false
            width:  parent.width
            height: parent.height
            color: app.c5
        }

    }



    Timer{
        id:timerInit
        running: true
        repeat: true
        interval: 1000
        property int v: 0
        onTriggered: {
            unik.setProperty("logViewVisible", appSettings.logVisible)
            timerInit.v++
            if(timerInit.v>12){
                timerInit.stop()
            }
        }
    }

    Timer{
        id:tu
        running: true
        repeat: false
        interval: 1000*5
        property int v: 0
        onTriggered: {
            tu.v++
            var d = new Date(Date.now())
            unik.setDebugLog(false)
            var ur0 = ''+unik.getHttpFile('https://github.com/nextsigner/unik-tools/commits/master?r='+d.getTime())
            var m0=ur0.split("commit-title")
            var m1=(''+m0[1]).split('</p>')
            var m2=(''+m1[0]).split('\">')
            var m3=(''+m2[2]).split('<')
            var ur = ''+m3[0]
            if(appSettings.uRS===''){
                appSettings.uRS=ur
            }
            //unik.log("Update key control nª"+tu.v+": "+ur+" urs: "+appSettings.uRS)
            if(appSettings.uRS!==ur){
                unik.setDebugLog(true)
                unik.log("Updating unik-tools")
                appSettings.uRS = ur
                var fd=appsDir
                var downloaded = unik.downloadGit('https://github.com/nextsigner/unik-tools', fd)
                appSettings.uRS=''
                tu.stop()
                if(downloaded){
                    btnUpdate.up=true
                }else{
                    tu.start()
                }
            }else{
                //appSettings.uRS=ur
            }
            unik.setDebugLog(true)
            tu.interval=1000*60*5
            tu.repeat=true
            tu.start()
        }
    }

    Component.onCompleted: {
        //unik.setProperty("logViewVisible", appSettings.logVisible)
        var ukhost1=unik.getHttpFile('https://raw.githubusercontent.com/nextsigner/unik/master/data/unik_host')
        unik.setHost(ukhost1)
        console.log('Current Unik Host Domain: '+unik.host())
        if(appSettings.pyLineRH1===0||appSettings.pyLineRH1===undefined){
            appSettings.pyLineRH1 = 100
        }
        logView.height=appSettings.pyLineRH1
        if(Qt.platform.os==='windows'||Qt.platform.os==='linux'||Qt.platform.os==='osx'){
            app.visibility = appSettings.appWS
            if(appSettings.appWS===2){
                app.x = appSettings.appX
                app.y = appSettings.appY
                app.width = appSettings.appWidth
                app.height = appSettings.appHeight
            }
        }else{
            app.visibility = "FullScreen"
        }
        ful.init()
        unik.log('unik-tools log')
        unik.log('unik version: '+version+'')
        unik.log('unik-tools host:  '+host+'')
        unik.log('Unik Tools AppName: '+appName)
        //unik.log(app.contentData)
        appList.act()
    }


}
