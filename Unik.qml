import QtQuick 2.0
import Qt.labs.settings 1.0


Rectangle {
    id:app
    objectName: 'unik-launch'
    anchors.fill: parent
    //width: parent.width
    //height: parent.height
    visible: false
    onVisibleChanged: {
        if(visible){
            lineRH.y=appSettingsUnik.pyLineRH1
        }
        appSettingsUnik.logVisible = visible
    }    
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Connections {target: unik;onUkStdChanged: logView.log(unik.ukStd);}
    Connections {target: unik;onStdErrChanged: logView.log(unik.getStdErr());}

    //width:  unik.mainWindow(1).width
    //height: width
    //anchors.centerIn: parent
    color: 'transparent'
    //visible: unikLaunchVisible
    //color: "red"

    property int fs: Qt.platform.os !=='android'?app.width*0.02:app.width*0.03
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"
    property bool enUnikTools: false
    property bool logViewMostrado: false


    Settings{
        id: appSettingsUnik
        category: 'conf-unik-launch-'+appName
        property string languaje: 'English'
        property int pyLineRH1: 100
        property int upyLineRH1
        property bool logVisible
        property int lvfs
        onLvfsChanged: logView.log('')

    }
    Rectangle{
        id:xLaunch
        width: parent.width
        height: parent.height*0.05
        //anchors.bottom: parent.bottom
        y:app.height-height
        color: app.c2
        opacity:0.0
        Behavior on opacity{
            NumberAnimation{
                duration: 250
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            drag.target: xLaunch
            drag.axis: Drag.YAxis
            drag.minimumY: app.height-100
            drag.maximumX: app.height
            onEntered: {
                xLaunch.opacity=1.0
            }
            onExited: {
                xLaunch.opacity=0.0
            }
            onReleased: {
                if(xLaunch.y<app.height){
                    xLaunch.y=app.height-xLaunch.height
                    lineRH.visible=true
                    logView.visible=true
                    //unik.log('Mostrando LowView en la altura: '+appSettingsUnik.pyLineRH1)

                    var npy=appSettingsUnik.upyLineRH1
                    if(npy>app.height-app.fs){
                        npy = app.height-100
                        appSettingsUnik.upyLineRH1=npy
                    }

                    if(!logViewMostrado){
                        lineRH.y=npy
                        logViewMostrado=true
                    }else{
                        lineRH.y=npy
                    }
                }
            }
            /*onClicked: {
                app.visible=false
            }*/
        }
    }



    LineResizeH{
        id:lineRH;
        //y:visible?appSettingsUnik.pyLineRH1: parent.height;
        onLineReleased: {
            //console.log("Soltando lineH en: "+y)
            if(y<app.height){
                //console.log("Soltando lineH en2: "+y)
                logView.visible=true
                appSettingsUnik.pyLineRH1 = y;
                appSettingsUnik.upyLineRH1 = y;

            }else{
                //console.log("Soltando lineH en3: "+y)
            }

        }
        property int uy
        //visible: false
        //visible: appSettingsUnik.logVisible;
        /*onYChanged: wv.height = !lineRH.visible ? wv.parent.height-(wv.parent.height-lineRH.y) : wv.parent.height*/
        y:appSettingsUnik.pyLineRH1
        height: appSettingsUnik.lvfs*2

        onYChanged: {
            if(y<app.height/6){
                y=app.height/6+2
            }
            if(y>app.height-height){
                visible=false
                logView.visible=false
            }
            if(y<uy){
                visible=true
            }
            if(y<1){
                y=10
            }
            uy=y
        }
        Behavior on y{
            NumberAnimation{
                duration: 250
            }
        }
        Component.onCompleted: {
            if(lineRH.y<app.height/6){
                lineRH.y=app.height/6+2
            }
        }
    }
    LogView{
        id:logView;
        width: app.width
        anchors.top: lineRH.bottom;
        anchors.bottom: parent.bottom;
        visible: lineRH.visible

    }
    Timer{
        id:tv
        running: true
        repeat: true
        interval: 250
        onTriggered: {

            var bant= app.visible;
            var v = unik.getProperty("logViewVisible")

            /*var mw1=''+unik.mainWindow(0).objectName
            if(mw1==='unik-tools'){
                console.log('Ver logview: '+v)
                console.log('Ver logview app: '+app.width+"x"+app.height)        app.enUnikTools=true
            }*/

            //console.log('Ver logview 0: '+unik.mainWindow(0).width)
            //console.log('Ver logview 1: '+unik.mainWindow(1).width)

            app.visible = v!==undefined?unik.getProperty("logViewVisible"):false
            if(bant!==app.visible&&app.visible){
                if(lineRH.y<=app.height){
                    lineRH.y=appSettingsUnik.upyLineRH1
                    lineRH.visible=true

                }else{
                    lineRH.y=appSettingsUnik.upyLineRH1
                }
                logView.visible=true
            }
            if(unik.mainWindow(1).logView){
                unik.mainWindow(1).logView=app
            }
            //app.visible = v!==undefined?v:false
        }
    }
    Component.onCompleted: {
        if(appSettingsUnik.pyLineRH1<10){
            appSettingsUnik.pyLineRH1 = 100
        }
        if(appSettingsUnik.upyLineRH1===0){
            appSettingsUnik.upyLineRH1 = app.height-100
        }
        unik.setProperty("logViewVisible", appSettingsUnik.logVisible)
        if(appSettingsUnik.logVisible){
            lineRH.visible=true
            logView.visible=true
            if(lineRH.y<=app.height){
                lineRH.y=app.height-100
            }else{
                lineRH.y=appSettingsUnik.pyLineRH1
            }
        }
        if(appSettingsUnik.lvfs<=1){
            appSettingsUnik.lvfs = 14
        }



        //unik.log('mainwindow 0: '+unik.mainWindow(0).objectName)
        var mw1=''+unik.mainWindow(1).objectName
        //unik.log('mainwindow 1: '+mw1)
        //unik.log('mainwindow 2: '+unik.mainWindow(2).objectName)

        if(appSettingsUnik.lvfs===undefined||appSettingsUnik.lvfs<=0){
            appSettingsUnik.lvfs=parseInt(unik.mainWindow(1).width*0.03)
            //console.log("LVFS 1: "+appSettingsUnik.lvfs+" "+unik.mainWindow(1).width*0.03)
        }else{
            //console.log("LVFS: "+appSettingsUnik.lvfs+" "+unik.mainWindow(1).width*0.03)
        }
        if(mw1==='unik-tools'){
                app.enUnikTools=true
        }
        if(mw1!=='awsplash'){
            unik.log('Modulo LogView disponible.')
            unik.log('Para ver la Salida Estàndar de esta aplicaciòn ejecuta en tu QML el comando unik.setProperty("logViewVisible", true)')
            unik.log('Luego desliza o arrastra el mouse o touch en la parte inferior de la pantalla.')
        }
        unik.setProperty("logViewVisible", false)



    }
}
