import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Rectangle {
        id: menu_view
        color: "#2c313c"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        visible: true

        Grid {
            id: grid_menu
            anchors.margins: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            rows: 2
            columns: 3

            property int dynamic_width: grid_menu.width / grid_menu.columns - grid_menu.anchors.margins * 2
            property int dynamic_height: grid_menu.height / grid_menu.rows  - grid_menu.anchors.margins * 2
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Button {
                id: btn_connect
                text: if(!back.printer_status){qsTr("Connect")} else{qsTr("Disconnect")}
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    if (!back.printer_status){
                        backend.print_connect()
                    }
                    else{
                        backend.print_disconnect()
                    }
                }
            }

            Button {
                id: btn_setting
                text: qsTr("setting")
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    stackView.push(Qt.resolvedUrl("Settings.qml"))
                }
            }

            Button {
                id: btn_control
                text: qsTr("Control")
                leftPadding: 8
                rightPadding: 8
                topPadding: 12
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    stackView.push(Qt.resolvedUrl("Control.qml"))
                }
            }
            Button {
                id: btn_temperature
                text: qsTr("Temperature")
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    stackView.push(Qt.resolvedUrl("Temperature.qml"))
                }
            }

            Button {
                id: btn_print
                text: qsTr("Print")
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    stackView.push(Qt.resolvedUrl("Print.qml"))
                }
            }

            Button {
                id: btn_exit
                text: qsTr("Exit")
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: mainWindow.close()
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
