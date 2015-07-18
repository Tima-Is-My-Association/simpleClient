import QtQuick 2.0
import TIMA.Helper 1.0

Item {

    signal authRequest (string nW)
    signal authRequestError (int errorNumber, string errorMessage)

    WebRequest {
        id: request
        onAccepted: authRequest(message)
        onError: authRequestError(errorNumber, errorMessage)
    }

    function doAuthRequest(baseUrl, username, client_id)
    {
        var url = baseUrl + "/api/applications/auth/request/";
        var params = "username=" + username + "&client_id=" + client_id

        request.sendRequest(url, params)
    }
}

