#!/bin/bash
# author: noodzhan@163.com

FRP_API_URL='http://1.15.231.74:7500/api/proxy/tcp'
ALERT_EMAIL='noodzhan@163.com'

resp=$(curl -s $FRP_API_URL \
  -H 'Accept: */*' \
  -H 'Accept-Language: zh-CN,zh;q=0.9' \
  -H 'Authorization: Basic YWRtaW46bm9vZHpoYW5AMTIzNA==' \
  -H 'Connection: keep-alive' \
  -H 'Referer: http://1.15.231.74:7500/static/' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' \
  --compressed \
  --insecure --connect-timeout 30)

## sudo apt install jq
ssh_status=$(echo $resp | jq -r '.proxies[] | select(.name == "ssh") | .status')
jeecgboot_status=$(echo $resp | jq -r '.proxies[] | select(.name == "jeecgboot") | .status')
mysql_status=$(echo $resp | jq -r '.proxies[] | select(.name == "mysql") | .status')
if [[ $ssh_status == "offline" || $jeecgboot_status == "offline" || $mysql_status == "offline" ]]; then
  ## sudo apt install mailutils
  echo $resp | jq '.' | iconv -t utf-8 | mail -s "frp-alter" $ALERT_EMAIL
fi
