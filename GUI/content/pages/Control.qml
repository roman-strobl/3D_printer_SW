import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
    Rectangle {
        id: menu_view
        color: "#2c313c"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: -6
        anchors.leftMargin: 0
        anchors.topMargin: 0
        visible: true

        CustomButton {
            id: customButton
            x: 0
            y: 430
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

                Button {
                    id: button
                    x: 158
                    y: 68
                    text: qsTr("Y+")
                }

                Button {
                    id: button1
                    x: 76
                    y: 144
                    text: qsTr("X-")
                }

                Button {
                    id: button2
                    x: 158
                    y: 231
                    text: qsTr("Y-")
                }

                Button {
                    id: button3
                    x: 242
                    y: 144
                    text: qsTr("X+")
                }

                Button {
                    id: button4
                    x: 365
                    y: 77
                    text: qsTr("Z+")
                }

                Button {
                    id: button5
                    x: 365
                    y: 231
                    text: qsTr("Z-")
                }

                Button {
                    id: button6
                    x: 531
                    y: 77
                    text: qsTr("E+")
                }

                Button {
                    id: button7
                    x: 531
                    y: 231
                    text: qsTr("E-")
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
                    id: extruder_label
                    x: 98
                    y: 49
                    text: qsTr("Extruder")
                }

                Label {
                    id: bed_label
                    x: 96
                    y: 150
                    text: qsTr("Bed")
                }

                Label {
                    id: chamber_label
                    x: 96
                    y: 251
                    text: qsTr("Chamber")
                }

                Slider {
                    id: chamber
                    x: 96
                    y: 285
                    value: 0.5
                    from: 0
                    to:60
                    stepSize: 1
                }

                Slider {
                    id: bed
                    x: 96
                    y: 182
                    value: 0.5
                    from: 0
                    to: 100
                    stepSize: 1
                }

                Slider {
                    id: extruder
                    x: 96
                    y: 85
                    value: 0.5
                    from: 0
                    to: 250
                    stepSize: 1
                }

                Label {
                    id: extruder_temp
                    x: 264
                    y: 49
                    text: qsTr(extruder.value + " °C")
                }

                Label {
                    id: bed_temp
                    x: 264
                    y: 157
                    text: qsTr(bed.value + " °C")
                }

                Label {
                    id: chamber_temp
                    x: 264
                    y: 251
                    text: qsTr(chamber.value + " °C")
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
