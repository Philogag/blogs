#!/bin/sh

hosts=(
  "github.com"
  "raw.githubusercontent.com"
  "assets-cdn.github.com"
  "github.global.ssl.fastly.net"
)

#### use https://geo.ipify.org/ api to get domain ip
apikey="at_4LQunUcDLPt7fhpmmR0HEslDISFpT"

for h in ${hosts[@]}
do
  echo $h:
  hip=`curl -s "https://geo.ipify.org/api/v1?apiKey=$apikey&domain=$h" | jq '.ip' | sed 's/\"//g'`
  echo "  ->$hip"
  sed -i "/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} $h #auto_update.*/d" /etc/hosts
  echo "$hip $h #auto_update" >> /etc/hosts
  echo "  ->update ok"
done
