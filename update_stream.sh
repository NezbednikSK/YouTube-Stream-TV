#!/bin/sh
export "SHA=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/contents/CN.m3u8?ref=stream" | node -e "var body = \"\"; \
process.stdin.on(\"data\", (c) => { \
  body += c.toString(); \
}); \
process.stdin.on(\"end\", () => { \
  process.stdout.write(JSON.parse(body).sha); \
});")"

curl -s -X PUT -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/contents/CN.m3u8" \
  -d "{\"message\": \"Update streams ($(TZ="Europe/Bratislava" date "+%d/%m/%y %H:%M:%S %Z"))\", \"branch\": \"stream\", \"sha\": \"\", \"content\": \"$(base64 -w 0 index.m3u8)\"}"
