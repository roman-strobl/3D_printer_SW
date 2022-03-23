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
            anchors.bottomMargin: 4
            anchors.leftMargin: 4
        }

        SwipeView {
            id: settingsView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: pageIndicator.bottom
            anchors.bottom: customButton.top
            anchors.bottomMargin: 10
            anchors.topMargin: 10
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            currentIndex: 0

            Item {
                id: printerSetting

                Column {
                    id: column
                    width: 301
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 50
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                }

                Label {
                    id: extruders
                    x: 154
                    y: 29
                    color: "#ffffff"
                    text: qsTr("Extruders:")
                    font.bold: true
                    font.pointSize: 16
                }
                Label {
                    id: bed
                    x: 154
                    y: 179
                    color: "#ffffff"
                    text: qsTr("Bed:")
                    font.bold: true
                    font.pointSize: 16
                }
                Label {
                    id: chamber
                    x: 154
                    y: 350
                    color: "#ffffff"
                    text: qsTr("Chamber:")
                    font.bold: true
                    font.pointSize: 16
                }

                Label {
                    id: extruders_temperature
                    x: 160
                    y: 104
                    color: "#ea6060"
                    text: qsTr(back.extruder_temperature[0] +"/"+ back.extruder_target_temperature[0]+" °C")
                    font.pointSize: 16
                }

                Label {
                    id: bed_temperature
                    x: 154
                    y: 261
                    color: "#ea6060"
                    text: qsTr(back.bed_temperature +"/"+ back.bed_target_temperature+" °C")
                    font.pointSize: 16
                }

                Label {
                    id: chamber_temperature
                    x: 154
                    y: 423
                    color: "#ea6060"
                    text: qsTr(back.chamber_temperature +"/"+ back.chamber_target_temperature+" °C")
                    font.pointSize: 16
                }

            }

            Item {
                id: mqttSetting
            }

            Item {
                id: mesSetting
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
    D{i:0;autoSize:true;height:600;width:1024}D{i:5}D{i:3}
}
##^##*/
