import QtQuick 2.15
import QtQuick.Controls 2.15

Button{
    id: btnToggle
    implicitWidth: 70
    implicitHeight: 60
    onClicked: {
        stackView.replace(Qt.resolvedUrl("../pages/MainMenu.qml"))
    }
    background: Rectangle {
           implicitWidth: 70
           implicitHeight: 60
           opacity: enabled ? 1 : 0.3
           color: "transparent"
       }

    Image {
        id: home
        x: 0
        y: -6
        width: 70
        height: 72
        source: "../icons/home.png"
        fillMode: Image.PreserveAspectFit
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}
}
##^##*/
