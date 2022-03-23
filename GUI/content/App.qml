import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    id: mainWindow
    width: 1024
    height: 600
    visible: true
    color: "#2c313c"
    minimumHeight: 480
    maximumHeight: 600
    minimumWidth: 800
    maximumWidth: 1024
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
        anchors.leftMargin: 26
        anchors.topMargin: 15
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

        property string mqtt_ip: ""
        property int mqtt_port: 0

        property var positions: [0,0,0]

        function onGetPorts(port_list){
            back.port_list = port_list
            backend.Debug()
        }
        function onGetBaudrates(baudrate_list){
            back.baudrate_list = baudrate_list
            backend.Debug()
        }
        function onGetPrinterStatus(printer_status){
            back.printer_status = printer_status
            backend.Debug()
        }

        function onGetPort(port){
            back.port = port
        }
        function onGetBaudrate(baudrate){
            back.baudrate = baudrate
        }
        function onGetNumOfExtruders(num_of_extruders){
            back.num_of_extruders = num_of_extruders
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
        function onGetPositions(positions){
            back.positions = positions
        }
        function onGetMQTTIP(mqtt_ip){
            back.mqtt_ip = mqtt_ip
        }
        function onGetMQTTPort(mqtt_port){
            back.mqtt_port = mqtt_port
        }
        function onExtruderTargetTemperature(extruder_target_temperature){
            back.extruder_target_temperature = extruder_target_temperature
        }
        function onGetBedTargetTemperature(bed_target_temperature){
            back.bed_target_temperature = bed_target_temperature
        }
        function onGetChamberTargetTemperature(chamber_target_temperature){
            back.chamber_target_temperature = chamber_target_temperature
        }
    }
    Component.onCompleted: startupFunction();

}
