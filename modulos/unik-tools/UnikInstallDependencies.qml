import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.XmlListModel 2.0
Item {
    id: raiz
    //anchors.fill: parent
    //property alias flm: folderListModelApps
    //property alias dgvisible: xAddGit.visible
    //Connections {target: unik;onUkStdChanged: //logView.log(unik.ukStd);}
    //Connections {target: unik;onStdErrChanged: //logView.log(unik.getStdErr());}
    Rectangle{
        id: tb
        width: raiz.width
        height: app.fs*1.4
        color: app.c1
        Text {
            id: txtTit
            text: '<b>Unik List Dependencies</b> '
            font.pixelSize: app.fs
            color: app.c4
            anchors.centerIn: parent
        }
    }


    ListView{
        id: listDeps
        width: raiz.width-app.fs
        //height: raiz.height-tb.height
        anchors.top: tb.bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: raiz.horizontalCenter
        model: xmlLm
        delegate: delXmlDeps
        clip: true
        spacing: app.fs*0.2
    }
    Component{
        id: delXmlDeps
        Rectangle{
            id:xXmlData
            width: parent.width
            height: txt1.contentHeight+txt2.contentHeight+app.fs*4
            color: app.c2
            border.width: 1
            radius: app.fs*0.3
            Column{
                spacing: app.fs
                anchors.centerIn: parent
                Text{
                    id:txt1
                    text: '<b>'+name+' '+version+'</b>'
                    font.pixelSize: app.fs
                }
                Text{
                    id:txt2
                    text: description
                    font.pixelSize: app.fs*0.5
                    width: xXmlData.width-app.fs*2
                    wrapMode: Text.WordWrap
                }
                Button{
                    id: btnDownloadDep
                    width: app.fs
                    height: width
                    text: '\uf019'
                    font.family: "FontAwesome"
                    font.pixelSize: width*0.8
                    background: Rectangle{color:app.c1; radius: app.fs*0.3;}
                    //opacity: (''+fileName).indexOf('.upk')>=0 ? 1.0 : 0.0
                    anchors.right: parent.right
                    onClicked: {
                        if(Qt.platform.os==='linux'){
                            var script = unik.getHttpFile('https://raw.githubusercontent.com/nextsigner/dependencies/master/nodejs/install-linux')
                            var d = new Date(Date.now())
                            var destino = '/tmp/install-linux'
                            unik.setFile(destino, script)
                            unik.run('bash '+destino)
                        }

                    }
                }
            }
        }
    }
    XmlListModel{
        id:xmlLm
        query: "/dependencies"
        XmlRole{name: "name"; query: "name/string()";}
        XmlRole{name: "version"; query: "version/string()";}
        XmlRole{name: "description"; query: "description/string()";}
    }



//    Component{
//        id: delListDeps
//        Rectangle{
//            id: xItem
//            width: listDeps.width
//            height: delXmlDeps.height
//            color: app.c2
//            border.width: 1
//            radius: height*0.1
//            /*Text {
//                id: txtFileName
//                text: ar
//                font.pixelSize: app.fs
//                anchors.centerIn: parent
//            }*/
//            ListView{
//                id:lvXml
//                model: xmlLm
//                delegate: delXmlDeps
//                width: parent.width
//                height: parent.height
//                anchors.right: rowBtns.left
//            }

//            Component{
//                id: delXmlDeps
//                Rectangle{
//                    id:xXmlData
//                    width: parent.width
//                    height: txt1.contentHeight+txt2.contentHeight+app.fs
//                    border.width: 2
//                    border.color: 'red'
//                    Column{
//                        spacing: app.fs
//                        anchors.centerIn: parent
//                        Text{
//                            id:txt1
//                            text: ''+name+' '+version
//                            font.pixelSize: app.fs
//                            anchors.centerIn: parent
//                        }
//                        Text{
//                            id:txt2
//                            text: description
//                            font.pixelSize: app.fs
//                            width: xXmlData.width
//                            wrapMode: Text.WordWrap
//                            anchors.centerIn: parent
//                        }
//                    }
//                }
//            }
//            XmlListModel{
//                id:xmlLm
//                query: "/dependencies"
//                XmlRole{name: "name"; query: "name/string()";}
//                XmlRole{name: "version"; query: "version/string()";}
//                XmlRole{name: "description"; query: "description/string()";}
//            }

//            Row{
//                id: rowBtns
//                height: xItem.height*0.8
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.right: parent.right
//                anchors.rightMargin: xItem.height*0.2
//                spacing: app.fs*0.5
//                Button{
//                    width: parent.height
//                    height: width
//                    text: '\uf019'
//                    font.family: "FontAwesome"
//                    font.pixelSize: xItem.height*0.8
//                    background: Rectangle{color:app.c1; radius: app.fs*0.3;}
//                    //opacity: (''+fileName).indexOf('.upk')>=0 ? 1.0 : 0.0
//                    onClicked: {
//                        /*dc.dato1 = fileName
//                        dc.estadoEntrada = 1
//                        dc.titulo = '<b>Confirmar eliminación</b>'
//                        dc.consulta = 'Está seguro que desea eliminar\n'+fileName+'?'
//                        dc.visible = true*/

//                    }
//                }

//            }
//            Component.onCompleted: {
//                //xmlLm.source = 'https://raw.githubusercontent.com/nextsigner/dependencies/master/'+ar+'/dependencies.xml'
//                //xmlLm.query= '/dependecies'
//                var xml0=unik.getHttpFile('https://raw.githubusercontent.com/nextsigner/dependencies/master/'+ar+'/dependencies.xml')
//                unik.setFile('/home/nextsigner/Documentos/aaa.xml', xml0)
//                xmlLm.source ='file:///home/nextsigner/Documentos/aaa.xml'
//                //console.log(xml0)
//            }
//        }
//    }

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


            }
        }

    }

    function updateDepsList(){
        //xmlLm.clear()
        var deps0=''+unik.getHttpFile('https://github.com/nextsigner/dependencies')
        var deps1=deps0.split('<tbody>')
        var deps2=''+deps1[1]
        var deps3=deps2.split('</tbody>')
        var deps4=(''+deps3[0]).split('js-navigation-item')
        for(var i=0;i<deps4.length;i++){
            var deps5=(''+deps4[i]).split('</a>')
            var deps6=(''+deps5[0]).split('>')
            if((''+deps6[deps6.length-1]).indexOf('tr class')<0&&deps6[deps6.length-1]!==''&&deps6[deps6.length-1]!=='README.md'){
                //lmDeps.append(lmDeps.add(deps6[deps6.length-1]))
                var xml0=unik.getHttpFile('https://raw.githubusercontent.com/nextsigner/dependencies/master/'+deps6[deps6.length-1]+'/dependencies.xml')
                var d=new Date(Date.now())
                var r=''+d.getTime()
                unik.setFile(unik.getPath(2)+'/'+r+'.xml', xml0)
                xmlLm.source ='file://'+unik.getPath(2)+'/'+r+'.xml'
                //console.log('>:'+deps6[deps6.length-1]+'------<br>')
            }
        }
    }
    Component.onCompleted: {
        updateDepsList()
    }
}
