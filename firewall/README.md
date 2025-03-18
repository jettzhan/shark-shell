
### **使用说明**

1. **获取脚本**
    - 将脚本复制到一个文件中，例如 `firewall_init.sh`。

2. **设置脚本权限**
    - 为脚本文件赋予可执行权限：
   ```bash
   chmod +x firewall_init.sh.sh
   ```

3. **自定义配置**
    - **开放端口**：脚本中有一个 `allowed_tcp_ports` 变量，你可以在其中指定需要开放的端口（以逗号分隔）。例如，如果你想开放 `22`（SSH）、`80`（HTTP）、`443`（HTTPS）端口，可以设置如下：
   ```bash
   allowed_tcp_ports="22,80,443"
   ```
    - **限制访问端口**：如果你希望限制某些端口的访问（例如只允许本机访问特定端口），你可以设置 `restrict_tcp_ports`。例如，允许只从本机访问 `3306`（MySQL）端口：
   ```bash
   restrict_tcp_ports="3306"
   ```
    - **管理员 IP 地址**：如果你有特定的管理员 IP 地址，并希望仅允许该 IP 地址的访问，可以设置 `admin_ip` 变量。例如，假设管理员的 IP 地址是 `192.168.1.100`：
   ```bash
   admin_ip="192.168.1.100"
   ```

4. **运行脚本**
    - 以 `root` 用户或有 `sudo` 权限的用户身份运行脚本：
   ```bash
   sudo ./firewall_init.sh.sh
   ```
   运行后，脚本会自动清空当前的 `iptables` 规则，并按照自定义配置重新设置规则。

5. **检查当前 `iptables` 规则**
    - 脚本执行完毕后，会显示当前的 `iptables` 规则，确保已经正确配置。

---

### **脚本解释**

这个脚本的功能是设置一个基础的 `iptables` 防火墙规则，并允许你根据需求灵活定制开放的端口和访问权限。以下是脚本中主要部分的详细解释：

1. **获取主机 IP 地址**：
   ```bash
   self_ip=$(hostname -I | awk '{print $1}')
   ```
    - 使用 `hostname -I` 获取当前主机的 IP 地址。如果主机有多个网络接口，`hostname -I` 会返回多个 IP 地址。`awk '{print $1}'` 提取第一个 IP 地址。

2. **清空现有的 `iptables` 规则**：
   ```bash
   iptables -t filter -F
   iptables -t filter -X
   ```
    - `iptables -F` 命令清空所有现有规则。
    - `iptables -X` 删除所有自定义链。

3. **设置默认策略**：
   ```bash
   iptables -P INPUT DROP
   iptables -P FORWARD DROP
   iptables -P OUTPUT ACCEPT
   ```
    - `INPUT` 链默认丢弃所有流量（增加安全性）。
    - `FORWARD` 链默认丢弃所有流量。
    - `OUTPUT` 链默认接受所有流量（允许本机发送流量）。

4. **允许回环接口流量**：
   ```bash
   iptables -A INPUT -i lo -j ACCEPT
   iptables -A OUTPUT -o lo -j ACCEPT
   ```
    - 确保系统与自己通信时（例如，应用程序通过 `localhost` 访问），流量不会被防火墙阻挡。

5. **允许已建立的连接**：
   ```bash
   iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
   iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
   ```
    - 允许来自已建立连接的流量，以便系统可以继续处理现有的会话。

6. **开放特定端口**：
   ```bash
   iptables -A INPUT -p tcp -m multiport --sports ${allowed_tcp_ports} -j ACCEPT
   iptables -A OUTPUT -p tcp -m multiport --dports ${allowed_tcp_ports} -j ACCEPT
   ```
    - 通过 `multiport` 模块一次性开放多个端口，`allowed_tcp_ports` 中列出的端口将被允许连接。

7. **限制某些端口的访问（仅本机）**：
   ```bash
   iptables -A INPUT -p tcp -m multiport --dports ${restrict_tcp_ports} -s ${self_ip} -j ACCEPT
   ```
    - 如果定义了 `restrict_tcp_ports`，仅允许从本机 IP 地址访问这些端口。

8. **允许管理员 IP 地址的流量**：
   ```bash
   iptables -I INPUT -s ${admin_ip} -j ACCEPT
   iptables -I OUTPUT -d ${admin_ip} -j ACCEPT
   ```
    - 如果定义了管理员 IP 地址，允许该 IP 地址的流量。

9. **输出当前的 `iptables` 配置**：
   ```bash
   iptables -L -v -n
   ```
    - 显示当前的 `iptables` 规则，以供检查。

---

### **常见问题**

1. **脚本运行后无法访问某些服务**：
    - 请确保你已经正确设置了 `allowed_tcp_ports`，并且没有误将你需要的端口封锁。如果需要，检查是否需要为特定的服务添加额外的端口规则。

2. **无法获取 IP 地址**：
    - 确保主机的网络接口已正确配置，并且可以访问网络。如果无法获取 IP 地址，脚本将会停止执行。

3. **`iptables` 规则没有生效**：
    - 确保脚本以管理员身份运行。`iptables` 需要管理员权限才能更改防火墙规则。

---

### **建议**

- 在生产环境中使用此脚本时，确保你已经完全了解开放哪些端口对系统安全性的重要性。
- 定期备份和审计防火墙规则，防止意外配置导致的安全风险。

