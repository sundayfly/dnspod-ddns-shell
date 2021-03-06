#!/bin/bash

# This script used for update local ip to ddns on dnspod.cn

# get token from https://www.dnspod.cn/console/user/security follow https://support.dnspod.cn/Kb/showarticle/tsid/227/
TOKEN_ID="xxxxxx"
TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxx"
DOMAIN="example.com"
SUB_DOMAIN="xxx"

REQUEST_PARAM="login_token=${TOKEN_ID},${TOKEN}&format=json&domain=${DOMAIN}&sub_domain=${SUB_DOMAIN}"

record_info=$(curl -s -X POST https://dnsapi.cn/Record.List -d "${REQUEST_PARAM}")
record_id=$(echo ${record_info} | grep -Po "(?<=\[\{\"id\":\")([0-9\.]*)")
record_value=$(echo ${record_info} | grep -Po "(?<=\"value\":\")([0-9\.]*)")
record_line_id=$(echo ${record_info} | grep -Po "(?<=\"line_id\":\")([0-9\.]*)")
echo "${SUB_DOMAIN}:${DOMAIN} record_id: ${record_id}, record_line_id: ${record_line_id}, record_value: ${record_value}"

#local_ip=$(curl -s https://api.ipify.org)
local_ip=$(curl -s http://ip.qaros.com/)
echo "local ip: ${local_ip}"

if [[ $record_value != $local_ip ]];then
  echo "ip changed, will update"
  update_res=$(curl -s -X POST https://dnsapi.cn/Record.Ddns -d "${REQUEST_PARAM}&record_id=${record_id}&record_line_id=${record_line_id}&value=${local_ip}")
  echo $update_res
else
  echo "not changed, ignore"
fi

#https://gist.github.com/ankanch/8c8ec5aaf374039504946e7e2b2cdf7f
#https://www.ipify.org
#http://api.ident.me
#http://ip.3322.net