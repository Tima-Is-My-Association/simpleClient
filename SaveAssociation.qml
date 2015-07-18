import QtQuick 2.0
import TIMA.Helper 1.0

Item {
    signal saveAsso (string nW)
    signal saveAssoError (int errorNumber, string errorMessage)

    HashHelper {
        id: helper
    }

    WebRequest {
        id: request
        onAccepted: saveAsso(message)
        onError: saveAssoError(errorNumber, errorMessage)
    }

    function doSaveAssociation(baseUrl, u, token, n, language, word, association)
    {
        var url = baseUrl + "/api/association/"
        var params = "language="+language+
                "&word="+word+
                "&association="+association+
                "&u="+u+
                "&token="+helper.hash(token + n)

        request.sendRequest(url, params)
    }
}

