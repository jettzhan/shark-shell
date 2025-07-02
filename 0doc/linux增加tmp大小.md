要为 `tmpfs` 挂载的 `/tmp` 目录扩容，您可以通过以下方法调整其大小。`tmpfs` 是内存文件系统，其大小由挂载参数控制，可以动态调整而无需重启系统。

---

### **方法 1：临时调整 `/tmp` 大小（重启失效）**
直接重新挂载 `/tmp` 并指定新的大小（例如扩容到 `3GB`）：
```bash
sudo mount -o remount,size=3G /tmp
```
**验证是否生效：**
```bash
df -h /tmp
```
**输出示例：**
```
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           3.0G  1.7G  1.3G  57% /tmp
```

---

### **方法 2：永久调整 `/tmp` 大小（修改 `/etc/fstab`）**
如果希望系统启动时自动使用指定大小的 `/tmp`，可以修改 `/etc/fstab`：

1. **备份 `/etc/fstab`（重要！）**
   ```bash
   sudo cp /etc/fstab /etc/fstab.bak
   ```

2. **编辑 `/etc/fstab`**
   ```bash
   sudo vim /etc/fstab
   ```
   找到 `/tmp` 的挂载行（如果没有，就新增一行），并添加 `size=3G` 选项：
   ```
   tmpfs /tmp tmpfs defaults,size=3G 0 0
   ```
   **保存并退出**（`vim` 下按 `:wq`）。

3. **重新挂载 `/tmp`**
   ```bash
   sudo mount -o remount /tmp
   ```

4. **验证**
   ```bash
   df -h /tmp
   ```
   应该显示 `/tmp` 已扩容。

---

### **方法 3：清理 `/tmp` 以释放空间（无需扩容）**
如果 `/tmp` 被占满，可以先尝试清理大文件：
```bash
# 查看 /tmp 中最大的文件
sudo ls -lhS /tmp | head -10

# 删除不需要的文件（谨慎操作！）
sudo rm -rf /tmp/大文件或目录
```

---

### **注意事项**
1. **`tmpfs` 占用内存和交换分区**：`/tmp` 扩容意味着它会占用更多 RAM + Swap，如果设置过大，可能导致系统内存不足。
2. **临时调整 vs 永久调整**：
   - **临时调整**（`mount -o remount`）立即生效，但重启后恢复默认值。
   - **永久调整**（修改 `/etc/fstab`）需谨慎，错误的配置可能导致系统无法启动。
3. **默认 `/tmp` 大小**：通常为物理内存的 50%，但不同 Linux 发行版可能不同。

---

### **推荐方案**
- 如果只是临时需要更多空间，用 **方法 1**（`mount -o remount`）。
- 如果长期需要更大的 `/tmp`，用 **方法 2**（修改 `/etc/fstab`）。
- 如果 `/tmp` 里有垃圾文件，优先用 **方法 3**（清理文件）。

如果仍有问题，请提供：
```bash
cat /etc/fstab | grep tmpfs
mount | grep tmpfs
```
以便进一步分析。