import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
    id: settings

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

                Switch {
                    id: switch2
                    x: 407
                    y: 120
                    text: qsTr("Auto connect")
                }

                ToolSeparator {
                    id: toolSeparator
                    x: 30
                    y: 216
                    width: 540
                    height: 12
                }



                Label {
                    id: port_label
                    x: 30
                    y: 72
                    width: 121
                    height: 34
                    text: qsTr("Port:")
                    font.pointSize: 15
                }

                ComboBox {
                    id: port_choice
                    x: 157
                    y: 72
                    width: 164
                    height: 34
                    displayText: back.port
                    wheelEnabled: false
                    clip: false
                    layer.mipmap: false
                    model: back.port_list
                    onActivated: {
                        back.port = back.port_list[index]
                        backend.serial_change_port(back.port)
                    }
                }

                Label {
                    id: baudrate_label
                    x: 30
                    y: 127
                    width: 121
                    height: 33
                    text: qsTr("Baudrate:")
                    font.pointSize: 15
                }

                ComboBox {
                    id: baudrate_choice
                    x: 157
                    y: 127
                    width: 164
                    height: 33
                    displayText: back.baudrate
                    model: back.baudrate_list
                    onActivated: {
                        back.baudrate = back.baudrate_list[index]
                        backend.serial_change_baudrate(back.baudrate)
                    }
                }

                Label {
                    id: extruder_num_label
                    x: 30
                    y: 278
                    width: 170
                    height: 33
                    text: qsTr("Num. of extruders:")
                    font.pointSize: 15

                }

                ComboBox {
                    id: extruder_num_choice
                    x: 304
                    y: 278
                    width: 87
                    height: 33
                    displayText: back.num_of_extruders
                    model: [1,2,3,4,5,6,7,8,9,10]
                    /*onActivated: {
                        back.num_of_extruders = back.extruder_num_choice.model[index]
                    }*/
                }

                Label {
                    id: extruder_num_label1
                    x: 30
                    y: 335
                    width: 246
                    height: 33
                    text: qsTr("Max extruder temperature:")
                    font.pointSize: 15
                }

                Slider {
                    id: temp_interval
                    x: 31
                    y: 486
                    value: back.temp_interval
                    from:0
                    to: 60
                    stepSize: 1
                    onMoved:{
                        back.temp_interval = temp_interval.value
                        backend.printer_change_temp_interval_report(back.temp_interval)
                    }
                }

                Slider {
                    id: position_interval
                    x: 335
                    y: 486
                    value: back.position_interval
                    from:0
                    to: 60
                    stepSize: 1
                    onMoved:{
                        back.position_interval = position_interval.value
                        backend.printer_change_position_interval_report(back.position_interval)
                    }
                }

                Label {
                    id: temp_interval_label
                    x: 31
                    y: 449
                    width: 277
                    height: 23
                    text: qsTr("Temperature report interval: " + temp_interval.value + "s")
                    font.pointSize: 14
                }

                Label {
                    id: position_inerval_label
                    x: 335
                    y: 449
                    width: 230
                    height: 23
                    text: qsTr("Position report interval: " + position_interval.value + "s")
                    font.pointSize: 14
                }

                Label {
                    id: extruder_num_label2
                    x: 31
                    y: 390
                    width: 246
                    height: 33
                    text: qsTr("Max bed temperature:")
                    font.pointSize: 15
                }

                TextField {
                    id: extruder_max_temp
                    x: 304
                    y: 331
                    width: 143
                    height: 42
                    visible: true
                    text: back.extruder_max_temperature[0]
                    onEditingFinished:{
                        back.extruder_max_temperature[0] = extruder_max_temp.text
                    }
                }

                TextField {
                    id: bed_max_temp
                    x: 304
                    y: 386
                    width: 143
                    height: 42
                    visible: true
                    text: back.bed_max_temperature
                    onEditingFinished:{
                        back.bed_max_temperature = bed_max_temp.text
                    }
                }

                ToolSeparator {
                    id: toolSeparator1
                    x: 30
                    y: 557
                    width: 540
                    height: 12
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
                    id: mqtt_ip_label
                    x: 71
                    y: 92
                    width: 121
                    height: 34
                    text: qsTr("IP address:")
                    font.pointSize: 15
                }

                Label {
                    id: mqtt_serverport_label
                    x: 71
                    y: 186
                    width: 121
                    height: 33
                    text: qsTr("Port:")
                    font.pointSize: 15
                }

                TextField {
                    id: mqtt_ip_textField
                    x: 46
                    y: 92
                    width: 139
                    height: 42
                    enabled: !back.mqtt_status
                    anchors.top: mqtt_ip_label.top
                    hoverEnabled: true
                    anchors.topMargin: -3
                    anchors.horizontalCenterOffset: 159
                    anchors.horizontalCenter: mqtt_serverport_label.horizontalCenter
                    inputMask: "009.009.000.000;_"
                    text: qsTr(back.mqtt_ip)
                    onEditingFinished:{
                        back.mqtt_ip = mqtt_ip_textField.text
                        backend.mqtt_change_ip(back.mqtt_ip)
                    }
                }

                TextField {
                    id: mqtt_port_textField
                    x: 46
                    y: 187
                    width: 143
                    height: 42
                    enabled: !back.mqtt_status
                    anchors.verticalCenter: mqtt_serverport_label.verticalCenter
                    anchors.left: mqtt_ip_textField.left
                    anchors.bottom: mqtt_serverport_label.bottom
                    transformOrigin: Item.Center
                    anchors.verticalCenterOffset: 0
                    anchors.bottomMargin: -5
                    anchors.leftMargin: 0
                    text: back.mqtt_port
                    onEditingFinished:{
                        back.mqtt_port = mqtt_port_textField.text
                        backend.mqtt_change_port(back.mqtt_port)
                    }
                }

                Switch {
                    id: mqtt_auto_connect
                    x: 58
                    y: 348
                    checked: back.mqtt_auto_connect
                    text: qsTr("Autoconnect")
                    anchors.horizontalCenterOffset: -18
                    anchors.horizontalCenter: label.horizontalCenter
                    onClicked: {
                        back.mqtt_auto_connect = mqtt_auto_connect.checked
                        backend.mqtt_auto_connect(back.mqtt_auto_connect)
                    }

                }

                Label {
                    id: mqtt_status
                    x: 63
                    y: 286
                    width: 176
                    height: 25
                    text: qsTr("Status: " + (back.mqtt_status ? "Connected" : "Disconnected"))
                    font.pointSize: 15
                    anchors.horizontalCenterOffset: 27
                    anchors.horizontalCenter: mqtt_serverport_label.horizontalCenter
                }

                Button {
                    id: mqtt_connection_button
                    x: 426
                    y: 348
                    width: 133
                    height: 48
                    text: qsTr(back.mqtt_status ? "Disconnect" : "Connect")
                    onClicked: {
                        if(back.mqtt_status){
                            backend.mqtt_disconnect()
                        }
                        else{
                            backend.mqtt_connect()
                        }

                    }
                }

                ToolSeparator {
                    id: toolSeparator2
                    x: 30
                    y: 432
                    width: 540
                    height: 12
                }

                Label {
                    id: label3
                    x: 275
                    y: 458
                    text: qsTr("MES")
                }

                Label {
                    id: mes_ip_label
                    x: 71
                    y: 513
                    width: 121
                    height: 34
                    text: qsTr("IP address:")
                    font.pointSize: 15
                }

                Label {
                    id: mes_port_label
                    x: 71
                    y: 560
                    width: 121
                    height: 33
                    visible: true
                    text: qsTr("Port:")
                    font.pointSize: 15
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
    D{i:0;autoSize:true;height:1024;width:600}D{i:20}D{i:21}
}
##^##*/
