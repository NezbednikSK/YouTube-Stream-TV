#!/bin/sh
curl -X PUT -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/contents/CN.m3u8" \
  -d "{\"message\": \"Update streams ($(TZ="Europe/Bratislava" date "+%d/%m/%y %H:%M:%S %Z"))\", \"branch\": \"stream\", \"content\": \"$(base64 -w 0 index.m3u8)\"}"
