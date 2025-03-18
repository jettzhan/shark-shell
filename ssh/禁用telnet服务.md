# 禁用 Telnet 服务

要在 OpenEuler 上禁用 Telnet 服务并关闭 Telnet 端口（默认为端口 23），可以按照以下步骤进行：

## 操作步骤

1. 使用 root 用户或具有管理员权限的用户登录到 OpenEuler 操作系统。

2. 打开 Telnet 服务的配置文件 `telnet`，通常位于 `/etc/xinetd.d/` 目录下：

   ```bash
   sudo vi /etc/xinetd.d/telnet
   ```

3. 在文件中找到 `disable` 这一行，并将其值修改为 `yes`，表示禁用 Telnet 服务：

   ```
   disable = yes
   ```

4. 保存并关闭文件。

5. 重新加载 xinetd 服务以使更改生效：

   ```bash
   sudo systemctl reload xinetd
   ```

6. 确认 Telnet 服务已被禁用。您可以运行以下命令来检查是否仍然监听着 Telnet 端口：

   ```bash
   sudo netstat -tuln | grep 23
   ```

   如果没有输出结果，则表示 Telnet 端口已成功关闭。

## 注意事项

- Telnet 是一种不加密的远程登录协议，容易受到网络攻击，禁用 Telnet 服务可以提高系统的安全性。

- 如果您需要通过其他远程登录方法（例如 SSH）连接到 OpenEuler，确保您已经启用和配置了相应的服务，并相应地调整防火墙规则以允许对应的端口连接。

- 如有需要，可以根据实际情况进行调整，并参考 OpenEuler 的文档或支持社区以获取更准确的信息和指导。