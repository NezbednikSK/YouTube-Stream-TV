#!/bin/bash
while read p; do
  export "RAW=$(echo "$p" | sed "s/ /\\n/g")"
  export "CHANNEL_ID=$(echo "$RAW" | head -n 1)"
  export "M3U=$(echo "$RAW" | tail -n 1)"
  export "FILE=$(mktemp)"
  
  node ./grab.js "$CHANNEL_ID" > "$FILE"
  
  export "SHA=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/contents/$M3U.m3u8?ref=stream" | node -e "var body=\"\";process.stdin.on(\"data\",(c)=>{body+=c.toString();});process.stdin.on(\"end\",()=>{process.stdout.write(JSON.parse(body).sha);});")"
  curl -s -X PUT -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/contents/$M3U.m3u8" -d "{\"message\": \"Update streams ($(TZ="Europe/Bratislava" date "+%d/%m/%y %H:%M:%S %Z"))\", \"branch\": \"stream\", \"sha\": \"$SHA\", \"content\": \"$(base64 -w 0 "$FILE")\"}"
done < channels.txt
