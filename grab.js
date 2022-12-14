const https = require("https");

https.get("https://www.youtube.com/channel/" + process.argv[process.argv.length - 1] + "/live", (response) => {
    var body = "";
    response.on("data", (chunk) => {
        body += chunk.toString();
    });
        response.on("end", () => {
        var index = body.indexOf(".m3u8");
        var url = "";
        for (var i = index; i--; i > 0) {
            if (body.substr(i, 8) == "https://") {
                url = body.substr(i, index - i + 5);
                break;
            }
        }
        if (url == "") process.exit(1);
        https.get(url, (response2) => {
            response2.on("data", (chunk) => {
                process.stdout.write(chunk.toString());
            });
            response2.on("end", () => {
                process.exit(0);
            });
        });
    });
});
