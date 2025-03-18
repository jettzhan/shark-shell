#!/bin/bash
# author: noodzhan@163.com

# 获取当前主机的 IP 地址
self_ip=$(hostname -I | awk '{print $1}')

# 如果获取不到 IP 地址，则退出脚本
if [ -z "$self_ip" ]; then
  echo "无法获取本机 IP 地址"
  exit 1
fi

# 设置允许的端口（这些端口将被开放）
allowed_tcp_ports="22,80,443,1883,3306,5432,6379"
# 限制性端口，如果有特殊需求可以通过这些端口限制自定义访问
restrict_tcp_ports=""
# 管理员的 IP 地址，只有管理员 IP 可以访问
admin_ip=""

# 清空现有的 iptables 规则
iptables -t filter -F
iptables -t filter -X

# 设置默认策略为 DROP（丢弃所有的入站流量）
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 允许本机回环通信
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# 允许已经建立的连接和相关流量
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 允许指定的端口的 TCP 连接（如 SSH, HTTP, HTTPS 等）
iptables -A INPUT -p tcp -m multiport --sports ${allowed_tcp_ports} -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports ${allowed_tcp_ports} -j ACCEPT

# 如果 restrict_tcp_ports 被定义，则允许从本机 IP 访问指定端口
if [ -n "$restrict_tcp_ports" ]; then
  iptables -A INPUT -p tcp -m multiport --dports ${restrict_tcp_ports} -s ${self_ip} -j ACCEPT
fi

# 如果 admin_ip 被定义，则允许该管理员 IP 地址的流量
if [ -n "$admin_ip" ]; then
  iptables -I INPUT -s ${admin_ip} -j ACCEPT
  iptables -I OUTPUT -d ${admin_ip} -j ACCEPT
fi

# 打印当前 iptables 规则
echo "当前 iptables 配置："
iptables -L -v -n

