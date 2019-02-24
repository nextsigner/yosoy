
        import QtQuick 2.0
       
        Item {
            id: raiz
            width: parent.width
            height: appSettingsUnik.lvfs*2
            //visible: raiz.opacity>0.1?true:false
            property int minY: 0
            property int maxY: raiz.parent.height
            signal lineReleased
            /*onYChanged: {
                if(y===raiz.parent.height-raiz.height){
                    raiz.opacity=0.0
                }
            }*/
            Behavior on opacity{
                NumberAnimation{
                    duration: 250
                }
            }
            Rectangle{
                anchors.fill: raiz
                color: '#333'
                border.width: 1
                border.color: '#ccc'
                MouseArea{
                    //anchors.fill: parent
                    //enabled: raiz.opacity!==0.0
                    width: parent.width
                    height: parent.height*1.6
                    anchors.centerIn: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeVerCursor
                    drag.target: raiz
                    drag.axis: Drag.YAxis
                    drag.minimumY: raiz.minY
                    drag.maximumY: raiz.maxY
                    onEntered: parent.color = '#ccc'
                    onExited: parent.color = '#333'
                    onReleased: {
                        lineReleased()
                    }
                }
            }
        }
     
