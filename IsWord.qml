import QtQuick 2.0
import TIMA.Helper 1.0

Item {

    signal isWord
    signal isWordError (string error)

    WebRequest {
        id: request
        onAccepted: isWord(message)
        onError: isWordError(errorNumber, errorMessage)
    }

    function isWordTest(baseUrl, word)
    {
        var url = baseUrl + "/api/words/isa/";
        var params = "word="+word+"&language=DE";

        request.sendRequest(url, params)
    }
}

