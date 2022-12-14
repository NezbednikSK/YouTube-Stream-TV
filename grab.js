const fs = require("fs");
const https = require("https");

https.get("https://www.youtube.com/channel/UCQfwfsi5VrQ8yKZ-UWmAEFg/live", (response) => {
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
        var file = fs.createWriteStream("index.m3u8");
        file.write("#EXTM3U\n");
        file.write("#EXTINF:-1,cartoon network shiz\n");
        file.write(url);
        file.end("\n");
   });
});
