#!/bin/bash
# author zhanzhihu

#*/5 * * * * /usr/local/bin/check_dtaos.sh >> /root/logs/check_dtaos.log 2>&1

container_name=tdengine

is_active=$(docker ps |grep ${container_name} |wc -l )

if [ $is_active -eq 0 ]; then
  echo "$(date +"%Y-%m-%d %H:%M:%S") start taos"
  docker start ${container_name}
  else
    echo "$(date +"%Y-%m-%d %H:%M:%S") ${container_name} is running"
fi
