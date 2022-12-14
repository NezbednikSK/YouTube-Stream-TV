const fs = require("fs");
const https = require("https");

https.get("https://www.youtube.com/channel/UCMsgXPD3wzzt8RxHJmXH7hQ/live", (response) => {
    var body = "";
    response.on("data", (chunk) => {
        body += chunk.toString();
    });
    response.on("end", () => {
        var index = body.indexOf(".m3u8");
        var url = "";
        for (var i = index; i--; i > 0) {
            if (body.substr(i, 8) == "https://") {
                url = body.substr(i, index - i + 5);
                break;
            }
        }
        if (url == "") process.exit(1);
        https.get(url, (response2) => {
            response2.pipe(fs.createWriteStream("index.m3u8"));
        });
    });
});
