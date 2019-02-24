import QtQuick 2.0
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.2
Item {
    id: raiz
    //anchors.fill: parent
    property alias flm: folderListModelApps
    property alias dgvisible: xAddGit.visible
    Rectangle{
        id: tb
        width: raiz.width
        height: app.fs*1.4
        color: app.c1
        Text {
            id: txtTit
            text: '<b>WorkSpace:</b> '+appsDir
            font.pixelSize: app.fs
            color: app.c4
            anchors.centerIn: parent
        }
    }


    ListView{
        id: listApps
        width: raiz.width-app.fs*3
        //height: raiz.height-tb.height
        anchors.top: tb.bottom
        anchors.bottom: parent.bottom
        anchors.right: raiz.right
        //anchors.horizontalCenter: raiz.horizontalCenter
        model: folderListModelApps
        delegate: delListApp
        clip: true
        spacing: app.fs*0.2
    }
    FolderListModel{
        id: folderListModelApps
        folder: Qt.platform.os!=='windows'?appsDir:'file:///'+appsDir
        nameFilters: ["*.upk"]
    }

    Component{
        id: delListApp
        Rectangle{
            id: xItem
            width: listApps.width
            height: app.fs*1.6
            color: app.c2
            border.width: 1
            radius: height*0.1
            Text {
                id: txtFileName
                text: fileName
                font.pixelSize: app.fs
                anchors.centerIn: parent
            }
            Row{
                height: xItem.height*0.8
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: xItem.height*0.2
                spacing: app.fs*0.5



                Button{//Convertir a UPK
                    id: btnToUpk
                    width: parent.height
                    height: width
                    text: ''
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    //opacity: app.appVigente+'.upk'!==fileName ? 1.0 : 0.0
                    background: Rectangle{color: app.appVigente+'.upk'===fileName ? app.c2 : app.c1; radius: app.fs*0.3;}
                    Text {
                        text: '<b>To</b><br /><b>UPK</b>'
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: parent.height*0.4
                    }
                    onClicked: {
                        var path = appsDir+'/'+fileName
                        toUpkDialog.currentFolder = path
                        toUpkDialog.visible = true
                    }
                    Component.onCompleted: {
                        var path = appsDir+'/'+fileName+'/main.qml'
                        btnToUpk.visible = folderListModelApps.isFolder(index)&&unik.fileExist(path)
                    }
                }

                Button{//Crear LNK
                    id: btnToLnk
                    width: parent.height
                    height: width
                    text: '\uf08e'
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    //opacity: app.appVigente+'.upk'!==fileName ? 1.0 : 0.0
                    background: Rectangle{color: app.c1; radius: app.fs*0.3;}
                    onClicked: {
                        //Creating Desktop LNK
                        var exec
                        var ad = ''
                        var created=false
                        if(folderListModelApps.isFolder(index)){
                            if(Qt.platform.os==='linux'){
                                ad = ''+unik.getPath(6)+'/'+fileName+'.desktop'
                                if(!unik.fileExist(ad)){
                                    exec = ''+unik.getPath(1)+'/unik -folder '+appsDir+'/'+fileName
                                    console.log('Unik Qml Blogger Exec Path: '+exec)
                                    created = unik.createLink(exec, ad, ''+fileName+'', 'This is a desktop file created by unik-tools')
                                    }
                            }
                            if(Qt.platform.os==='windows'){
                                ad = ''+unik.getPath(6)+'/'+fileName+'.lnk'
                                if(!unik.fileExist(ad)){
                                    exec = ''+unik.getPath(1)+'/unik.exe'
                                    var arguments = ' -folder '+appsDir+'/'+fileName
                                    created = unik.createLink(exec, arguments, ad, 'This is a desktop file created by unik-tools', 'E:/')
                                }
                            }
                            dialogoInformar.info='Se ha creado el acceso directo\nen '+ad
                        }else{
                            var s0=''+fileName
                            var s1= s0.substring(s0.length-4, s0.length);
                            var s2=s0.replace('.upk', '')
                            if(s1==='.upk'){
                                if(Qt.platform.os==='linux'){
                                    ad = ''+unik.getPath(6)+'/'+s2+'.desktop'
                                    if(!unik.fileExist(ad)){
                                        exec = ''+unik.getPath(1)+'/unik  '+appsDir+'/'+fileName
                                        console.log('Unik Qml Blogger Exec Path: '+exec)
                                        created = unik.createLink(exec, ad, ''+fileName+'', 'This is a desktop file created by unik-tools')
                                    }
                                }
                                if(Qt.platform.os==='windows'){
                                    ad = ''+unik.getPath(6)+'/'+s2+'.lnk'
                                    if(!unik.fileExist(ad)){
                                        exec = ''+unik.getPath(1)+'/unik.exe'
                                        var arguments = ' '+appsDir+'/'+fileName
                                        created = unik.createLink(exec, arguments, ad, 'This is a desktop file created by unik-tools', 'E:/')
                                    }
                                }
                                dialogoInformar.info='Se ha creado el acceso directo\nen '+ad
                            }
                        }

                        dialogoInformar.visible=created
                    }
                }

                Button{//Ejecutar
                    id: btnRun
                    width: parent.height
                    height: width
                    text: '\uf135'
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    //opacity: app.appVigente+'.upk'!==fileName ? 1.0 : 0.0
                    background: Rectangle{color: app.appVigente+'.upk'===fileName ? app.c2 : app.c1; radius: app.fs*0.3;}
                    visible:Qt.platform.os!=='android'
                    Text {
                        id: name
                        text: '<b>No Free</b>'
                        anchors.centerIn: parent
                        font.pixelSize: parent.height*0.2
                        color: "red"
                        visible: !parent.enabled
                    }
                    onClicked: {
                        var path = appsDir+'/'+fileName
                        var cl
                        var s0=''+fileName
                        var s1= s0.substring(s0.length-4, s0.length);
                        if(!folderListModelApps.isFolder(index)&&s1==='.upk'){
                            //logView.log("Lanzando upk: "+fileName)
                            var d = new Date(Date.now())
                            var t = unik.getPath(2)+'/t'+d.getTime()
                            unik.mkdir(t)
                            var upkToFolder = unik.upkToFolder(path, "unik-free", "free", t)
                            if(upkToFolder){
                                engine.load(t+'/main.qml')
                            }
                            //logView.log("Upk to folder: "+upkToFolder)
                        }else{
                            //logView.log("Lanzando carpeta "+path)
                            engine.load(path+'/main.qml')
                        }
                    }
                    Component.onCompleted: {
                        if(!folderListModelApps.isFolder(index)){
                            var upk = unikDocs+'/'+fileName
                            var isFree=unik.isFree(upk)
                            btnRun.enabled = isFree
                            console.log(""+upk+" free: "+isFree)
                        }
                    }
                }


                Button{//Ejecutar Android
                    id: btnRunAndroid
                    width: parent.height
                    height: width
                    text: '\uf135'
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    //opacity: app.appVigente+'.upk'!==fileName ? 1.0 : 0.0
                    background: Rectangle{color: app.appVigente+'.upk'===fileName ? app.c2 : app.c1; radius: app.fs*0.3;}
                    visible:Qt.platform.os==='android'
                    Text {
                        id: nameAn
                        text: '<b>No Free</b>'
                        anchors.centerIn: parent
                        font.pixelSize: parent.height*0.2
                        color: "red"
                        visible: !parent.enabled
                    }
                    onClicked: {
                        var j=appsDir+'/temp_config.json'
                        var path = appsDir+'/'+fileName
                        var c
                        var s0=''+fileName
                        var s1= s0.substring(s0.length-4, s0.length);
                        if(!folderListModelApps.isFolder(index)&&s1==='.upk'){
                            //logView.log("Lanzando upk: "+fileName)
                            var d = new Date(Date.now())
                            var t = unik.getPath(2)+'/t'+d.getTime()
                            unik.mkdir(t)
                            var upkToFolder = unik.upkToFolder(path, "unik-free", "free", t)
                            c='{"mode":"-folder", "arg1": "'+t+'"}'
                        }else{
                            //logView.log("Lanzando carpeta "+path)
                            c='{"mode":"-folder", "arg1": "'+path+'"}'
                        }
                        unik.setFile(j, c)
                        unik.restartApp()
                    }
                    Component.onCompleted: {
                        if(!folderListModelApps.isFolder(index)){
                            var upk = unikDocs+'/'+fileName
                            var isFree=unik.isFree(upk)
                            btnRun.enabled = isFree
                            console.log(""+upk+" free: "+isFree)
                        }
                    }
                }
                Button{//Ejecutar Aparte
                    id: btnRun2
                    width: parent.height
                    height: width
                    text: ''
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    enabled: btnRun.enabled
                    //opacity: app.appVigente+'.upk'!==fileName ? 1.0 : 0.0
                    background: Rectangle{color: app.appVigente+'.upk'===fileName ? app.c2 : app.c1; radius: app.fs*0.3;}
                    visible:Qt.platform.os!=='android'
                    Text {
                        text: '\uf135'
                        font.family: "FontAwesome"
                        font.pixelSize: xItem.height*0.5
                        anchors.bottom: parent.bottom
                        opacity: btnRun.enabled?1.0:0.3
                        //anchors.r: parent.right
                    }
                    Text {
                        text: '\uf135'
                        font.family: "FontAwesome"
                        font.pixelSize: xItem.height*0.5
                        anchors.top: parent.top
                        anchors.right: parent.right
                        opacity: btnRun.enabled?1.0:0.3
                    }
                    Text {
                        id: name2
                        text: '<b>No Free</b>'
                        anchors.centerIn: parent
                        font.pixelSize: parent.height*0.2
                        color: "red"
                        visible: !parent.enabled
                    }
                    onClicked: {
                        var appPath
                        if(Qt.platform.os==='osx'){
                            appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
                        }
                        if(Qt.platform.os==='windows'){
                            appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
                        }
                        if(Qt.platform.os==='linux'){
                            appPath = '"'+appExec+'"'
                        }
                        var path = appsDir+'/'+fileName
                        var cl = '-folder '
                        var s0=''+fileName
                        var s1= s0.substring(s0.length-4, s0.length);
                        if(!folderListModelApps.isFolder(index)&&s1==='.upk'){
                            //logView.log("Lanzando upk: "+fileName)
                            var d = new Date(Date.now())
                            var t = unik.getPath(2)+'/t'+d.getTime()
                            unik.mkdir(t)
                            var upkToFolder = unik.upkToFolder(path, "unik-free", "free", t)
                            if(upkToFolder){
                                cl +=''+t
                                unik.log('Running: '+appPath+' '+cl)
                                unik.run(appPath+' '+cl)
                            }
                            //logView.log("Upk to folder: "+upkToFolder)
                        }else{
                            //logView.log("Lanzando carpeta "+path)
                            cl+=''+path
                            unik.log('Running: '+appPath+' '+cl)
                            unik.run(appPath+' '+cl)
                        }
                    }
                }

                Button{//Seleccionar
                    width: parent.height
                    height: width
                    text: '\uf00c'
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    opacity: app.appVigente!==fileName ? 1.0 : 0.0
                    background: Rectangle{color: app.appVigente===fileName ? app.c2 : app.c1; radius: app.fs*0.3;}
                    onClicked: {
                        if((''+fileName).indexOf('.upk')<0){
                            var c = appsDir+'/'+fileName
                            var json='{"mode":"-folder", "arg1":"'+c+'"}'
                            app.appVigente = fileName
                            var c2 = appsDir+'/config.json'
                            unik.setFile(c2, json)
                            //logView.log('Aplicaciòn por defecto: '+c)
                            //logView.log('Nuevo Json Config: '+c2)
                        }else{
                            /*var c1 = ''+fileName
                            var c2 = c1.split('.upk')*/
                            app.appVigente = fileName
                            var p = ''+appsDir+'/'+fileName
                            var d = '{"mode":"-upk", "arg1":"'+p+'", "arg2":"-user=unik-free", "arg3":"-key=free"}'
                            var c=''+appsDir+'/config.json'
                            unik.setFile(c, d)

                            //unik.restartApp()
                        }
                        dc.estadoEntrada=3
                        dc.titulo="Confirmar Reinicio"
                        dc.consulta="Se ha cambiado de aplicaciòn\npor defecto: "+appVigente+"\nReiniciar Unik?"
                        dc.visible=true
                    }
                }

                Button{//Descargar
                    width: parent.height
                    height: width
                    text: '\uf019'
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    background: Rectangle{color:app.appVigente+'.upk'===fileName ? app.c2 : app.c1; radius: app.fs*0.3;}
                    visible: false
                }

                Button{//Actualizar desde GitHub
                    id:botActualizarGit
                    width: parent.height
                    height: width
                    text: '\uf09b'
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    background: Rectangle{color:app.c1; radius: app.fs*0.3;}
                    //opacity:  (''+fileName).indexOf('unik-qml')===0 ? 1.0 : 0.0
                    enabled: opacity===1.0
                    onClicked: {
                        if(version<2.15){
                            var carpetaLocal=appsDir
                            var ugdata = ''+unik.getFile(carpetaLocal+'/'+fileName+'/unik_github.dat')
                            var url = ugdata.replace('.git', '')
                            //var url = url0.replace('https://github.com/', 'https://codeload.github.com/')
                            ////logView.log('Actualizando '+url)

                            ////logView.log('Actualizando en carpeta '+carpetaLocal)
                            appSettings.logVisible = true
                            unik.setProperty("logViewVisible", true)
                            listApps.enabled=false
                            botActualizarGit.enabled=false
                            var actualizado = unik.downloadGit(url, carpetaLocal)
                            ////logView.log('Actualizado: '+actualizado)
                            listApps.enabled=true
                            botActualizarGit.enabled=true
                        }else{
                            var carpetaLocal=appsDir
                            var ugdata = ''+unik.getFile(carpetaLocal+'/'+fileName+'/unik_github.dat')
                            //var url0 = ugdata.replace('.git', '/zip/master')
                            //var urlZip = url0.replace('https://github.com/', 'https://codeload.github.com/')
                            var actualizado = unik.downloadGit(ugdata, carpetaLocal)
                        }
                    }
                    Text {
                        text: '\uf019'
                        font.family: "FontAwesome"
                        font.pixelSize: xItem.height*0.3
                        anchors.centerIn: parent
                    }
                    Component.onCompleted: {
                        var e = unik.fileExist(appsDir+'/'+fileName+'/unik_github.dat')
                        botActualizarGit.opacity = e
                    }
                }

                Button{//Eliminar
                    width: parent.height
                    height: width
                    text: '\uf014'
                    font.family: "FontAwesome"
                    font.pixelSize: xItem.height*0.8
                    background: Rectangle{color:app.appVigente+'.upk'===fileName ? app.c2 : app.c1; radius: app.fs*0.3;}
                    opacity: (''+fileName).indexOf('.upk')>=0 ? 1.0 : 0.0
                    onClicked: {
                        dc.dato1 = fileName
                        dc.estadoEntrada = 1
                        dc.titulo = '<b>Confirmar eliminación</b>'
                        dc.consulta = 'Está seguro que desea eliminar\n'+fileName+'?'
                        dc.visible = true

                    }
                }

            }
        }
    }


    Rectangle{
        id: xAddGit
        width: raiz.width
        height: app.fs*4
        color: "#333"
        border.color: "white"
        radius: app.fs*0.1
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        onVisibleChanged: {
            if(visible){
                tiUrlGit.text = appSettings.uGitUrl
            }
        }
        Row{
            anchors.centerIn: parent
            height: app.fs
            spacing: app.fs
            Text {
                id: labelUG
                text: "Url GitHub: "
                font.pixelSize: app.fs
                color: app.c1
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle{
                id: xTiUG
                width: xAddGit.width-labelUG.contentWidth-xTools.width-app.fs*2
                height: app.fs*1.2
                color: "#333"
                border.color: app.c2
                radius: app.fs*0.1
                clip: true
                TextInput{
                    id: tiUrlGit
                    width: xAddGit.width*0.65
                    height: app.fs
                    font.pixelSize: app.fs
                    color: text==='https://github.com/nextsigner/unik-qml-blogger.git' ? '#ccc' : 'white'
                    text: 'https://github.com/nextsigner/unik-qml-blogger.git'
                    anchors.centerIn: parent
                    Keys.onReturnPressed: {
                        dg()
                    }
                    onFocusChanged: {
                        if(text==='search'){
                            tiSearch.selectAll()
                        }
                    }
                    onTextChanged: {
                        appSettings.uGitUrl = text
                    }
                }
            }
            Boton{//Download Git
                id:btnDG
                w:xTiUG.height
                h: w
                t: '\uf019'
                b:app.area===0?app.c2:app.c1
                anchors.verticalCenter: parent.verticalCenter
                onClicking: {
                    dg()
                }
            }
        }
        Boton{//Close
            id:btnClose
            w:app.fs
            h: w
            t: 'X'
            b:app.c1
            anchors.right: parent.right
            onClicking: {
                parent.visible = false
            }
        }
    }


    DialogoConfirmar{
        id: dc
        width: parent.width*0.6
        //height: parent.height*0.5
        anchors.centerIn: parent
        visible: false
        property string dato1
        onVisibleChanged: {
            if(!visible){
                if(dc.estadoEntrada===1&&dc.estadoSalida===0){
                    //logView.log("No Acepta eliminar")
                }
                if(dc.estadoEntrada===1&&dc.estadoSalida===1){
                    //logView.log("Acepta eliminar")
                    var urlUpk = appsDir+'/'+dc.dato1
                    var urlUpk1 = urlUpk.replace('file:///', '')
                    //logView.log("Eliminando "+urlUpk1)
                    unik.deleteFile(urlUpk1)
                }
                if(dc.estadoEntrada===2&&dc.estadoSalida===1){
                    ukit.loadUpk(dc.dato1, true)
                }
                if(dc.estadoEntrada===2&&dc.estadoSalida===0){
                    ukit.loadUpk(dc.dato1, false)
                }
                if(dc.estadoEntrada===3&&dc.estadoSalida===1){
                    unik.restartApp()
                }


            }
        }

    }
    ToUpkDialog{
        id: toUpkDialog
        width: parent.width*0.6
        height: app.fs*11
        anchors.centerIn: parent
        visible: false
    }
    function dg(){
        btnDG.enabled = false
        var carpetaLocal=appsDir
        var actualizado = unik.downloadGit(tiUrlGit.text, carpetaLocal)
        btnDG.enabled = true
    }

}
