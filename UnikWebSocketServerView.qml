import QtQuick 2.0
import QtQuick.Controls 2.0
import Qt.WebSockets 1.0

Item {
    width: 640
    height: 480
    Connections {
        target: cw
        onClientConnected:{
            console.log("A new client connected.")
        }
    }
    Connections {
        target: cs
        onUserListChanged:{
            listModelUser.updateUserList()
        }
        onNewMessage:{
            listModelMsg.addMsg('['+time+']'+user+':'+msg)
        }
    }
    Column{
        anchors.fill: parent
        Rectangle{
            width: parent.width
            height: 28
            Text {
                id: txtTit
                property int nt: 0
                property var titles:["Its is a <b>SERVER</b> - only received message from qt_qml_chat_client", "Download from github qt_qml_chat_client for send a message here", "This server and the client app is connected in ws://localhost:12345 "]
                text: txtTit.titles[0]
                font.pixelSize: parent.width*0.025
                anchors.centerIn: parent
                Timer{
                    running: true
                    repeat: true
                    interval: 3500
                    onTriggered: {
                        if(txtTit.nt<2){
                            txtTit.nt++
                        }else{
                            txtTit.nt =0;
                        }
                        txtTit.text = txtTit.titles[txtTit.nt]
                    }
                }
            }
        }
        Row{
            width: parent.width
            height: parent.height-28
            Rectangle{
                width: parent.width*0.7
                height: parent.height
                border.width: 1
                clip: true
                Rectangle{
                    width: parent.width
                    height: 28
                    color: "black"
                    Text {
                        text: "<b>Messages</b>"
                        font.pixelSize: 24
                        anchors.centerIn: parent
                        color: "white"
                    }
                }
                ListView{id:msgListView;width: parent.width; height: parent.height-28; y:28; spacing: 10; clip: true; model: listModelMsg; delegate: delegateMsg;}
            }
            Rectangle{
                width: parent.width*0.3
                height: parent.height
                border.width: 1
                clip: true
                Rectangle{
                    width: parent.width
                    height: 28
                    color: "black"
                    Text {
                        text: "<b>User List</b>"
                        font.pixelSize: 24
                        anchors.centerIn: parent
                        color: "white"
                    }
                }
                ListView{id:userListView;width: parent.width; height: parent.height-28; y:28; spacing: 10; clip: true; model: listModelUser; delegate: delegateUser;}
            }
        }
    }
    ListModel{
        id: listModelUser
        function createElement(u){
            return {
                user: u
            }
        }
        function updateUserList(){
            clear()
            var ul = cs.userList;
            for(var i=0; i < ul.length; i++){
                append(createElement(ul[i]))
            }
        }
    }
    ListModel{
        id: listModelMsg
        function createElement(m){
            return {
                msg: m
            }
        }
        function addMsg(msg){
            append(createElement(msg))
            msgListView.currentIndex = count-1
        }
    }
    Component{
        id: delegateUser
        Rectangle{
            width: userListView.width*0.9
            height: 24
            border.width: 1
            color: "#cccccc"
            radius: 6
            anchors.horizontalCenter: parent.horizontalCenter
            clip:true
            Text {
                text: "<b>"+user+"</b>"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
        }
    }
    Component{
        id: delegateMsg
        Rectangle{
            width: msgListView.width*0.9
            height: txtMsg.contentHeight
            border.width: 1
            color: "#cccccc"
            radius: 6
            anchors.horizontalCenter: parent.horizontalCenter
            clip:true
            Text {
                id: txtMsg
                width: parent.width-48
                height: contentHeight
                text: "<b>"+msg+"</b>"
                font.pixelSize: 20
                anchors.centerIn: parent
                wrapMode: Text.WordWrap
            }
        }
    }
    Component.onCompleted: {
        listModelUser.updateUserList()
    }
}
