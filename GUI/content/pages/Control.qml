import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
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
            x: 467
            y: 833
            width: 94
            height: 60
            text: qsTr(range.value+" mm")

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
            x: 63
            y: 534
            width: 70
            height: 48
            text: qsTr("Home")
            onClicked: {
                backend.send_home_command("all")
            }
        }

        Button {
            id: home_x
            x: 63
            y: 588
            width: 70
            height: 48
            text: qsTr("Home X")
            onClicked: {
                backend.send_home_command("X")
            }
        }

        Button {
            id: home_y
            x: 65
            y: 642
            width: 70
            height: 48
            text: qsTr("Home Y")
            onClicked: {
                backend.send_home_command("Y")
            }
        }

        Button {
            id: home_z
            x: 65
            y: 696
            width: 70
            height: 48
            text: qsTr("Home Z")
            onClicked: {
                backend.send_home_command("Z")
            }
        }

        Rectangle {
            id: axis_controller
            x: 38
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
            x: 346
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

        Rectangle {
            id: e_axis_controller
            x: 478
            y: 178
            width: 95
            height: 275
            color: "#b32e452b"
            radius: 30
            border.width: 2

            Button {
                id: eplus
                x: 13
                y: 32
                width: 70
                height: 60
                text: qsTr("E+")
                onClicked: {
                    backend.send_move_command("E",range.value)
                }
            }

            Button {
                id: eminus
                x: 13
                y: 187
                width: 70
                height: 60
                text: qsTr("E-")
                onClicked: {
                    backend.send_move_command("E",-range.value)
                }
            }
        }

        Rectangle {
            id: feedrate_controller
            x: 174
            y: 500
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
                anchors.topMargin: 8
                anchors.leftMargin: 26
            }
        }
        Button {
            id: fan_button
            x: 187
            y: 642
            text: (back.fan_state)? qsTr("OFF") : qsTr("ON")
            onClicked: {
                back.fan_state = !back.fan_state
                if (back.fan_state){
                    backend.fan_rate_change(back.fan_rate)
                }
            }
        }

        Rectangle {
            id: fan_controller
            x: 257
            y: 618
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
                anchors.topMargin: 8
                anchors.leftMargin: 26
            }
        }

        Button {
            id: motor_button
            x: 69
            y: 819
            text: (back.motor_state)? qsTr("OFF") : qsTr("ON")
            onClicked: {
                back.motor_state = !back.motor_state
                backend.motor_state_change(back.motor_state)
            }

        }


    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.25;height:1024;width:600}
}
##^##*/
