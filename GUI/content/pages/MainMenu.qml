import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Grid {
            id: grid_menu
            anchors.fill: parent
            verticalItemAlignment: Grid.AlignVCenter
            horizontalItemAlignment: Grid.AlignHCenter
            padding: 10
            spacing: 10
            rows: 3
            columns: 2

            property int dynamic_width: grid_menu.width / grid_menu.columns - 10 - 10
            property int dynamic_height: grid_menu.height / grid_menu.rows - 10 - 10
            width: 576

            Button {
                id: btn_connect
                highlighted: false
                flat: false
                enabled: true
                checkable: false
                checked: false
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                text: ""
                onClicked: {
                    if (!back.printer_status){
                        backend.print_connect()
                    }
                    else{
                        backend.print_disconnect()
                    }
                }

                Image {
                    id: connected
                    visible: back.printer_status
                    anchors.fill: parent
                    source: "../icons/connected.png"
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: disconnected
                    visible: !back.printer_status
                    anchors.fill: parent
                    source: "../icons/disconnected.png"
                    antialiasing: false
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 10
                    anchors.topMargin: 6
                    fillMode: Image.PreserveAspectFit
                }
            }
            Button {
                id: btn_control
                text: qsTr("")
                enabled: back.printer_status
                leftPadding: 8
                rightPadding: 8
                topPadding: 12
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    stackView.push(Qt.resolvedUrl("Control.qml"))
                }

                Image {
                    id: move
                    anchors.fill: parent
                    source: "../icons/move.png"
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    fillMode: Image.PreserveAspectFit
                }
            }
            Button {
                id: btn_temperature
                text: qsTr("")
                enabled: back.printer_status
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    stackView.push(Qt.resolvedUrl("Temperature.qml"))
                }

                Image {
                    id: hightemperature
                    anchors.fill: parent
                    source: "../icons/high-temperature.png"
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    fillMode: Image.PreserveAspectFit
                }
            }
            Button {
                id: btn_print
                text: qsTr("")
                enabled: back.printer_status
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    stackView.push(Qt.resolvedUrl("Print.qml"))
                }

                Image {
                    id: _3dprinting1
                    anchors.fill: parent
                    source: "../icons/3d-printing(1).png"
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    fillMode: Image.PreserveAspectFit
                }
            }
            Button {
                id: btn_setting
                text: qsTr("")
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: {
                    stackView.push(Qt.resolvedUrl("Settings.qml"))
                }

                Image {
                    id: settings
                    anchors.fill: parent
                    source: "../icons/settings.png"
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    fillMode: Image.PreserveAspectFit
                }
            }
            Button {
                id: btn_exit
                text: qsTr("")
                width: grid_menu.dynamic_width
                height: grid_menu.dynamic_height
                onClicked: mainWindow.close()

                Image {
                    id: logout
                    anchors.fill: parent
                    source: "../icons/logout.png"
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    fillMode: Image.PreserveAspectFit
                }
            }
        }


}

/*##^##
Designer {
    D{i:0;autoSize:true;height:974;width:580}
}
##^##*/
