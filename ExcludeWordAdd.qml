import QtQuick 2.0
import TIMA.Helper 1.0

Item {

    signal excludeAdd (string nW)
    signal excludeAddError (int errorNumber, string errorMessage)

    WebRequest {
        id: request
        onAccepted: excludeAdd(message)
        onError: excludeAddError(errorNumber, errorMessage)
    }

    HashHelper {
        id: helper
    }

    function doExcludeAdd(baseUrl, u, token, n, word, language)
    {
        var url = baseUrl + "/api/profile/excludedwords/add/";
        var params = "language="+language+
                "&word="+word+
                "&u="+u+
                "&token="+helper.hash(token + n)

        request.sendRequest(url, params)
    }
}

