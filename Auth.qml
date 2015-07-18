import QtQuick 2.0
import TIMA.Helper 1.0

Item {
    signal auth (string nW)
    signal authError (int errorNumber, string errorMessage)

    HashHelper {
        id: helper
    }

    WebRequest {
        id: request
        onAccepted: auth(message)
        onError: authError(errorNumber, errorMessage)
    }

    function doAuth(baseUrl, userName, password, client_id, client_secret, timestamp)
    {
        var url = baseUrl + "/api/applications/auth/user/";
        var params = "username="+userName+
                "&password="+password+
                "&client_id="+client_id+
                "&timestamp="+encodeURIComponent(timestamp)+
                "&token="+helper.hash(client_secret + timestamp);

        request.sendRequest(url, params)
    }
}

