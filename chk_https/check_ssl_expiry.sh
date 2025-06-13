#!/bin/bash

# 配置部分
DOMAIN_LIST="domains.txt"     # 存储需要检查证书的域名的文件
EMAIL="noodzhan@163.com"  # 收到通知的电子邮件
THRESHOLD=30                # 提前多少天提醒（默认30天）

# 检查文件是否存在
if [ ! -f "$DOMAIN_LIST" ]; then
    echo "域名列表文件 $DOMAIN_LIST 不存在！"
    exit 1
fi

# 循环处理每个域名
while IFS= read -r DOMAIN; do
    # 跳过空行和注释行
    if [[ -z "$DOMAIN" || "$DOMAIN" =~ ^# ]]; then
        continue
    fi

    #openssl s_client -connect noodb.com:443 2>/dev/null | openssl x509 -noout -enddate

    # 获取证书过期时间
    expiry_date=$(echo | openssl s_client -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)

    if [ -z "$expiry_date" ]; then
        echo "无法获取 $DOMAIN 的证书信息。"
        continue
    fi

    # 转换为时间戳
    expiry_timestamp=$(date -d "$expiry_date" +%s)
    current_timestamp=$(date +%s)

    # 计算证书剩余有效天数
    remaining_days=$(( (expiry_timestamp - current_timestamp) / 86400 ))

    # 如果剩余天数小于阈值，发送邮件
    if [ $remaining_days -le $THRESHOLD ]; then
        subject="SSL证书即将过期：$DOMAIN"
        message="警告：$DOMAIN的SSL证书将在$remaining_days天后过期。\n\n证书到期时间：$expiry_date"

        echo -e "$message" | mail -s "$subject" $EMAIL
    fi
done < "$DOMAIN_LIST"
