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
            y: 547
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
        }

        Rectangle{
            id: settings_view
            color: "#00ffffff"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: customButton.top
            anchors.topMargin: 0
            anchors.bottomMargin: 1
            anchors.rightMargin: 0
            anchors.leftMargin: 0


            Button {
                id: button6
                x: 440
                y: 562
                width: 70
                height: 60
                text: qsTr("E+")
                onClicked: {
                    backend.send_move_command("E",range.value)
                }
            }

            Button {
                id: button7
                x: 303
                y: 562
                width: 70
                height: 60
                text: qsTr("E-")
                onClicked: {
                    backend.send_move_command("E",-range.value)
                }
            }

            Label {
                id: x_label
                color: "#ffffff"
                text: qsTr("X: "+ back.positions[0])
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 33
                anchors.leftMargin: 64
            }

            Label {
                id: y_label
                color: "#ffffff"
                text: qsTr("Y: "+ back.positions[1])
                anchors.left: parent.left
                anchors.top: x_label.bottom
                anchors.leftMargin: 64
                anchors.topMargin: 14
            }

            Label {
                id: z_label
                color: "#ffffff"
                text: qsTr("Z: "+ back.positions[2])
                anchors.left: parent.left
                anchors.top: y_label.bottom
                anchors.topMargin: 14
                anchors.leftMargin: 64
            }

            Button {
                id: range
                x: 902
                y: 433
                width: 70
                height: 60

                property var range_list: [1,5,10]
                property int range_current: 0

                property int value: range.range_list[range.range_current]

                text: qsTr(range.value+" mm")

                onClicked: {
                    range.range_current = range.range_current + 1
                    if (range.range_current >= 3){
                        range.range_current = 0
                    }

                }

            }

            Button {
                id: home
                x: 64
                y: 562
                width: 70
                height: 48
                text: qsTr("Home")
                onClicked: {
                    backend.send_home_command("all")
                }
            }

            Button {
                id: home_x
                x: 64
                y: 642
                width: 70
                height: 48
                text: qsTr("Home X")
                onClicked: {
                    backend.send_home_command("X")
                }
            }

            Button {
                id: home_y
                x: 64
                y: 723
                width: 70
                height: 48
                text: qsTr("Home Y")
                onClicked: {
                    backend.send_home_command("Y")
                }
            }

            Button {
                id: home_z
                x: 64
                y: 800
                width: 70
                height: 48
                text: qsTr("Home Z")
                onClicked: {
                    backend.send_home_command("Z")
                }
            }

            Rectangle {
                id: axis_controller
                x: 64
                y: 178
                width: 275
                height: 275
                color: "#b32e452b"
                radius: 30
                border.width: 2

                Button {
                    id: yplus
                    width: 75
                    height: 75
                    text: qsTr("Y+")
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        backend.send_move_command("Y",range.value)
                    }
                }

                Button {
                    id: xminus
                    width: 75
                    height: 75
                    text: qsTr("X-")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    onClicked: {
                        backend.send_move_command("X",-range.value)
                    }
                }

                Button {
                    id: yminus
                    y: 205
                    width: 75
                    height: 75
                    text: qsTr("Y-")
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 10
                    onClicked: {
                        backend.send_move_command("Y",-range.value)
                    }
                }

                Button {
                    id: xplus
                    x: 204
                    width: 75
                    height: 75
                    text: qsTr("X+")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    clip: false
                    transformOrigin: Item.Center
                    onClicked: {
                        backend.send_move_command("X",range.value)
                    }
                }
            }

            Rectangle {
                id: z_axis_controller
                x: 428
                y: 178
                width: 95
                height: 275
                color: "#b32e452b"
                radius: 30
                border.width: 2

                Button {
                    id: zplus
                    width: 70
                    height: 60
                    text: qsTr("Z+")
                    anchors.top: parent.top
                    anchors.topMargin: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        backend.send_move_command("Z",range.value)
                    }
                }

                Button {
                    id: zminus
                    y: 198
                    width: 70
                    height: 60
                    text: qsTr("Z-")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        backend.send_move_command("Z",-range.value)
                    }
                }
            }


        }
    }

    /*SwipeView {
            id: settingsView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: pageIndicator.bottom
            anchors.bottom: customButton.top
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            currentIndex: 0

            Item {
                id: printerSetting

                Button {
                    id: button
                    x: 158
                    y: 174
                    width: 70
                    height: 60
                    text: qsTr("Y+")
                    onClicked: {
                    backend.send_move_command("Y",range.value)
                    }
                }

                Button {
                    id: button1
                    x: 70
                    y: 261
                    width: 70
                    height: 60
                    text: qsTr("X-")
                    onClicked: {
                    backend.send_move_command("X",-range.value)
                    }
                }

                Button {
                    id: button2
                    x: 158
                    y: 358
                    width: 70
                    height: 60
                    text: qsTr("Y-")
                    onClicked: {
                    backend.send_move_command("Y",-range.value)
                    }
                }

                Button {
                    id: button3
                    x: 246
                    y: 261
                    width: 70
                    height: 60
                    text: qsTr("X+")
                    clip: false
                    transformOrigin: Item.Center
                    onClicked: {
                    backend.send_move_command("X",range.value)
                    }
                }

                Button {
                    id: button4
                    x: 345
                    y: 174
                    width: 70
                    height: 60
                    text: qsTr("Z+")
                    onClicked: {
                    backend.send_move_command("Z",range.value)
                    }
                }

                Button {
                    id: button5
                    x: 345
                    y: 358
                    width: 70
                    height: 60
                    text: qsTr("Z-")
                    onClicked: {
                    backend.send_move_command("Z",-range.value)
                    }
                }

                Button {
                    id: button6
                    x: 477
                    y: 174
                    width: 70
                    height: 60
                    text: qsTr("E+")
                }

                Button {
                    id: button7
                    x: 477
                    y: 358
                    width: 70
                    height: 60
                    text: qsTr("E-")
                }

                Label {
                    id: label
                    text: qsTr("X: "+ back.positions[0])
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.leftMargin: 10
                }

                Label {
                    id: label1
                    text: qsTr("Y: "+ back.positions[1])
                    anchors.left: parent.left
                    anchors.top: label.bottom
                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                }

                Label {
                    id: label2
                    text: qsTr("Z: "+ back.positions[2])
                    anchors.left: parent.left
                    anchors.top: label1.bottom
                    anchors.topMargin: 10
                    anchors.leftMargin: 10
                }

                Button {
                    id: range
                    x: 902
                    y: 433
                    width: 70
                    height: 60

                    property var range_list: [1,5,10]
                    property int range_current: 0

                    property int value: range.range_list[range.range_current]

                    text: qsTr(range.value+" mm")

                    onClicked: {
                        range.range_current = range.range_current + 1
                        if (range.range_current >= 3){
                            range.range_current = 0
                        }

                    }

                }

                Button {
                    id: home
                    x: 692
                    y: 174
                    width: 70
                    height: 48
                    text: qsTr("Home")
                }

                Button {
                    id: home_x
                    x: 692
                    y: 239
                    width: 70
                    height: 48
                    text: qsTr("Home X")
                }

                Button {
                    id: home_y
                    x: 692
                    y: 306
                    width: 70
                    height: 48
                    text: qsTr("Home Y")
                }

                Button {
                    id: home_z
                    x: 692
                    y: 370
                    width: 70
                    height: 48
                    text: qsTr("Home Z")
                }


            }

            Item {
                id: temperature_settings

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
                    width: 200
                    height: 70
                    value: back.chamber_target_temperature
                    from: 0
                    to: back.chamber_max_temperature
                    stepSize: 1

                }

                Slider {
                    id: bed
                    x: 96
                    y: 182
                    width: 200
                    height: 70
                    value: back.bed_target_temperature
                    from: 0
                    to: back.bed_max_temperature
                    stepSize: 1
                }

                Slider {
                    id: extruder
                    x: 96
                    y: 85
                    width: 200
                    height: 70
                    value: back.extruder_target_temperature[0]
                    from: 0
                    to: back.extruder_max_temperature[0]
                    stepSize: 1
                }

                Label {
                    id: extruder_temp
                    x: 264
                    y: 49
                    text: qsTr(back.extruder_temperature[0] +"/"+ extruder.value+" °C")
                }

                Label {
                    id: bed_temp
                    x: 264
                    y: 157
                    text: qsTr(back.bed_temperature +"/"+ bed.value+" °C")
                }

                Label {
                    id: chamber_temp
                    x: 264
                    y: 251
                    text: qsTr(back.chamber_temperature +"/"+ chamber.value+" °C")
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
    }*/
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:1024;width:600}D{i:15}D{i:16}D{i:17}D{i:18}D{i:20}D{i:21}
}
##^##*/
