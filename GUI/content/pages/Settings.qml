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
            y: 420
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
        }

        SwipeView {
            id: settingsView
            y: 34
            height: 390
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            currentIndex: 0

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
                    y: 85
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
                    y: 186
                    width: 121
                    height: 33
                    text: qsTr("Baudrate:")
                    font.pointSize: 15
                }

                ComboBox {
                    id: baudrate_choice
                    y: 179
                    anchors.left: baudrate_label.right
                    anchors.leftMargin: 23
                    model: back.baudrate_list
                }

                Button {
                    id: button
                    x: 365
                    y: 290
                    text: qsTr("SAVE")
                    onClicked: {
                        backend.portList("save")
                    }
                }


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
                    id: save_button
                    x: 365
                    y: 290
                    text: qsTr("SAVE")
                }

                TextField {
                    id: textField
                    x: 229
                    y: 180
                    placeholderText: qsTr("Text Field")
                }

                TextField {
                    id: textField1
                    x: 229
                    y: 80
                    placeholderText: qsTr("Text Field")
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
