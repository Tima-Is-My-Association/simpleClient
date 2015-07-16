import QtQuick 2.0
import TIMA.Helper 1.0

Item {
    signal logout (string nW)
    signal logoutError (string error)

    HashHelper {
        id: helper
    }

    function doLogout(baseUrl, u, token, n)
    {
        var http = new XMLHttpRequest();
        var url = baseUrl + "/api/applications/auth/revoke/";
        var params = "u="+u+
                '&token='+helper.hash(token + n)

        http.open("POST", url, true);
        http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-Length", params.length);

        http.onreadystatechange = function() {
            if (http.readyState == XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    logout(http.responseText)

                } else {
                    messageDialog.show(" Error Nr.: " + http.status + " Error: " + http.responseText)
                    logoutError(" Error: " + http.responseText)

                }
            }
        }
        http.send(params);
    }
}

