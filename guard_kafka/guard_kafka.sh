#!/bin/bash
# author: noodzhan@163.com

current_time=$(date +"%Y-%m-%d %H:%M:%S")
kafka_alive=$(sudo netstat -tunlp | grep 9092 | wc -l)
zookeeper_alive=$(sudo netstat -tunlp | grep 2181 | wc -l)

if [ "$kafka_alive" -eq 0 ] || [ "$zookeeper_alive" -eq 0 ]; then
  sudo systemctl restart zookeeper.service
  sleep 30
  sudo systemctl restart kafka.service
fi
