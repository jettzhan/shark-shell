## 作用

可以查看某个jar 是由那个依赖间接依赖；尤其是在当依赖冲突的时候，可以判断出来。

## 命令

```shell
mvn dependency:tree -s C:\Users\YPRJ\.m2\settingsCompany.xml
```


在 Maven 中，如果你想在执行 `mvn dependency:tree` 时指定特定的配置文件（`settings.xml`），可以使用 `-s` 或 `--settings` 参数来指定自定义的 `settings.xml` 文件路径。  

### **1. 基本用法**
```bash
mvn dependency:tree -s /path/to/custom-settings.xml
```
或（`--settings` 是完整写法）：
```bash
mvn dependency:tree --settings /path/to/custom-settings.xml
```

### **2. 示例**
假设你的自定义 `settings.xml` 位于 `~/maven/custom-settings.xml`，则可以运行：
```bash
mvn dependency:tree -s ~/maven/custom-settings.xml
```

### **3. 其他常用参数**
- **`-Dverbose`**：显示更详细的依赖树（包括冲突和重复依赖）：
  ```bash
  mvn dependency:tree -Dverbose
  ```
- **`-Dincludes`**：只显示特定依赖（支持 `groupId:artifactId:version` 通配）：
  ```bash
  mvn dependency:tree -Dincludes=org.apache.logging.log4j:log4j-core
  ```

### **4. 默认 `settings.xml` 位置**
Maven 默认会按以下顺序查找 `settings.xml`：
1. **命令行指定**（`-s /path/to/settings.xml`）
2. **`${user.home}/.m2/settings.xml`**（用户级配置）
3. **`${maven.home}/conf/settings.xml`**（全局配置）

### **5. 结合 `-P` 指定 Profile**
如果 `settings.xml` 里定义了 `<profiles>`，可以用 `-P` 激活：
```bash
mvn dependency:tree -s ~/maven/custom-settings.xml -Pmy-profile
```

### **总结**
| 命令 | 作用 |
|------|------|
| `mvn dependency:tree -s /path/to/settings.xml` | 使用指定的 `settings.xml` |
| `mvn dependency:tree -Dverbose` | 显示详细依赖树 |
| `mvn dependency:tree -Dincludes=groupId:artifactId` | 只显示特定依赖 |
| `mvn dependency:tree -Pprofile-name` | 激活指定 Profile |

这样你可以灵活控制 Maven 的依赖解析行为。