import QtQuick 2.0
import TIMA.Helper 1.0

Item {

    signal isWord (string nW)
    signal isWordError (int errorNumber, string errorMessage)

    WebRequest {
        id: request
        onAccepted: isWord(message)
        onError: isWordError(errorNumber, errorMessage)
    }

    function isWordTest(baseUrl, word, language)
    {
        var url = baseUrl + "/api/words/isa/";
        var params = "word="+word+"&language="+language;

        request.sendRequest(url, params)
    }
}

