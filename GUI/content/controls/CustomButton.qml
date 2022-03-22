import QtQuick 2.15
import QtQuick.Controls 2.15

Button{
    id: btnToggle
    implicitWidth: 70
    implicitHeight: 60

    icon.name: home
    icon.source: "../icons/icons8-home-b.svg"


    onClicked: {
        stackView.push(Qt.resolvedUrl("../pages/MainMenu.qml"))
    }
}
