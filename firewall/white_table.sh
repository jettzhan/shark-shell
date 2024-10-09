#!/bin/bash

# 清除现有的iptables规则
iptables -F

# 允许来自指定IP的访问
allowed_ips=("172.24.20.12" "172.24.20.13" "172.24.20.14" "172.24.20.15" "172.24.20.16" "172.24.20.17" "172.16.2.157" "127.0.0.1" "172.16.56.185" "172.16.56.188" "172.16.56.189" "172.24.8.12" "")

# 拒绝访问的端口
unallowed_ports=("8702" "8700" "8726" "8725" "8724" "8723" "8722" "8704" "8718" "8715" "8999" "8997" "8086" "18704" "8848" "8080" "3100" "9104" "9100" "9187" "9090" "3306" "3310" "5432" "6379" "7070")



for ip in "${allowed_ips[@]}"; do
  iptables -A INPUT -s "$ip" -j ACCEPT
done

# 拒绝端口被访问
for port in "${unallowed_ports[@]}"; do
  iptables -A INPUT -p tcp --dport "$port" -j DROP
done

# 显示iptables规则
iptables -L -n

# 保存iptables配置
#iptables-save > /etc/iptables/rules.v4

echo "已完成iptables规则设置。"
