import QtQuick 2.0

Item {

    signal authRequest (string nW)
    signal authRequestError (string error)

    function doAuthRequest(baseUrl, username, client_id)
    {
        var http = new XMLHttpRequest();
        var url = baseUrl + "/api/applications/auth/request/";
        var params = "username=" + username + "&client_id=" + client_id

        http.open("POST", url, true);
        http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-Length", params.length);

        http.onreadystatechange = function() {
            if (http.readyState == XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    authRequest(http.responseText)

                } else {
                    messageDialog.show(" Error Nr.: " + http.status + " Error: " + http.responseText)
                    authRequestError(" Error: " + http.responseText)

                }
            }
        }
        http.send(params);
    }
}

