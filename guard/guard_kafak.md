# Kafka & Zookeeper 健康检查脚本

此脚本检查 Kafka 和 Zookeeper 服务的健康状态，具体方法是通过检查对应的端口（Kafka 的 9092 端口，Zookeeper 的 2181 端口）是否处于活动状态。如果任一服务未运行，脚本会尝试重启 Zookeeper 服务，然后再重启 Kafka 服务。

## 脚本解析

1. **获取当前时间**：
    - 使用 `date` 命令获取当前的时间，格式为 `YYYY-MM-DD HH:MM:SS`。

2. **检查 Kafka 是否存活**：
    - 使用 `netstat` 命令检查端口 9092（Kafka 的默认端口）是否在使用中。
    - 如果 `netstat` 没有找到端口 9092 上的任何进程，则 `kafka_alive` 的值为 `0`。

3. **检查 Zookeeper 是否存活**：
    - 同样，脚本会检查端口 2181（Zookeeper 的默认端口）是否在使用中。
    - 如果没有找到端口 2181 上的进程，则 `zookeeper_alive` 的值为 `0`。

4. **重启服务**：
    - 如果 Kafka 或 Zookeeper 中任意一个服务未运行（即 `kafka_alive` 或 `zookeeper_alive` 为 `0`），脚本会：
        1. 重启 Zookeeper 服务。
        2. 等待 30 秒（使用 `sleep 30`），让 Zookeeper 服务稳定。
        3. 然后重启 Kafka 服务。

## 使用 Crontab 设置每5分钟检查一次

为了让脚本每5分钟执行一次，我们需要在 `crontab` 中添加定时任务。

### 配置 `crontab` 的步骤：

1. 打开 `crontab` 编辑器：

   ```bash
   crontab -e
   ```

2. 在打开的文件中，添加以下内容来设置每5分钟执行一次脚本：

   ```bash
   */5 * * * * /path/to/your/script.sh
   ```

   请将 `/path/to/your/script.sh` 替换为脚本在你系统中的完整路径。

3. 保存并退出编辑器后，脚本将每5分钟执行一次，检查 Kafka 和 Zookeeper 服务的状态。

## 完整脚本示例

```bash
#!/bin/bash

# 获取当前时间，格式为 YYYY-MM-DD HH:MM:SS
current_time=$(date +"%Y-%m-%d %H:%M:%S")

# 检查 Kafka 是否存活，判断 9092 端口是否被占用
kafka_alive=$(sudo netstat -tunlp | grep 9092 | wc -l)

# 检查 Zookeeper 是否存活，判断 2181 端口是否被占用
zookeeper_alive=$(sudo netstat -tunlp | grep 2181 | wc -l)

# 如果 Kafka 或 Zookeeper 未存活，重启服务
if [ "$kafka_alive" -eq 0 ] || [ "$zookeeper_alive" -eq 0 ]; then
  sudo systemctl restart zookeeper.service
  sleep 30
  sudo systemctl restart kafka.service
fi
```

## 注意事项：

- **权限**：确保运行脚本的用户（通常是 root 用户）具有重启 `zookeeper.service` 和 `kafka.service` 服务的权限。
- **日志记录**：为了更好地进行监控和故障排查，你可能需要在脚本中加入日志记录功能，记录服务何时被重启。

通过这种方式，你可以确保 Kafka 和 Zookeeper 服务保持稳定，如果其中一项服务停止运行，脚本会自动重启它们。