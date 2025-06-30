#!/bin/bash
set -e

# 配置信息
install_dir="/usr/local"
nacos_user="nacos"
nacos_passwd="nacos"

# 检查端口是否处于监听状态
function check_port() {
    local port=$1
    netstat -tunlp | grep "$port" | wc -l
}

# 启动Nacos服务
function start_nacos() {
    source /etc/profile
    echo "JAVA_HOME: ${JAVA_HOME}"
    "${install_dir}/nacos/bin/startup.sh" -m standalone
}

# 远程调用认证接口
function remote_auth() {
    local username=$1
    local password=$2
    curl -X POST '127.0.0.1:8848/nacos/v1/auth/login' -d "username=${username}&password=${password}"
}

# 检查端口是否已监听，未监听则启动Nacos服务
if [[ $(check_port 8848) -eq 0 ]]; then
    start_nacos
else
    # 远程调用认证接口
    res=$(remote_auth "$nacos_user" "$nacos_passwd")
    sleep 5
    if [[ $(echo "$res" | grep -c "accessToken") -ne 1 ]]; then
        start_nacos
    fi
fi