$(function () {
    startSSE();
    try {
        $('[data-tooltip="tooltip"]').tooltip();
    } catch {
    }
});


function startSSE() {
    let serverEvent = new EventSource("/alerte/sse");
    serverEvent.onmessage = function (event) {
        const data = JSON.parse(event.data);
        console.log(sessionStorage.getItem("previousNumber"));
        if (sessionStorage.getItem("previousNumber") === "undefined") { // Si c'est la première passe
            sessionStorage.setItem("previousNumber", data.count);
            $("#notif-count").text(data.count);
        } else if (data.count !== sessionStorage.getItem("previousNumber")) { // Sinon on vérifie s'il y a eu une update
            if (sessionStorage.getItem("previousNumber") === "0") {
                console.log("?");
                $('#profile-notif').append("<a href=\"/profil/notifications\"><span class=\"badge badge-dark\" id=\"notif-count\"></span></a>");
            }
            if (data.count !== "0") {
                //$("#notif-sound")[0].play();
                $("#notif-count").text(data.count);
            }
            sessionStorage.setItem("previousNumber", data.count);
        }
    }
}