import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQml.StateMachine 1.0

ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 480
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    MainForm {
        id: mainForm
        anchors.fill: parent
        wordColor: loggedIn.active? "lightgreen" : (error_private.active? "red" : "white")

        StateMachine {
            id: sm_public_api
            running: true
            initialState: idle

            State {
                id: idle

                onEntered: {
                    mainForm.button.enabled = true
                }

                SignalTransition {
                    targetState: nextWord_api
                    signal: mainForm.button.clicked
                }

                onExited: {
                    mainForm.button.enabled = false
                }
            }

            State {
                id: nextWord_api
                onEntered: {
                    mainForm.word.text = '' // TODO anderer weg für ladebalken // StateMachine und State wechsel?
                    nextWord_form.getNextWord()
                }
                SignalTransition {
                    targetState: idle
                    signal: nextWord_form.nextWord
                }
                SignalTransition {
                    targetState: error
                    signal: nextWord_form.nextWordError
                }
            }

            State {
                id: error

                TimeoutTransition {
                    targetState: idle
                    timeout: 1000
                }
            }
        }

        StateMachine {
            id: sm_private_api
            running: true
            initialState: idle_private
            AuthInformations {
                id: infos
            }

            State {
                id: idle_private
                onEntered: {
                    mainForm.bLogin.enabled = true
                    mainForm.bLogin.text = 'Login'
                    mainForm.userName.visible = true
                    mainForm.userPassword.visible = true
                }

                SignalTransition {
                    targetState: authRequest_api
                    signal: mainForm.bLogin.clicked
                }
                onExited: {
                    mainForm.bLogin.enabled = false
                    mainForm.userName.visible = false
                    mainForm.userPassword.visible = false
                }
            }

            State {
                id: error_private
                TimeoutTransition {
                    targetState: idle_private
                    timeout: 1000
                }
            }

            State {
                id: authRequest_api
                onEntered: authRequest_form.doAuthRequest(infos.baseUrl, mainForm.userName.text, infos.client_id)
                SignalTransition {
                    targetState: auth_api
                    signal: authRequest_form.authRequest
                }
                SignalTransition {
                    targetState: error_private
                    signal: authRequest_form.authRequestError
                }
            }

            State {
                id: auth_api
                onEntered: auth_form.doAuth(infos.baseUrl, mainForm.userName.text, mainForm.userPassword.text, infos.client_id, infos.client_secret, infos.timestamp)
                SignalTransition {
                    targetState: loggedIn
                    signal: auth_form.auth
                }
                SignalTransition {
                    targetState: error_private
                    signal: auth_form.authError
                }
            }

            State {
                id: loggedIn
                initialState: loggedIn_idle
                onEntered: {
                    mainForm.bLogin.enabled = true
                    mainForm.bLogin.text = 'Logout'
                    infos.n = infos.n + 1
                }
                SignalTransition {
                    targetState: logout
                    signal: mainForm.bLogin.clicked
                }
                State {
                    id: loggedIn_idle
                }

            }

            State {
                id: logout
                onEntered: {
                    logout_form.doLogout(infos.baseUrl, infos.u, infos.token, infos.n)
                }
                SignalTransition {
                    targetState: idle_private
                    signal: logout_form.logout
                }

            }
        }


        NextWord {
            id: nextWord_form
            onNextWord: {
                mainForm.word.text = nW
            }
        }

        AuthRequest {
            id: authRequest_form
            onAuthRequest: {
                mainForm.userStatus.color = 'green'
                infos.timestamp = JSON.parse(nW)['timestamp']
            }
            onAuthRequestError: {
                mainForm.userStatus.color = 'red'
            }
        }

        Auth {
            id: auth_form
            onAuth: {
                mainForm.userStatus.color = 'yellow'
                infos.n = JSON.parse(nW)['n']
                infos.u = JSON.parse(nW)['u']
                infos.token = JSON.parse(nW)['token']
            }
        }

        Logout {
            id: logout_form
        }

        IsWord {
            id: isWord_form
        }




        Component.onCompleted: {
            input.accepted.connect(button.clicked)
            nextWord_form.getNextWord();
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("TIMA WebApplication")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }
}
