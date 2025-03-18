#!/bin/bash
# author: noodzhan@163.com

# CVE-2002-20001
# https://blog.csdn.net/zhongxj183/article/details/124928794

sshd -T | grep -w kexalgorithms
echo 'Ciphers aes128-ctr,aes192-ctr,aes256-ctr' >> /etc/ssh/sshd_config
echo "kexalgorithms -diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1" >> /etc/ssh/sshd_config
systemctl restart sshd
sshd -T | grep -w kexalgorithms
sshd -T |grep ciphers
