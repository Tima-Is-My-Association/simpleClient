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
        wordColor: loggedIn.active? "lightgreen" : (error_private.active? "red" : (error.active? "red" : "white"))
        bLogin.text: loggedIn.active? "Logout" : (idle_private.active? "Login": "Loading...")
        bLogin.enabled: loggedIn.active? true : (idle_private.active? true: false)
        bAsso.visible: loggedIn.active? true : false
        userName.visible: loggedIn.active? false : true
        userPassword.visible: loggedIn.active? false : true
        input.onAccepted: bAsso.clicked

        StateMachine {
            id: sm_public_api
            running: true
            initialState: idle

            State {
                id: idle

                SignalTransition {
                    targetState: nextWord_api
                    signal: mainForm.button.clicked
                }

                SignalTransition {
                    targetState: nextWord_api
                    signal: saveAssociation_form.saveAsso
                }

                SignalTransition {
                    targetState: isWord_api
                    signal: mainForm.bAsso.clicked
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
                onExited: mainForm.input.text = ''
            }

            State {
                id: isWord_api
                onEntered: {
                    isWord_form.isWordTest(infos.baseUrl, mainForm.input.text, infos.language)
                }
                SignalTransition {
                    targetState: idle
                    signal: isWord_form.isWord
                }
                SignalTransition {
                    targetState: error
                    signal: isWord_form.isWordError
                }
            }

            State {
                id: error

                TimeoutTransition {
                    targetState: idle
                    timeout: 1000
                }

                onEntered: {
                    messageDialog.show("Error happened public")
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

                SignalTransition {
                    targetState: authRequest_api
                    signal: mainForm.bLogin.clicked
                }
            }

            State {
                id: error_private
                TimeoutTransition {
                    targetState: idle_private
                    timeout: 1000
                }
                onEntered: {
                    messageDialog.show("Error happened private")
                }
            }

            State {
                id: authRequest_api
                onEntered: {
                    authRequest_form.doAuthRequest(infos.baseUrl, mainForm.userName.text, infos.client_id)
                }
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

                SignalTransition {
                    targetState: logout_api
                    signal: mainForm.bLogin.clicked
                }
                State {
                    id: loggedIn_idle
                    SignalTransition {
                        targetState: loggedIn_saveAsso
                        signal: isWord_form.isWord
                    }
                    onEntered: {
                        infos.n = (infos.n + 1) % 2147483647 // Workaround to uint32_t
                    }
                }

                State {
                    id: loggedIn_saveAsso
                    onEntered: saveAssociation_form.doSaveAssociation(infos.baseUrl, infos.u, infos.token, infos.n, infos.language, mainForm.word.text, mainForm.input.text)
                    SignalTransition {
                        targetState: loggedIn_idle
                        signal: saveAssociation_form.saveAsso
                    }
                }
            }

            State {
                id: logout_api
                onEntered: {
                    logout_form.doLogout(infos.baseUrl, infos.u, infos.token, infos.n)
                }
                SignalTransition {
                    targetState: idle_private
                    signal: logout_form.logout
                }
                SignalTransition {
                    targetState: error_private
                    signal: logout_form.logoutError
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
                infos.timestamp = JSON.parse(nW)['timestamp']
            }
        }

        Auth {
            id: auth_form
            onAuth: {
                infos.n = JSON.parse(nW)['n']
                infos.u = JSON.parse(nW)['u']
                infos.token = JSON.parse(nW)['token']
            }
        }

        SaveAssociation {
            id: saveAssociation_form
        }

        Logout {
            id: logout_form
        }

        IsWord {
            id: isWord_form
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
