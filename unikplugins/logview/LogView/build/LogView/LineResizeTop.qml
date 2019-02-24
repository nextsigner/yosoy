import QtQuick 2.0

Item {
    id: raiz
    property bool presionado: false
    property int minY: 0
    property int maxY: raiz.parent.height
    property color color: '#333'
    property color overColor: '#ccc'
    signal lineReleased
    signal procesar
   Rectangle{
        id: bg
        anchors.fill: raiz
        color: raiz.color
        Rectangle{
            anchors.fill: parent
            color: 'black'
            opacity: 0.15
            visible: parent.height>4
        }
        Rectangle{
            width: parent.width-4
            height: parent.height-4
            color: parent.color
            anchors.centerIn: parent
            visible: parent.height>4
        }
        MouseArea{
            enabled: raiz.height>0
            width: parent.width
            height: parent.height*1.6
            anchors.centerIn: parent            
            hoverEnabled: true
            cursorShape: Qt.SizeVerCursor
            drag.target: raiz
            drag.axis: Drag.YAxis
            drag.minimumY: raiz.minY
            drag.maximumY: raiz.maxY
            onEntered: parent.color = raiz.overColor
            onExited: {
                parent.color = raiz.color
            }
            onPressed: raiz.presionado=true
            onReleased: {
                raiz.presionado=false
                lineReleased()
            }
            onDoubleClicked: raiz.parent.showUnikControls = !raiz.parent.showUnikControls
        }
    }
    Timer{
        running: raiz.presionado
        repeat: true
        interval: 250
        onTriggered: procesar()
    }
}

