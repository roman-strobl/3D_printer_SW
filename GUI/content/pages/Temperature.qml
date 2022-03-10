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
            currentIndex: 0

            Item {
                id: printerSetting
                Label {
                    id: label
                    x: 359
                    y: 161
                    width: 210
                    height: 74
                    color: "#ddff0000"
                    text: qsTr("Temperature")
                    font.pointSize: 21
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
