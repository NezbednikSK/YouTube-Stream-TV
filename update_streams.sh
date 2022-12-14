#!/bin/sh
while read p; do
  export "RAW=$(sed "s/ /\\n/g" < "$p")"
  export "CHANNEL_ID=$(head -n 1 <<< "$RAW")"
  export "M3U=$(tail -n 1 <<< "$RAW")"
  
  ./grab.js "$CHANNEL_ID" > "$M3U.m3u8"
  
  export "SHA=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/contents/$M3U.m3u8?ref=stream" | node -e "var body=\"\";process.stdin.on(\"data\",(c)=>{body+=c.toString();});process.stdin.on(\"end\",()=>{process.stdout.write(JSON.parse(body).sha);});")"
  curl -s -X PUT -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/contents/$M3U.m3u8" -d "{\"message\": \"Update streams ($(TZ="Europe/Bratislava" date "+%d/%m/%y %H:%M:%S %Z"))\", \"branch\": \"stream\", \"sha\": \"$SHA\", \"content\": \"$(base64 -w 0 "$SHA.m3u8")\"}"
done < channels.txt
