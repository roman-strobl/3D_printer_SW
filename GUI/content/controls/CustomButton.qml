import QtQuick 2.15
import QtQuick.Controls 2.15

Button{
    id: btnToggle
    implicitWidth: 70
    implicitHeight: 60

    background: Rectangle{
        id: bgBtn
        color: "#f62323"
    }

    onClicked: {
        stackView.push(Qt.resolvedUrl("../pages/MainMenu.qml"))
    }
}
