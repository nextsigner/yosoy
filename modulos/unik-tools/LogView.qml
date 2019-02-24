
        import QtQuick 2.0
       
        Rectangle{
            id:xTaLog
            width: app.width
            height: app.fs*4
            clip: true
            color: app.c5
            border.width: 1
            border.color: app.c2
            Flickable{
                id:fk
                width: parent.width
                height: parent.height
                contentWidth: parent.width
                contentHeight: taLog.contentHeight
                boundsBehavior: Flickable.StopAtBounds
                onContentHeightChanged: {
                    //fk.contentY = fk.contentHeight
                }
                Text{
                    id: taLog
                    width: parent.width-app.fs
                    //height: contentHeight
                    anchors.centerIn: parent
                    font.pixelSize: app.fs*0.5
                    textFormat: Text.Normal
                    color: app.c2
                    wrapMode: Text.WrapAnywhere
                    onTextChanged: {
                        //height = contentHeight
                    }
       
       
                }
            }
       
            Boton{
                id:btnClear
                w:parent.width*0.02
                anchors.right: parent.right
                h: w
                t: '\uf12d'
                b:"#444444"
                c: app.c2
                onClicking: {
                    taLog.text = ''
                }
            }
            function log(l){
                var d = new Date(Date.now())
                var t = '['+d.getHours()+':'+d.getMinutes()+':'+d.getSeconds()+'] '
                taLog.text+=t+l+'\n'
                if(taLog.height>xTaLog.height){
                    fk.contentY = taLog.height-xTaLog.height
                }
            }
       
        }
       
     
