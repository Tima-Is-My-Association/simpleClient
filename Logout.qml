import QtQuick 2.0
import TIMA.Helper 1.0

Item {
    signal logout (string nW)
    signal logoutError (string error)

    HashHelper {
        id: helper
    }

    WebRequest {
        id: request
        onAccepted: logout(message)
        onError: logoutError(errorNumber, errorMessage)
    }

    function doLogout(baseUrl, u, token, n)
    {
        var url = baseUrl + "/api/applications/auth/revoke/";
        var params = "u="+u+
                '&token='+helper.hash(token + n)

        request.sendRequest(url, params)
    }
}

