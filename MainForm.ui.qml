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
    property alias bAsso: saveAssociation
    property alias userName: textField3
    property alias userPassword: textField2
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

            RowLayout {
                id: rowLayout1
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.right: parent.right
                anchors.rightMargin: 30
                spacing: 10

                TextField {
                    id: textField1
                    Layout.fillWidth: true
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
                    KeyNavigation.tab: textField3
                }

                Button {
                    id: saveAssociation
                    height: textField1.height
                    text: qsTr("Save Association")
                }

                Button {
                    id: button
                    height: textField1.height
                    text: qsTr("Next Word")
                }
            }
        }
    }

    Button {
        id: bLogin
        anchors.right: parent.right
        anchors.top: parent.top
        text: qsTr("Login")
    }

    TextField {
        id: textField2
        text: ""
        KeyNavigation.tab: textField1
        echoMode: 2
        anchors.right: bLogin.left
        placeholderText: qsTr("Password")
    }

    TextField {
        id: textField3
        text: ""
        focus: true
        KeyNavigation.tab: textField2
        anchors.right: textField2.left
        placeholderText: qsTr("Username")
    }

    Component.onCompleted: {
        textField1.accepted.connect(bAsso.clicked)
        textField3.accepted.connect(bLogin.clicked)
        textField2.accepted.connect(bLogin.clicked)
    }
}


