import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
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
        visible: true

        CustomButton {
            id: customButton
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
        }

        Rectangle {
            id: temperatureView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: customButton.top
            anchors.topMargin: 0
            anchors.bottomMargin: 5
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            color:"transparent"

            Column {
                id: column
                anchors.fill: parent
                spacing: 10


                    Temperature_box {
                        id: temperature_box_extruder
                        name: "Extruder"
                        tool: "T"
                        width: 301
                        height: 120
                        visible: true
                        real_tempetature: back.extruder_temperature[0]
                        target_temperature: back.extruder_target_temperature[0]
                        max_temperature: back.extruder_max_temperature[0]

                    }

                    Temperature_box {
                        id: temperature_box_bed
                        name: "Bed"
                        tool: "B"
                        width: 301
                        height: 120
                        visible: back.bed_status
                        real_tempetature: back.bed_temperature
                        target_temperature: back.bed_target_temperature
                        max_temperature: back.bed_max_temperature
                    }

                    Temperature_box {
                        id: temperature_box_chamber
                        name: "Chamber"
                        tool: "C"
                        width: 301
                        height: 120
                        visible: back.chamber_status
                        real_tempetature: back.chamber_temperature
                        max_temperature: back.chamber_max_temperature
                        target_temperature: back.chamber_target_temperature
                    }
            }

        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:974;width:580}D{i:4}D{i:3}
}
##^##*/
