import QtQuick 2.0
import TIMA.Helper 1.0

Item {

    signal isWord (string nW)
    signal isWordNonPositive (int errorNumber, string errorMessage)
    signal isWordUnknown ()
    signal isWordError ()

    property string lastWord: ''

    WebRequest {
        id: request
        onAccepted: isWord(message)
        onError: isWordNonPositive(errorNumber, errorMessage)
    }

    function isWordTest(baseUrl, word, language)
    {
        var url = baseUrl + "/api/words/isa/";
        var params = "word="+word+"&language="+language;

        request.sendRequest(url, params)
    }
}

