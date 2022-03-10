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

        Button {
            id: button
            x: 180
            y: 164
            text: qsTr("Connect")
        }

        Button {
            id: button1
            x: 366
            y: 164
            text: qsTr("setting")
            onClicked: {
                stackView.push(Qt.resolvedUrl("Settings.qml"))
            }
        }

        Button {
            id: button2
            x: 587
            y: 164
            text: qsTr("Control")
            onClicked: {
                stackView.push(Qt.resolvedUrl("Control.qml"))
            }
        }
        Button {
            id: button3
            x: 180
            y: 286
            text: qsTr("Temperature")
            onClicked: {
                stackView.push(Qt.resolvedUrl("Temperature.qml"))
            }
        }

        Button {
            id: button4
            x: 366
            y: 286
            text: qsTr("Print")
            onClicked: {
                stackView.push(Qt.resolvedUrl("Print.qml"))
            }
        }

        Button {
            id: button5
            x: 587
            y: 286
            text: qsTr("Exit")
            onClicked: mainWindow.close()
        }

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
