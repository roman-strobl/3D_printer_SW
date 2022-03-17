import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    id: mainWindow
    width: 1024
    height: 600
    visible: true
    color: "#2c313c"
    minimumHeight: 480
    maximumHeight: 600
    minimumWidth: 800
    maximumWidth: 1024
    title: "GUI_Printer"

    flags: Qt.Window | Qt.FramelessWindowHint

    function startupFunction() {
            backend.Init()
            backend.initPort()
        }

    Rectangle {
        id: contentpage
        color: "#2c313c"
        anchors.fill: parent
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 40


        StackView {
            id: stackView
            anchors.fill: parent
            wheelEnabled: false
            initialItem:  stackView.push(Qt.resolvedUrl("pages/MainMenu.qml"))
        }

    }

    Label {
        id: label
        width: 67
        height: 19
        text: qsTr("Connect")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 26
        anchors.topMargin: 15
    }
    Connections{
        id:back

        target: backend

        property var port_list: []
        property var baudrate_list: []
        property

        function onGetPort(port_list){
            back.port_list = port_list
            backend.Debug()
        }
        function onGetBaudrate(baudrate_list){
            back.baudrate_list = baudrate_list
            backend.Debug()
        }
    }
    Component.onCompleted: startupFunction();

}

