import QtQuick 2.0

Item {

    signal isWord
    signal isWordError (string error)

    function isWordTest(w)
    {
        var http = new XMLHttpRequest();
        var url = "http://tima.jnphilipp.org/api/words/isa/";
        var params = "word="+w+"&language=DE";

        http.open("POST", url, true);
        http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-Length", params.length);
        http.setRequestHeader("Transfer-Encoding:", "chunked");

        http.onreadystatechange = function() {
            if (http.readyState == XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    isWord()
                    //wordColor = JSON.parse(http.responseText)['word']
                } else {
                    isWordError(http.statusText)
                    //wordColor = "red"
                }
            }
        }
        http.send(params);
    }
}

