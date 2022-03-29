import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: rectangle
    width: 300
    height: 150
    color: "#00ffffff"
    radius: 0
    border.width: 2

    property string name: ""
    property string tool: ""
    property int real_tempetature: 0
    property int target_temperature: 0
    property int max_temperature: 0

    Label {
        id: temp_label
        color: "#ffffff"
        text: qsTr(name+":")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.leftMargin: 10
        font.pointSize: 16
        font.bold: true
    }

    Label {
        id: temp_value
        color: "#ea6060"
        text: qsTr(real_tempetature + "/" + temp_slider.value + " °C")
        anchors.left: extruder_temp.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.rightMargin: 10
        font.pointSize: 16
    }

    Slider {
        id: temp_slider
        y: 63
        height: 70
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        stepSize: 1
        value: target_temperature
        to: max_temperature
        from: 0
        onMoved:{
        //target_temperature = temp_slider.value
            backend.send_temp_command(rectangle.tool,temp_slider.value)
        }
        handle: Rectangle {
                x: temp_slider.leftPadding + temp_slider.visualPosition * (temp_slider.availableWidth - width)
                y: temp_slider.topPadding + temp_slider.availableHeight / 2 - height / 2
                implicitWidth: 26
                implicitHeight: 26
                radius: 13
                color: temp_slider.pressed ? "#ffd059" : "#fcb603"
                border.color: "#bdbebf"
            }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}
}
##^##*/
