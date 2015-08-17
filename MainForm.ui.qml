import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1

Item {
    id: item1
    anchors.fill: parent

    property alias word: label1
    property alias statusMessage: statusMessage
    property alias bNextWord: nextWord
    property alias bLogin: bLogin
    property alias bAsso: saveAssociation
    property alias userName: textUsername
    property alias userPassword: textPassword
    property alias input: textWord
    property string wordColor: "lightgreen"
    property bool loggedOut: true

    Image {
        source: "qrc:images/tima.svg"
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        visible: loggedOut
    }

    ColumnLayout {
        id: columnLayout1
        width: parent.width
        height: parent.height
        visible: !loggedOut

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

            Text {
                id: statusMessage
                text: qsTr("")
                color: "red"
                anchors.bottom: label1.top
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                visible: text ? true : false
                font.pointSize: 16
                wrapMode: Text.Wrap
                elide: Text.ElideMiddle
                horizontalAlignment: Text.AlignHCenter
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
                    id: textWord
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
                    KeyNavigation.tab: textUsername
                }

                Button {
                    id: saveAssociation
                    height: textWord.height
                    text: qsTr("Save Association")
                }

                Button {
                    id: nextWord
                    height: textWord.height
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
        id: textPassword
        text: ""
        KeyNavigation.tab: textWord
        echoMode: 2
        anchors.right: bLogin.left
        placeholderText: qsTr("Password")
    }

    TextField {
        id: textUsername
        text: ""
        focus: true
        KeyNavigation.tab: textPassword
        anchors.right: textPassword.left
        placeholderText: qsTr("Username")
    }
}


