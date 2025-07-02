要禁止 SSH 连接 root 用户，您可以按照以下步骤进行：

1. 使用管理员权限登录到 Linux 系统。

2. 打开 SSH 配置文件 `/etc/ssh/sshd_config`：

   ```bash
   sudo vi /etc/ssh/sshd_config
   ```

3. 在文件中找到 `PermitRootLogin` 选项并修改其值。如果该选项不存在，则添加以下行：

   ```
   PermitRootLogin no
   ```

   设置为 `no` 表示禁止 root 用户通过 SSH 登录。

4. 保存并关闭文件。

5. 重新加载 SSH 服务以使配置更改生效：

   ```bash
   sudo systemctl restart sshd
   ```

现在，已经禁止了通过 SSH 直接使用 root 用户登录系统。

请注意，禁用 root 用户通过 SSH 登录是一种很好的安全措施，因为这样可以防止潜在的恶意用户直接尝试 root 登录。相反，您应该使用一个普通用户登录系统，并在需要时切换到 root 用户执行特权操作。

在进行此类更改之前，请确保您理解其影响，并确保您拥有其他以管理员身份登录系统的用户，以免无法再次访问系统。