import QtQuick 2.0

Item {
    signal privateRequest (string nW)
    signal privateRequestError (string error)

    function doPrivateRequest(url)
    {
        var http = new XMLHttpRequest();
        //var url = "http://tima.jnphilipp.org/api/applications/auth/request/";
        //var url = "http://172.24.173.249:8000/api/applications/auth/request/";
        //var params = "username=KaiQ&client_id=fd9be30af20559334c2bac8cfb600719f13ea52db7b843d90c57449fa5b04fca"
        var params = "username=KaiQ&client_id=b89697baf6903c069242eaeb8ba923dddecfb3220993a1ed19dc3ec872387c15"

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

