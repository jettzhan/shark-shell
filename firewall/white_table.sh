#!/bin/bash

# 清除现有的iptables规则
sudo iptables -F

# 允许来自指定IP的访问
allowed_ips=("172.24.20.12" "172.24.20.13")

# 拒绝访问的端口
unallowed_ports=("3306" "5432" "7070")

#sudo iptables -A INPUT -s 10.124.160.0/24 -p tcp --dport 22 -j REJECT
#sudo iptables -A INPUT -s 10.124.160.0/24 -p tcp --dport 80 -j ACCEPT
#sudo iptables -A INPUT -s 10.124.160.0/24 -p tcp -j REJECT

for ip in "${allowed_ips[@]}"; do
  sudo iptables -A INPUT -s "$ip" -j ACCEPT
done

# 拒绝端口被访问
for port in "${unallowed_ports[@]}"; do
  sudo iptables -A INPUT -p tcp --dport "$port" -j DROP
done

# 显示iptables规则
sudo iptables -L -n

# 保存iptables配置
#iptables-save > /etc/iptables/rules.v4

echo "已完成iptables规则设置。"
