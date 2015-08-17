import QtQuick 2.0
import TIMA.Helper 1.0

Item {

    WebRequest {
        id: request
        onAccepted: nextWord(preProcess(message))
        onError: nextWordError(errorNumber, errorMessage)
    }

    property variant lastWords: ['', '', '', '', '']

    signal nextWord (string nW)
    signal nextWordError (int errorNumber, string errorMessage)

    function preProcess(m)
    {
        var nW = JSON.parse(m)['word']
        lastWords.push(decodeURI(nW))
        lastWords.shift()
        return nW
    }

    function getNextWord(user)
    {
        var url = "https://tima.jnphilipp.org/api/words/next/";
        var params = "language=DE" + "&username=" + user + lastWords.reduce(function (ret, w) {
            return ret + "&excludes=" + w;
        }, '');

        request.sendRequest(url, params)
    }
}

