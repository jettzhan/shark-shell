#!/bin/bash

# 配置端口和对应的启动命令
ports=("8081" "8099")
commands=(
    "nohup java -jar /opt/nbcio/nbcio-boot-module-system-3.1.jar > /dev/null 2>&1 &"
    "nohup java -jar -Dspring.profiles.active=prod /opt/service/taos/jeecg-system-start-3.4.4.jar > /dev/null 2>&1 &"
)

# 检查端口是否在监听状态
check_port() {
    local port=$1
    netstat -tunlp | grep ":$port " | wc -l
}

# 主循环
for i in "${!ports[@]}"; do
    if [[ $(check_port "${ports[i]}") -eq 0 ]]; then
        echo "端口 ${ports[i]} 未监听，执行启动命令: ${commands[i]}"
        eval "${commands[i]}"
    else
        echo "端口 ${ports[i]} 已监听"
    fi
done