如果你需要同时检测多个网站的 SSL 证书过期情况，可以将脚本进行一些调整，支持检测多个域名。我们可以通过将多个域名放在一个文件中，然后循环读取并逐个检查它们的证书状态。

### 脚本：`check_ssl_expiry.sh`

```bash
#!/bin/bash

# 配置部分
DOMAIN_LIST="domains.txt"     # 存储需要检查证书的域名的文件
EMAIL="your-email@example.com"  # 收到通知的电子邮件
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
```

### 使用说明

1. **准备域名列表文件**
    - 创建一个名为 `domains.txt` 的文本文件，每行一个域名。可以添加注释（以 `#` 开头）和空行：

   ```txt
   example.com
   another-domain.com
   some-website.org
   # test-domain.com  # 这是一个注释
   ```

2. **修改脚本配置**
    - 将 `DOMAIN_LIST` 设置为包含域名的文件路径（默认为 `domains.txt`）。
    - 将 `EMAIL` 设置为你的接收电子邮件地址。
    - 修改 `THRESHOLD` 为提前多少天提醒（例如，30天）。默认值为30天。

3. **保存并运行脚本**
    - 将脚本保存为 `check_ssl_expiry.sh`，并赋予执行权限：
      ```bash
      chmod +x check_ssl_expiry.sh
      ```
    - 运行脚本：
      ```bash
      ./check_ssl_expiry.sh
      ```

### 设置定时任务

如果你需要定期检查多个域名的证书，可以通过 cron 设置定时任务。例如，每天早上 8 点检查：
```bash
crontab -e
```
在 cron 文件中添加以下行：
```bash
0 8 * * * /path/to/check_ssl_expiry.sh
```

### 总结

通过这种方式，你可以轻松地管理多个域名的 SSL 证书过期检查，且能够在证书即将过期时接收到电子邮件通知。