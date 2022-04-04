/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt Quick Studio Components.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: mainWindow
    width: 600
    height: 1024
    visible: true
    color: "#2c313c"
    minimumHeight: 800
    maximumHeight: 1024
    minimumWidth: 480
    maximumWidth: 600
    title: "GUI_Printer"

    flags: Qt.Window | Qt.FramelessWindowHint

    function startupFunction() {
            backend.Init()
        }

    Rectangle {
        id: contentpage
        color: "#2c313c"
        anchors.fill: parent
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 40


        StackView {
            id: stackView
            anchors.fill: parent
            wheelEnabled: false
            initialItem:  stackView.push(Qt.resolvedUrl("pages/MainMenu.qml"))
        }

    }

    Label {
        id: label
        width: 67
        height: 19
        text: if(back.printer_status){qsTr("Connect")} else{qsTr("Disconnect")}
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 16
        anchors.topMargin: 10
    }
    Connections{
        id:back

        target: backend

        property string port: ""
        property var port_list: []

        property int baudrate: 0
        property var baudrate_list: []

        property bool printer_status: false

        property int num_of_extruders: 1

        property bool bed_status: true
        property bool chamber_status: false

        property var extruder_max_temperature: [0]
        property int bed_max_temperature: 0
        property int chamber_max_temperature:0

        property var extruder_target_temperature: [0]
        property var extruder_temperature: [0]

        property int bed_target_temperature: 0
        property int bed_temperature: 0

        property int chamber_target_temperature: 0
        property int chamber_temperature: 0


        property var positions: [0,0,0]


        property int temp_interval: 4
        property int position_interval: 1

        //-------------MQTT_modul-----------------------

        property string mqtt_ip: ""
        property int mqtt_port: 0
        property bool mqtt_status: false
        property bool mqtt_auto_connect: false



        function onGetPorts(port_list){
            back.port_list = port_list
        }
        function onGetBaudrates(baudrate_list){
            back.baudrate_list = baudrate_list
        }
        function onGetPrinterStatus(printer_status){
            back.printer_status = printer_status
        }
        function onGetPort(port){
            back.port = port
        }
        function onGetBaudrate(baudrate){
            back.baudrate = baudrate
        }
        function onGetPrinter_temp_interval(interval){
            back.temp_interval = interval
        }
        function onGetPrinter_position_interval(interval){
            back.position_interval = interval
        }
        function onGetNumOfExtruders(num_of_extruders){
            back.num_of_extruders = num_of_extruders
        }
        function onGetPositions(positions){
            back.positions = positions
        }
        function onGetBedStatus(bed_status){
            back.bed_status = bed_status
        }
        function onGetChamberStatus(chamber_status){
            back.chamber_status = chamber_status
        }
        function onGetExtruderMaxTemperature(extruder_max_temperature){
            back.extruder_max_temperature = extruder_max_temperature
        }
        function onGetBedMaxTemperature(bed_max_temperature){
            back.bed_max_temperature = bed_max_temperature
        }
        function onGetChamberMaxTemperature(chamber_max_temperature){
            back.chamber_max_temperature = chamber_max_temperature
        }
        function onGetExtruderTemperature(extruder_temperature){
            back.extruder_temperature = extruder_temperature
        }
        function onGetBedTemperature(bed_temperature){
            back.bed_temperature = bed_temperature
        }
        function onGetChamberTemperature(chamber_temperature){
            back.chamber_temperature = chamber_temperature
        }

        function onGetExtruderTargetTemperature(extruder_target_temperature){
            back.extruder_target_temperature = extruder_target_temperature
        }
        function onGetBedTargetTemperature(bed_target_temperature){
            back.bed_target_temperature = bed_target_temperature
        }
        function onGetChamberTargetTemperature(chamber_target_temperature){
            back.chamber_target_temperature = chamber_target_temperature
        }

        //---------------MQTT-modul-------------------
        function onGetMQTTIP(mqtt_ip){
            back.mqtt_ip = mqtt_ip
        }
        function onGetMQTTPort(mqtt_port){
            back.mqtt_port = mqtt_port
        }
        function onGetMQTT_status(mqtt_status){
            back.mqtt_status = mqtt_status
        }
        function onGetMQTT_auto_connect(mqtt_auto_connect){
            back.mqtt_auto_connect = mqtt_auto_connect
        }


    }
    Component.onCompleted: startupFunction();

}






