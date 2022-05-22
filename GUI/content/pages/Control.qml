import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
    id: control_item
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


        Label {
            id: x_label
            color: "#000000"
            text: qsTr("X: "+ back.positions[0])
            anchors.left: parent.left
            anchors.top: parent.top
            font.pointSize: 14
            anchors.topMargin: 33
            anchors.leftMargin: 40
        }

        Label {
            id: y_label
            color: "#000000"
            text: qsTr("Y: "+ back.positions[1])
            anchors.left: parent.left
            anchors.top: x_label.bottom
            font.pointSize: 14
            anchors.leftMargin: 40
            anchors.topMargin: 14
        }

        Label {
            id: z_label
            color: "#000000"
            text: qsTr("Z: "+ back.positions[2])
            anchors.left: parent.left
            anchors.top: y_label.bottom
            font.pointSize: 14
            anchors.topMargin: 14
            anchors.leftMargin: 40
        }

        Button {
            id: range
            x: 466
            y: 703
            width: 108
            height: 60
            text: qsTr(range.value+" mm")
            font.pointSize: 15

            property var range_list: [0.1,1,5,10]
            property int range_current: 0

            property double value: range.range_list[range.range_current]


            onClicked: {
                range.range_current = range.range_current + 1
                if (range.range_current >= range.range_list.length){
                    range.range_current = 0
                }

            }

        }

        Button {
            id: home
            x: 45
            y: 453
            width: 70
            height: 48
            text: qsTr("Home")
            font.pointSize: 14
            onClicked: {
                backend.send_home_command("all")
            }
        }

        Button {
            id: home_x
            x: 45
            y: 507
            width: 88
            height: 48
            text: qsTr("Home X")
            font.pointSize: 14
            onClicked: {
                backend.send_home_command("X")
            }
        }

        Button {
            id: home_y
            x: 47
            y: 561
            width: 86
            height: 48
            text: qsTr("Home Y")
            font.pointSize: 14
            onClicked: {
                backend.send_home_command("Y")
            }
        }

        Button {
            id: home_z
            x: 47
            y: 615
            width: 86
            height: 48
            text: qsTr("Home Z")
            font.pointSize: 14
            onClicked: {
                backend.send_home_command("Z")
            }
        }

        Rectangle {
            id: axis_controller
            y: 142
            width: 275
            height: 275
            color: "#b32e452b"
            radius: 30
            border.width: 2
            anchors.left: parent.left
            anchors.leftMargin: 40

            Button {
                id: yplus
                width: 75
                height: 75
                text: qsTr("Y+")
                font.pointSize: 15
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
                font.pointSize: 15
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
                font.pointSize: 15
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
                font.pointSize: 15
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
            y: 142
            width: 95
            height: 275
            color: "#b32e452b"
            radius: 30
            border.width: 2
            anchors.left: axis_controller.right
            anchors.leftMargin: 25

            Button {
                id: zplus
                width: 70
                height: 60
                text: qsTr("Z+")
                font.pointSize: 15
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
                font.pointSize: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 25
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    backend.send_move_command("Z",-range.value)
                }
            }
        }

        Rectangle {
            id: e_axis_controller
            y: 142
            height: 275
            color: "#b32e452b"
            radius: 30
            border.width: 2
            anchors.left: z_axis_controller.right
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.leftMargin: 25

            Button {
                id: eplus
                x: 17
                y: 25
                width: 70
                height: 60
                font.pointSize: 15
                text: qsTr("E+")
                onClicked: {
                    backend.send_move_command("E",range.value)
                }
            }

            Button {
                id: eminus
                x: 18
                y: 194
                width: 70
                height: 60
                font.pointSize: 15
                text: qsTr("E-")
                onClicked: {
                    backend.send_move_command("E",-range.value)
                }
            }
        }

        Rectangle {
            id: feedrate_controller
            x: 216
            y: 451
            width: 370
            height: 97
            color: "#b32e452b"
            radius: 30
            border.width: 2

            Slider {
                id: feedrate_slider
                anchors.fill: parent
                anchors.rightMargin: 15
                anchors.leftMargin: 15
                anchors.topMargin: 35
                value: back.flow_rate
                to: 200
                from: 25
                stepSize: 1
                onMoved:{
                    back.flow_rate = feedrate_slider.value
                    backend.flow_rate_change(back.flow_rate)
                }
            }

            Label {
                id: feedrate_label
                width: 161
                height: 27
                text: qsTr("Feedrate: "+feedrate_slider.value+"%")
                anchors.left: parent.left
                anchors.top: parent.top
                font.pointSize: 15
                anchors.topMargin: 8
                anchors.leftMargin: 26
            }
        }
        Button {
            id: fan_button
            x: 195
            y: 601
            text: (back.fan_state)? qsTr("OFF") : qsTr("ON")
            font.pointSize: 15
            onClicked: {
                back.fan_state = !back.fan_state
                if (back.fan_state){
                    backend.fan_rate_change(back.fan_rate)
                }
                else{
                    backend.fan_rate_change(-1)
                }
            }
        }

        Rectangle {
            id: fan_controller
            x: 299
            y: 582
            width: 287
            height: 97
            color: "#b32e452b"
            radius: 30
            border.width: 2
            Slider {
                id: fan_slider
                anchors.fill: parent
                anchors.rightMargin: 15
                anchors.topMargin: 35
                value: back.fan_rate
                anchors.leftMargin: 15
                to: 100
                from: 0
                stepSize: 1
                onMoved:{
                    back.fan_rate = fan_slider.value
                    if (back.fan_state){
                        backend.fan_rate_change(back.fan_rate)
                    }
                }
            }

            Label {
                id: fan_label
                width: 161
                height: 27
                text: qsTr("Fan: "+fan_slider.value+"%")
                anchors.left: parent.left
                anchors.top: parent.top
                font.pointSize: 15
                anchors.topMargin: 8
                anchors.leftMargin: 26
            }
        }

        Button {
            id: motor_button
            x: 40
            y: 754
            text: "OFF"
            font.pointSize: 15
            onClicked: {
                backend.motor_off()
            }

        }

        TextField {
            id: command_field
            x: 179
            y: 70
            width: 294
            height: 42
            placeholderText: qsTr("Text Field")
        }

        Button {
            id: send_button
            x: 488
            y: 64
            text: qsTr("Send")
            onClicked: {
                if (command_field.text != ""){
                    backend.printer_send_command(command_field.text)
                    command_field.clear()
                }
            }
        }

        Label {
            id: motor_state_label
            x: 41
            y: 731
            width: 112
            height: 24
            text: qsTr("Motor state:")
            font.pointSize: 15
        }

        Label {
            id: fan_state_label
            x: 195
            y: 578
            width: 98
            height: 25
            text: qsTr("Fan state:")
            font.pointSize: 15
        }



    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:1024;width:600}
}
##^##*/
