import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
    id: item1

    Rectangle {
        id: menu_view
        color: "#2c313c"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
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
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: pageIndicator.bottom
            anchors.bottom: customButton.top
            anchors.topMargin: 5
            anchors.bottomMargin: 10
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            currentIndex: 0

            Item {
                id: printerSetting
                Text {
                    id: text1
                    x: 237
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
                    y: 93
                    width: 121
                    height: 34
                    text: qsTr("Port:")
                    anchors.left: parent.left
                    anchors.right: baudrate_label.right
                    anchors.top: parent.top
                    anchors.rightMargin: 0
                    anchors.leftMargin: 62
                    anchors.topMargin: 90
                    anchors.horizontalCenter: baudrate_label.horizontalCenter
                    font.pointSize: 15
                }

                ComboBox {
                    id: port_choice
                    y: 93
                    width: 120
                    height: 32
                    anchors.left: port_label.right
                    displayText: back.port
                    wheelEnabled: false
                    clip: false
                    layer.mipmap: false
                    anchors.leftMargin: 23
                    model: back.port_list
                    onActivated: {
                        back.port = back.port_list[index]
                    }


                }

                Label {
                    id: baudrate_label
                    x: 62
                    y: 187
                    width: 121
                    height: 33
                    text: qsTr("Baudrate:")
                    anchors.verticalCenter: baudrate_choice.verticalCenter
                    anchors.top: baudrate_choice.top
                    anchors.verticalCenterOffset: -1
                    anchors.topMargin: -1
                    font.pointSize: 15
                }

                ComboBox {
                    id: baudrate_choice
                    y: 187
                    width: 120
                    height: 32
                    displayText: back.port
                    anchors.left: baudrate_label.right
                    anchors.leftMargin: 23
                    model: back.baudrate_list
                    onActivated: {
                        back.baudrate = back.baudrate_list[index]
                    }
                }

                Button {
                    id: save_button
                    x: 293
                    y: 843
                    text: qsTr("SAVE")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
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
                    x: 233
                    y: 642
                    text: qsTr("SAVE")
                }
                TextField {
                    id: textField1
                    x: 46
                    y: 92
                    width: 171
                    height: 32
                    anchors.top: ip_label.top
                    anchors.horizontalCenterOffset: 159
                    anchors.horizontalCenter: serverport_label.horizontalCenter
                    placeholderText: qsTr(back.mqtt_ip)
                }

                TextField {
                    id: textField
                    x: 46
                    y: 187
                    width: 115
                    height: 32
                    anchors.verticalCenter: serverport_label.verticalCenter
                    anchors.left: textField1.left
                    anchors.bottom: serverport_label.bottom
                    anchors.leftMargin: 0
                    placeholderText: back.mqtt_port
                }

                Switch {
                    id: switch1
                    x: 58
                    y: 390
                    text: qsTr("Autoconnect")
                    anchors.horizontalCenter: label.horizontalCenter
                }

                Label {
                    id: label
                    x: 63
                    y: 310
                    width: 138
                    height: 19
                    text: qsTr("Stav: ")
                    anchors.horizontalCenter: serverport_label.horizontalCenter
                }


            }

            Item {
                id: mesSetting
                Text {
                    id: text3
                    x: 243
                    y: 8
                    width: 131
                    height: 45
                    color: "#fc0000"
                    text: qsTr("MES Server")
                    anchors.top: parent.top
                    font.pixelSize: 25
                    anchors.topMargin: 8
                }
            }

        }

        PageIndicator {
            id: pageIndicator
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            count: settingsView.count
            currentIndex: settingsView.currentIndex

        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:1024;width:600}D{i:5}D{i:3}
}
##^##*/
