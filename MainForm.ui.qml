import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1

Item {
    id: item1
    anchors.fill: parent

    property alias word: label1
    property alias button: button
    property alias bLogin: bLogin
    property alias userName: textField3
    property alias userPassword: textField2
    property alias userStatus: userStatus
    property alias input: textField1
    property string wordColor: "lightgreen"

    ColumnLayout {
        id: columnLayout1
        width: parent.width
        height: parent.height

        Item {
            id: item2
            width: parent.width
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

            ProgressBar {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                indeterminate: true
                visible: label1.text ? false : true
            }

            Label {
                id: label1
                text: qsTr("")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                visible: text ? true : false
                font.pointSize: 14
            }
        }

        Item {
            width: parent.width
            Layout.fillWidth: true

            TextField {
                id: textField1
                style: TextFieldStyle {
                    textColor: "black"
                    background: Rectangle {
                        radius: 2
                        color: wordColor
                        implicitWidth: 100
                        implicitHeight: 24
                        border.color: "#333"
                        border.width: 1
                    }
                }

                onAccepted: saveAssociation.clicked
                focus: true
                KeyNavigation.tab: textField3

                anchors.right: saveAssociation.left
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 30
            }

            Button {
                id: saveAssociation
                height: textField1.height
                text: qsTr("Save Association")
                anchors.right: button.left
                anchors.rightMargin: 10
            }

            Button {
                id: button
                height: textField1.height
                text: qsTr("Next Word")
                anchors.right: parent.right
                anchors.rightMargin: 30
            }
        }
    }

    Button {
        id: bLogin
        KeyNavigation.tab: textField1
        anchors.right: parent.right
        anchors.top: parent.top
        text: qsTr("Login")
    }

    TextField {
        id: textField2
        text: ""
        KeyNavigation.tab: bLogin
        onAccepted: bLogin.clicked
        echoMode: 2
        anchors.right: bLogin.left
        placeholderText: qsTr("Password")
    }

    TextField {
        id: textField3
        text: ""
        KeyNavigation.tab: textField2
        onAccepted: bLogin.clicked
        anchors.right: textField2.left
        placeholderText: qsTr("Username")
    }

    Rectangle {
        id: userStatus
        anchors.top: parent.top
        anchors.left: parent.left
        width: 50
        height: 50
        color: "blue"
    }
}


