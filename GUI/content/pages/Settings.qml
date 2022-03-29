import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

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

        CustomButton {
            id: customButton
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
        }

        SwipeView {
            id: settingsView
            y: 34
            height: 390
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            currentIndex: 1

            Item {
                id: printerSetting
                Text {
                    id: text1
                    width: 126
                    height: 33
                    color: "#ff0000"
                    text: qsTr("Printer Settings")
                    anchors.top: parent.top
                    font.pixelSize: 17
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 8
                }

                Label {
                    id: port_label
                    x: 71
                    y: 92
                    width: 121
                    height: 34
                    text: qsTr("Port:")
                    font.pointSize: 15
                }

                ComboBox {
                    id: port_choice
                    y: 93
                    width: 120
                    height: 32
                    anchors.left: port_label.right
                    wheelEnabled: false
                    clip: false
                    layer.mipmap: false
                    anchors.leftMargin: 23
                    model: back.port_list
                }

                Label {
                    id: baudrate_label
                    x: 71
                    y: 187
                    width: 121
                    height: 33
                    text: qsTr("Baudrate:")
                    font.pointSize: 15
                }

                ComboBox {
                    id: baudrate_choice
                    y: 187
                    width: 120
                    height: 32
                    anchors.left: baudrate_label.right
                    anchors.leftMargin: 23
                    model: back.baudrate_list
                }

                Button {
                    id: save_button
                    x: 375
                    y: 328
                    text: qsTr("SAVE")
                    onClicked: {
                        backend.portList("save")
                    }
                }


            }
            Item {
                id: printerSetting2
            }

            Item {
                id: mqttSetting
                Text {
                    id: text2
                    width: 69
                    height: 41
                    color: "#ff0000"
                    text: qsTr("MQTT")
                    anchors.top: parent.top
                    font.pixelSize: 23
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    id: ip_label
                    x: 71
                    y: 92
                    width: 121
                    height: 34
                    text: qsTr("IP address:")
                    font.pointSize: 15
                }

                Label {
                    id: serverport_label
                    x: 71
                    y: 186
                    width: 121
                    height: 33
                    text: qsTr("Port:")
                    font.pointSize: 15
                }

                Button {
                    id: savebutton
                    x: 368
                    y: 297
                    text: qsTr("SAVE")
                }
                TextField {
                    id: textField1
                    x: 229
                    y: 92
                    width: 171
                    height: 32
                    placeholderText: qsTr(back.mqtt_ip)
                }

                TextField {
                    id: textField
                    x: 229
                    y: 179
                    width: 115
                    height: 32
                    placeholderText: back.mqtt_port
                }

                Switch {
                    id: switch1
                    x: 558
                    y: 171
                    text: qsTr("Autoconnect")
                }

                Label {
                    id: label
                    x: 568
                    y: 94
                    width: 138
                    height: 19
                    text: qsTr("Stav: ")
                }


            }

            Item {
                id: mesSetting
                Text {
                    id: text3
                    x: 335
                    y: 8
                    width: 131
                    height: 45
                    color: "#fc0000"
                    text: qsTr("MES Server")
                    font.pixelSize: 25
                }
            }

        }

        PageIndicator {
            id: pageIndicator
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 0

            count: settingsView.count
            currentIndex: settingsView.currentIndex

        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
