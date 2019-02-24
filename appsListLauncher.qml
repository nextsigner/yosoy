import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
ApplicationWindow {
    id: appListLaucher
    objectName: 'awll'
    visibility:  "Maximized"
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    property int fs: width<height?(Qt.platform.os !=='android'?appListLaucher.width*0.02:appListLaucher.width*0.06):(Qt.platform.os !=='android'?appListLaucher.width*0.02:appListLaucher.width*0.03)
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"

    property bool prima: false
    property int sec: 0
    property int ci: 0
    property var al: []
    property string ca: ''

    onClosing: {
        if(Qt.platform.os==='android'){
            //close.accepted = false;
        }
    }
    onCiChanged: appListLaucher.ca=appListLaucher.al[appListLaucher.ci]
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Settings{
        id: appSettings
        category: 'conf-appsListLauncher'
        property string uApp
    }
    FolderListModel{
        folder: Qt.platform.os!=='windows'?'file://'+appsDir:'/'+appsDir
        id:fl
        showDirs:  false
        showDotAndDotDot: false
        showHidden: false
        showOnlyReadable: true
        sortField: FolderListModel.Name
        nameFilters: "*.ukl"
        property int f: 0
        onCountChanged: {
            console.log('File: '+fl.get(f,"fileName"))
            f++
        }
    }
    Rectangle{
        id:r
        width: appListLaucher.width-appListLaucher.fs
        height:parent.height
        color: 'transparent'
        anchors.centerIn: parent
        focus: true
        Keys.onReturnPressed: {
            run()
        }
        Rectangle{
            id:xP
            visible: false
             width:parent.width*0.33
             height: appListLaucher.fs*0.125
             color: appListLaucher.c2
             anchors.horizontalCenter: parent.horizontalCenter
             anchors.verticalCenter: parent.verticalCenter
             anchors.verticalCenterOffset: appListLaucher.fs*2+appListLaucher.fs*0.125
             Rectangle{
                 id:psec
                 width: 1
                 height: parent.height
                 color: 'red'
             }
        }

        Flickable{
           id:flick
           width: appListLaucher.width
           height: appListLaucher.height
           contentHeight: lv.height
           opacity:0.0
           Behavior on opacity{NumberAnimation{duration: 500}}
           Behavior on contentY{NumberAnimation{duration: 500}}
           ListView{
            id:lv
            spacing: appListLaucher.fs*0.25
            model:fl
            delegate: delegate
            width: appListLaucher.width-appListLaucher.fs*2
            height: (appListLaucher.fs*2+appListLaucher.fs*0.25)*lv.count
            anchors.horizontalCenter: parent.horizontalCenter
            onCurrentIndexChanged: {
                console.log('UCurrentIndex: '+currentIndex)
                flick.contentY=(appListLaucher.fs*2+appListLaucher.fs*0.25)*currentIndex-appListLaucher.height/2
            }
        }
    }
        Component{
            id:delegate
            Rectangle{
                id:xItem
                width: txt.contentWidth+appListLaucher.fs*2
                height: appListLaucher.fs*2
                color: xItem.border.width!==0?appListLaucher.c4:appListLaucher.c2
                radius: appListLaucher.fs*0.25
                border.width: fileName===appListLaucher.ca?2:0
                border.color: fileName===appListLaucher.ca?appListLaucher.c2:appListLaucher.c4
                anchors.horizontalCenter: parent.horizontalCenter
                visible:(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0
                onColorChanged: {
                    if(xItem.border.width!==0){
                        appListLaucher.ca=appListLaucher.al[index]
                        lv.currentIndex=index
                    }
                }//lv.currentIndex=index

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        appListLaucher.ci=index
                        appListLaucher.ca=fileName
                         flick.contentY=(appListLaucher.fs*2+appListLaucher.fs*0.25)*index-appListLaucher.height/2

                        if(tlaunch.running){
                            tlaunch.stop()
                            appListLaucher.sec=0
                            psec.width=0
                        }else{
                            tlaunch.start()
                        }
                    }
                    onDoubleClicked: {
                        /*var p=unik.getFile(appsDir+'/'+fileName)
                        unik.ejecutarLineaDeComandoAparte('"'+appExec+'" -cfg '+p)
                        appListLaucher.close()*/
                        appListLaucher.ci=index
                        appListLaucher.ca=fileName
                         flick.contentY=(appListLaucher.fs*2+appListLaucher.fs*0.25)*index-appListLaucher.height/2
                        run()
                    }
                }
                Text {
                    id: txt
                    text: (''+fileName).substring(5, (''+fileName).length-4)
                    font.pixelSize: appListLaucher.fs
                    color:xItem.border.width!==0?appListLaucher.c2:appListLaucher.c4
                    anchors.centerIn: parent
                }
                Component.onCompleted: {
                    appListLaucher.al.push(fileName)
                    if((''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.json')>0&&!appListLaucher.prima){
                        appListLaucher.ca=appListLaucher.al[index]
                        appListLaucher.prima=true
                        tap.color='black'
                        xP.visible=true
                    }
                    if( tlaunch.enabled){
                        tinit.restart()
                    }
                }
                Text {
                    text: '\uf061'
                    font.family: "FontAwesome"
                    font.pixelSize: appListLaucher.fs
                    color:appListLaucher.c2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.left
                    anchors.rightMargin: appListLaucher.fs*0.5
                    visible: xItem.border.width!==0
                }
            }
        }

       }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(appListLaucher.ci<appListLaucher.al.length-1){
                appListLaucher.ci++
            }else{
                appListLaucher.ci=0
            }
            tlaunch.stop()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(appListLaucher.ci>0){
                appListLaucher.ci--
            }else{
                appListLaucher.ci=appListLaucher.al.length-1
            }
            tlaunch.stop()
        }
    }
    Rectangle{
        id:tap
        anchors.fill: parent
        color: 'transparent'
        opacity:0.0
        Behavior on opacity{NumberAnimation{duration:500}
        }
    }
    Timer{
        id: tinit
        running: true
        repeat: false
        interval: 1000
        onTriggered: {
            tap.opacity=0.0
            if(appSettings.uApp===''&&appListLaucher.al.length>0){
                appSettings.uApp=appListLaucher.al[0]
            }
            var vacio=true
            for(var i=0;i<appListLaucher.al.length;i++){
                if((''+appListLaucher.al[i]).indexOf('.ukl')>0){
                    //appListLaucher.visible=true
                    vacio=false
                }
                if(appSettings.uApp===appListLaucher.al[i]){
                    appListLaucher.ca=appListLaucher.al[i]
                }
            }
            if(vacio){
                tlaunch.enabled=false
                tlaunch.stop()
                appListLaucher.close()
                engine.load(appsDir+'/yosoy/main.qml')
            }else{
                xP.visible=true
            }

            flick.opacity=1.0
        }

    }
    Timer{
        id: tlaunch
        running: true
        repeat: true
        interval: 1000
        property bool enabled: true
        onTriggered: {
            appListLaucher.sec++
            if(appListLaucher.sec===7){
                run()
            }
            psec.width=psec.parent.width/5*(appListLaucher.sec-1)

        }
    }
    function run(){
        /*var urlGit=(''+unik.getFile(pws+'/'+appListLaucher.ca)).replace(/\n/g, '')
        var params=urlGit
        var m0=urlGit.split('/')
        var s1=(''+m0[m0.length-1]).replace('.git', '')
        var uklFileLocation=pws+'/link_'+s1+'.ukl'
        var uklData=''+urlGit
        uklData+=' -folder='+pws+'/'+s1
        unik.setFile(uklFileLocation, uklData)
        params+=', -folder='+pws+'/'+s1
        params+=', -dir='+pws+'/'+s1
        unik.setUnikStartSettings(params)
        unik.restartApp()
        */
        //return
        appSettings.uApp=appListLaucher.ca
        var p=unik.getFile(appsDir+'/'+appListLaucher.ca)
        var args=(''+p).split(' ')
        var params=''
        for(var i=0; i<args.length;i++){
            if(i===0){
                params+=args[i]
            }else{
                params+=','+args[i]
            }
        }
        unik.setUnikStartSettings(params)
        console.log('New USS params: '+params)
        if(Qt.platform.os==='android'){
            unik.restartApp()
        }else{
            unik.restartApp("")
        }
        //appListLaucher.close()
    }    
}



