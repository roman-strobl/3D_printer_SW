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
            x: 0
            y: 420
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

                Button {
                    id: button
                    x: 158
                    y: 68
                    text: qsTr("Button")
                }

                Button {
                    id: button1
                    x: 76
                    y: 144
                    text: qsTr("Button")
                }

                Button {
                    id: button2
                    x: 158
                    y: 231
                    text: qsTr("Button")
                }

                Button {
                    id: button3
                    x: 242
                    y: 144
                    text: qsTr("Button")
                }

                Button {
                    id: button4
                    x: 365
                    y: 77
                    text: qsTr("Button")
                }

                Button {
                    id: button5
                    x: 365
                    y: 231
                    text: qsTr("Button")
                }

                Button {
                    id: button6
                    x: 531
                    y: 77
                    text: qsTr("Button")
                }

                Button {
                    id: button7
                    x: 531
                    y: 231
                    text: qsTr("Button")
                }

                Label {
                    id: label
                    x: 13
                    y: 8
                    text: qsTr("X: ")
                }

                Label {
                    id: label1
                    x: 13
                    y: 33
                    text: qsTr("Y:")
                }

                Label {
                    id: label2
                    x: 13
                    y: 58
                    text: qsTr("Z:")
                }


            }

            Item {
                id: mqttSetting

                Label {
                    id: label3
                    x: 69
                    y: 57
                    text: qsTr("Label")
                }

                Label {
                    id: label4
                    x: 69
                    y: 139
                    text: qsTr("Label")
                }

                Label {
                    id: label5
                    x: 69
                    y: 222
                    text: qsTr("Label")
                }

                Slider {
                    id: slider
                    x: 96
                    y: 261
                    value: 0.5
                }

                Slider {
                    id: slider1
                    x: 96
                    y: 171
                    value: 0.5
                }

                Slider {
                    id: slider2
                    x: 96
                    y: 85
                    value: 0.5
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
