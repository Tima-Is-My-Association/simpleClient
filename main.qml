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
        wordColor: loggedIn.active? "lightgreen" : (error_private.active? "red" : (error_public.active? "red" : "white"))
        bLogin.text: loggedIn.active? "Logout" : "Login"
        bLogin.enabled: loggedIn.active? true : (loggedOut.active? true: false)
        bAsso.visible: loggedIn.active? true : false
        userName.visible: loggedIn.active? false : true
        userPassword.visible: loggedIn.active? false : true
        input.onAccepted: bAsso.clicked
        loggedOut: !loggedIn.active

        Component.onCompleted: {
            input.accepted.connect(bAsso.clicked)
            userPassword.accepted.connect(bLogin.clicked)
            userName.accepted.connect(bLogin.clicked)
        }

        StateMachine {
            id: sm_api
            running: true
            initialState: loggedOut

            State {
                id: loggedOut
                initialState: idle

                State {
                    id: idle

                    SignalTransition {
                        targetState: authRequest_api
                        signal: mainForm.bLogin.clicked
                    }
                }

                State {
                    id: error_public

                    TimeoutTransition {
                        targetState: loggedOut
                        timeout: 1000
                    }

                    onEntered: {
                        messageDialog.show("Error happened public")
                    }
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
                    targetState: error_public
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
                    targetState: error_public
                    signal: auth_form.authError
                }
            }

            State {
                id: loggedIn
                initialState: success

                AuthInformations {
                    id: infos
                }

                SignalTransition {
                    targetState: logout_api
                    signal: mainForm.bLogin.clicked
                }

                SignalTransition {
                    targetState: error_private
                    signal: isWord_form.isWordError
                }

                State {
                    id: error_private

                    TimeoutTransition {
                        targetState: loggedIn
                        timeout: 1000
                    }

                    onEntered: {
                        messageDialog.show("Error happened public")
                    }
                }

                State {
                    id: loggedIn_idle

                    SignalTransition {
                        targetState: loggedIn_saveAsso
                        signal: isWord_form.isWord
                    }

                    SignalTransition {
                        targetState: unknownWord
                        signal: isWord_form.isWordUnknown
                    }

                    SignalTransition {
                        signal: mainForm.bAsso.clicked
                        onTriggered: isWord_form.isWordTest(infos.baseUrl, mainForm.input.text, infos.language)
                    }

                    SignalTransition {
                        targetState: exclude_word
                        signal: mainForm.bNextWord.clicked
                    }

                    onEntered: mainForm.input.focus = true

                    onExited: mainForm.statusMessage.text = ''
                }

                State {
                    id: success
                    onEntered: {
                        infos.n = (infos.n + 1) % 2147483647 // Workaround to uint32_t
                        isWord_form.lastWord = ''
                    }

                    TimeoutTransition {
                        targetState: nextWord
                        timeout: 10
                    }
                }

                State {
                    id: unknownWord

                    onEntered: mainForm.statusMessage.text = "We have not recognized your input as word. Are you sure you have no spelling mistakes, in order to confirm your input press 'Save Association'"

                    TimeoutTransition {
                        targetState: loggedIn_idle
                        timeout: 500
                    }
                }

                State {
                    id: loggedIn_saveAsso
                    onEntered: saveAssociation_form.doSaveAssociation(infos.baseUrl, infos.u, infos.token, infos.n, infos.language, mainForm.word.text, mainForm.input.text)
                    SignalTransition {
                        targetState: success
                        signal: saveAssociation_form.saveAsso
                    }

                    SignalTransition {
                        targetState: error_private
                        signal: saveAssociation_form.saveAssoError
                    }
                }

                State {
                    id: nextWord
                    onEntered: {
                        mainForm.word.text = '' // TODO anderer weg für ladebalken // StateMachine und State wechsel?
                        nextWord_form.getNextWord()
                    }

                    SignalTransition {
                        targetState: loggedIn_idle
                        signal: nextWord_form.nextWord
                        //TODO exclude word
                    }

                    onExited: mainForm.input.text = ''
                }

                State {
                    id: exclude_word

                    onEntered: excludeWordAdd_form.doExcludeAdd(infos.baseUrl, infos.u, infos.token, infos.n, mainForm.word.text, infos.language)

                    SignalTransition {
                        targetState: success
                        signal: excludeWordAdd_form.excludeAdd
                    }

                    SignalTransition {
                        targetState: error_private
                        signal: excludeWordAdd_form.excludeAddError
                    }
                }
            }

            State {
                id: logout_api
                onEntered: {
                    logout_form.doLogout(infos.baseUrl, infos.u, infos.token, infos.n)
                }
                SignalTransition {
                    targetState: loggedOut
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

            onIsWordNonPositive: {
                if (isWord_form.lastWord == mainForm.input.text) {
                    isWord_form.isWord(isWord_form.lastWord)
                }

                if (errorNumber == 203) {
                    isWord_form.lastWord = mainForm.input.text
                    isWord_form.isWordUnknown()
                }
                else {
                    isWord_form.isWordError()
                }
            }
        }

        ExcludeWordAdd {
            id: excludeWordAdd_form
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
