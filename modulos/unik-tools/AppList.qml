import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle {
    id: raiz
    color: app.c5
    ListView{
        id: lv
        width: raiz.width*0.9
        height: raiz.height
        spacing: app.fs*0.5
        delegate: del
        anchors.horizontalCenter: parent.horizontalCenter
        clip:true
        Component{
            id:del
            Rectangle{
                id: xC
                width: lv.width-app.fs
                height: visible?lv.width*0.2:0
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                color: app.c1
                opacity: nom!=='spacer'?1.0:0.0
                border.width: 2
                border.color: app.c2
                radius: app.fs*0.5
                visible: (''+tipo).indexOf(''+Qt.platform.os)!==-1
                Image {
                    id: imagen
                    source: img2
                    width: xC.height-app.fs*0.4
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: app.fs*0.5
                    cache:false
                }
                Column{
                    //visible:parent.color!=='transparent'
                    anchors.left: imagen.right
                    anchors.leftMargin: app.fs*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle{
                        id: xNom
                        width:xC.width-imagen.width-app.fs*1.5
                        height: xC.height*0.15
                        clip: true
                        color: "transparent"
                        Text {
                            id: lnom
                            text: '<b>'+nom+'</b>'
                            font.pixelSize: app.fs
                            width: parent.width-app.fs
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle{
                        id:xDes
                        width:xNom.width
                        height: xC.height*0.6
                        anchors.horizontalCenter: xNom.horizontalCenter
                        clip: true
                        color: "transparent"
                        Text {
                            id: ldes
                            text: des
                            font.pixelSize: app.fs*0.6
                            anchors.centerIn: parent
                            width: parent.width-app.fs*0.8
                            wrapMode: Text.WordWrap
                        }
                    }
                    Rectangle{
                        id:xDevYBotInst
                        width:xNom.width
                        height: xC.height*0.15
                        clip: true
                        color: "transparent"
                        anchors.horizontalCenter: xNom.horizontalCenter
                        Text {
                            id: ldev
                            text: '<b>Desarrollador: </b>'+dev+''
                            font.pixelSize: app.fs*0.8
                            width: contentWidth+app.fs
                            anchors.left: parent.left
                            anchors.leftMargin: app.fs*0.5
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            id:botInstalarApp
                            width:lBotInst.contentWidth+app.fs
                            height: xC.height*0.15
                            clip: true
                            color: 'black'
                            anchors.right: parent.right
                            radius: app.fs*0.5
                            Text {
                                id: lBotInst
                                color: app.c2
                                text: "Instalar"
                                font.pixelSize: app.fs*0.8
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    botInstalarApp.color = app.c2
                                    lBotInst.color = 'black'
                                }
                                onExited:  {
                                    botInstalarApp.color = 'black'
                                    lBotInst.color = app.c2
                                }
                                onPressed: {
                                    lBotInst.text='<b>'+"Instalar"+'</b>'
                                }
                                onReleased: {
                                    lBotInst.text="Instalar"
                                }
                                onClicked: {
                                    if((''+urlgit).indexOf('.upk')<0){

                                        //app.area=1

                                        //var downloaded = unik.downloadGit(urlgit, fd)
                                        unik.setProperty("logViewVisible", true)
                                        var carpetaLocal=appsDir
                                        var downloaded = unik.downloadGit(urlgit, carpetaLocal)
                                        var fd = appsDir
                                        if(downloaded){
                                            unik.log('Aplicación '+nom+' descargada.')
                                            var m0= (''+urlgit).split('/')
                                            var s0=''+m0[m0.length-1]
                                            var s1=s0.replace('.git', '')
                                            var nc = '{"mode":"-folder", "arg1": "'+fd+'/'+s1+'"}'
                                            unik.setFile(appsDir+'/config.json', nc)
                                            unik.setFile(fd+'/unik_github.dat', urlgit)
                                            unik.restartApp()
                                        }else{
                                            unik.log('Aplicación '+nom+' no se ha instalado.')
                                        }
                                    }else{
                                        var m0=(''+urlgit).split('/')
                                        var m1=''+m0[m0.length-1]
                                        var upkData=unik.getHttpFile(urlgit)
                                        var upkFileName=appsDir+'/'+m1
                                        unik.setFile(upkFileName, upkData)
                                        var c='{"mode":"-upk", "arg1": "'+upkFileName+'", "arg2":"-user=unik-free", "arg3":"-key=free"}'
                                        unik.setFile(appsDir+'/config.json', c)
                                        unik.restartApp()

                                    }


                                }
                            }

                        }
                    }
                }
            }
        }
    }


    function act(){
        var d = new Date(Date.now())
        var c = unik.getHttpFile('https://raw.githubusercontent.com/nextsigner/unik-tools/master/GitAppsList.qml?raw=true&r='+d.getTime())
        var nLm=Qt.createQmlObject(c, raiz, 'qmlNLM')
        if(nLm){
            lv.model = nLm.lm
        }

    }

}
