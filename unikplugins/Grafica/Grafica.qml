
import QtQuick 2.0

Rectangle {
    id: raiz
    //anchors.fill: parent
    width: raiz.parent.width*0.35
    height: raiz.parent.height*0.6
    anchors.centerIn: parent
    property int fontSize: 12
    property color gridLineColor: 'gray'

    property string drawData:''

    property real yMax
    property real xMax
    onDrawDataChanged: draw()
    Rectangle{
        id: grafica
        width: raiz.width
        height: raiz.height
        anchors.centerIn: parent
        border.width: 1
        //border.color: 'red'
        color: "#fff"
        Row{
            anchors.fill: parent
            spacing: parent.width/10-1
            Repeater{
                model:11
                Rectangle{
                    width: 1
                    height: parent.height
                    color: raiz.gridLineColor
                    Item{
                        width: 10
                        height: 10
                        //border.width: 1
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        //anchors.horizontalCenterOffset:  width/2
                        //color: 'red'
                        Text {
                            id: txtMacrHor
                            text: index!==0?'- '+parseFloat(raiz.xMax/10*(index)).toFixed(2):'- 0'
                            font.pixelSize: raiz.fontSize
                            rotation: -90
                            //anchors.centerIn: parent
                            anchors.horizontalCenter: parent.horizontalCenter
                            y:0-width/2
                            //anchors.verticalCenterOffset: 50
                            //anchors.bottom: parent.top
                            //anchors.bottomMargin: raiz.fontSize
                        }
                    }
                }
            }
        }
        Column{
            anchors.fill: parent
            spacing: parent.height/10-1
            Repeater{
                id:rep2
                model: 11
                Rectangle{
                    width: parent.width
                    height: 1
                    color: raiz.gridLineColor
                    Text {
                        id: txtMacrVert
                        text: index!==0?''+parseFloat(raiz.yMax/10*(index)).toFixed(2)+' -':'0 -'
                        font.pixelSize: raiz.fontSize
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.left
                        anchors.rightMargin: raiz.fontSize*0.5
                    }
                }
            }
        }
        Rectangle{
            id:ejeY
            width: 2
            height: parent.height
            color: 'black'
        }
        Rectangle{
            id:ejeX
            width: parent.width
            height: 1
            color: 'black'
        }
        Text {
            id: txtX
            text: '<b>x</b>'
            font.pixelSize: raiz.fontSize
            anchors.right: ejeX.right
            anchors.rightMargin: raiz.fontSize*0.5
            anchors.top: parent.top
            anchors.topMargin: raiz.fontSize*0.5
        }
        Text {
            id: txtY
            text: '<b>y</b>'
            font.pixelSize: raiz.fontSize
            anchors.bottom: ejeY.bottom
            anchors.bottomMargin: raiz.fontSize*0.5
            anchors.left: parent.left
            anchors.leftMargin: raiz.fontSize*0.5
        }
        Canvas{
            id:canvas
            anchors.fill: parent
            property var coordX: []
            property var coordY: []
            property int xOffSet: 0
            property int yOffSet: 0
            property real xScale: 1.0
            property real yScale: 1.0
            onPaint: {
                var ctx = getContext("2d")
                //ctx.scale(xScale, yScale)
                ctx.lineWidth = 4;
                ctx.strokeStyle = "red"
                ctx.beginPath()
                ctx.moveTo(parseInt(xOffSet+0), 0)
                for(var i=0;i<canvas.coordX.length;i++){
                    ctx.lineTo(parseInt(xOffSet+canvas.coordX[i]), canvas.coordY[i])
                    console.log('XY--->'+canvas.coordX[i]+' '+canvas.coordY[i])
                }
                ctx.stroke()

            }
        }
    }
    Component.onCompleted: {
        var dataExample = '0 0
138 138
229.99 230
320.98 321
412.95 413
506.81 507
598.43 599
738.27 740
833.76 837
909.78 915
994.89 1003
1080.25 1092
1163.58 1180
1245.89 1268
1327.35 1356
1408.78 1445
1488.1 1533
1565.18 1620
1642.56 1709
1716.59 1796
1789.71 1883
1864.36 1972
1937.22 2059
2011.76 2148
2086 2237
2158.26 2324
2231.19 2412
2304.81 2501
2376.83 2588
2450.5 2677
2520.71 2762
2593.25 2850
2664.29 2936
2737.88 3025
2810.67 3113
2882.64 3200
2955.75 3288
3030.06 3376
3106.79 3465
3183.2 3553
3258.65 3641
3332.89 3729
3406.97 3818
3477.05 3903
3621.98 4080
3700.82 4177'
        raiz.drawData=dataExample
    }
    function draw(){
        var valXMen=0
        var valXMax=0
        var valYMen=0
        var valYMax=0
        var rows = {}
        var despEjeX=0
        var despEjeY=0
        var lines = raiz.drawData.split('\n')
        for(var i=0;i<lines.length;i++){
            var data = (''+lines[i]).split(" ")
            var col = {col:[data[0],data[1]]}
            rows[i]=col
        }
        //var dyMax=parseFloat(rows[lines.length-1].col[1]).toFixed(2)
        //raiz.yMax=dyMax
        var aY=[]
        var aPosX=[]
        var aPosY=[]
        var aX=[]
        //var arrayDiff=[]
        for(var i=0;i<lines.length;i++){
            var px =parseFloat(rows[i].col[0]).toFixed(2)
            aX.push(px)
            if(px<valXMen){
                valXMen=px
            }
            if(px>valXMax){
                valXMax=px
            }            var py =parseFloat(rows[i].col[1]).toFixed(2)
            aY.push(py)
            if(py<valYMen){
                valYMen=py
            }
            if(py>valYMax){
                valYMax=py
            }
            var dif = parseFloat(py-px).toFixed(2)
            //console.log('dif: '+dif)

        }

        for(var i=0;i<lines.length;i++){
            //console.log('aX'+i+': '+aX[i])
            //console.log('valXMax: '+valXMax)
            var porcX = (grafica.width/parseInt(aX[i]))*100
            //console.log('porcX: '+porcX)
            var posX=grafica.width-porcX
            //aPosX.push(posX)
            aPosX[i]=posX
            var porcY = grafica.height/parseInt(aY[i])*100
            var posY=grafica.height-porcY
            //aPosY.push(posY)
            aPosY[i]=posY
            //console.log('Px: '+posX+' Py: '+posY)
            console.log('Porcx: '+porcX+' Porcy: '+porcY)
        }
        //console.log('apy: '+aPosY)
        console.log('canvas size: '+canvas.width+'x'+canvas.height)
        canvas.coordX=aPosX
        canvas.coordY=aPosY
        canvas.requestPaint()

//        for(var i=0;i<lines.length;i++){
//            var dy=parseFloat(rows[i].col[1]).toFixed(2)

//            var dx=parseFloat(rows[i].col[0]).toFixed(2)

//            //if(dy<=dyMax){
//            aY.push(dy)
//            var porcY = (dy/dyMax)*100
//            var posY=grafica.height/100*porcY
//            if(posY<valYMen){
//                valYMen=posY
//            }
//            if(posY>valYMax){
//                valYMax=posY
//            }
//            aPosY.push(posY)
//            aX.push(dx)
//            raiz.xMax=dx
//            //}
//        }
//        for(var i=0;i<aY.length;i++){
//            //var dif=aY[i]-aX[i]
//            var dif
//            dif = aY[i]-aX[i]


//            console.log('dif: '+dif)
//            var porcDif = dif/grafica.height*100
//            var posXDif=grafica.width/100*porcDif+4
//            if(posXDif<valXMen){
//                valXMen=posXDif
//                //canvas.xOffSet=-(valXMen)
//            }
//            if(posXDif>valXMax){
//                valXMax=posXDif
//            }
//            arrayDiff.push(posXDif)
//        }
        //canvas.scale=
        /*var aXS=[]
        var anchoTotal = -(valXMen)+valXMax
        if(anchoTotal>grafica.width){
            //var
            var porcXSR=1.0+(grafica.width/anchoTotal*100)
            var nValXMen=parseFloat(valXMen/100*porcXSR).toFixed(2)
            console.log(' valXMen: '+valXMen)
            console.log(' nValXMen: '+nValXMen)
            for(var i=0;i<lines.length;i++){
                var npx=parseFloat(aPosX[i]/100*porcXSR).toFixed(2)
                console.log('npx: '+npx)
                aXS.push(npx)
                if(npx<=nValXMen){
                    nValXMen=npx
                    canvas.xOffSet=-(nValXMen)
                    console.log('canvas.xOffSet: '+canvas.xOffSet)
                }
                if(npx>valXMax){
                    valXMax=npx
                }
            }
            //console.log('porcXSR: '+porcXSR)
            //canvas.xScale=-(1.0-porcXSR)
            //console.log('canvas.xScale: '+canvas.xScale)
        }*/
        //ejeY.x=grafica.width-(-(valXMen))

        //var xPositivoMax =

        //raiz.width=parseInt(-(valXMen)+valXMax)
        //canvas.scale = 0.5
    }
}
