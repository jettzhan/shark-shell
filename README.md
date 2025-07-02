# Shark Shell

![GitHub](https://img.shields.io/github/license/jettzhan/shark-shell?style=flat-square)
![GitHub](https://img.shields.io/github/stars/jettzhan/shark-shell?style=flat-square)
![GitHub](https://img.shields.io/github/forks/jettzhan/shark-shell?style=flat-square)
![release](https://img.shields.io/github/v/release/jettzhan/shark-shell)

## 项目简介

Shark Shell 是一个用于管理和自动化常见系统任务的脚本集合。它汇集了在工作中和业余时间开发的各种 Shell
脚本，旨在简化软件安装、配置、启动等任务。该项目涵盖了常见的系统服务与应用的部署，并通过不断的迭代开发，确保脚本的有效性和易用性。 [Github](https://github.com/jettzhan/shark-shell) [Gitee](https://gitee.com/JettZhan/shark-shell)

## 功能概述

即可整体使用，也可单独脚本使用。

```shell
sudo git clone https://github.com/jettzhan/shark-shell.git /opt/shark-shell
```

```shell
sudo git clone https://gitee.com/JettZhan/shark-shell /opt/shark-shell
```

### 监控脚本

| 脚本                           | 下载                                                           | 功能描述                                                         | crontab                                                 |
| ------------------------------ | -------------------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------- |
| Java进程监控                   | [guard_java.sh](https://noodb.com/sharkshell/guard/guard_java.sh)        | 根据端口，监控进程；可自定配置启动命令；可以定制修改。           | 0 2 * * * /opt/shark-shell/guard/guard_java.sh          |
| MySQL监控                      | [guard_mysql.sh](https://noodb.com/sharkshell/guard/guard_mysql.sh)       | 根据端口，监控进程；可自定配置启动命令；可以定制修改。           | 0 2 * * * /opt/shark-shell/guard/guard_mysql.sh         |
| Redis监控                      | [guard_redis.sh](https://noodb.com/sharkshell/guard/guard_redis.sh)       | 根据端口，监控进程；可自定配置启动命令；可以定制修改。           | 0 2 * * * /opt/shark-shell/guard/guard_redis.sh         |
| Kafka进程监控                  | [guard_kafka.sh](https://noodb.com/sharkshell/guard/guard_kafka.sh)       | 监控Kafka进程；异常先启动zookeeper,然后是kafka。                 | */5 * * * * /opt/shark-shell/guard/guard_kafka.sh       |
| Nacos进程监控                  | [guard_nacos.sh](https://noodb.com/sharkshell/guard/guard_nacos.sh)       | 先判断端口，然后在通过登录来判断Nacos 是否存活。                 | */5 * * * * /opt/shark-shell/guard/guard_nacos.sh       |
| 监控frps服务                   | [check_frps.sh](https://noodb.com/sharkshell/chk_frps/check_frps.sh)     | 监控frps某些服务是否在线，不在先就email通知                      | */5 * * * * /opt/shark-shell/chk_frps/check_frps.sh     |
| 自动清理日志                   | [auto_clean_log.sh](https://noodb.com/sharkshell/chk_logs/auto_clean_log.sh) | 自动清理指定目录下超过5天的日志文件，当目录大小超过1GB时触发清理 | */5 * * * * /opt/shark-shell/chk_logs/auto_clean_log.sh |
| 自动清理thingsboard ts_kv 分表 | [pg_clean.sh](https://noodb.com/sharkshell/chk_logs/pg_clean.sh) | 自动清理thingsboard ts_kv 分表；保留最近三个月 | */5 * * * * /opt/shark-shell/chk_logs/pg_clean.sh |
| 防火墙初始化 | [firewall_init.sh](https://noodb.com/sharkshell/firewall/firewall_init.sh) | 初始化iptables防火墙规则，设置默认策略和允许端口 | 无 |
| IP白名单管理 | [white_table.sh](https://noodb.com/sharkshell/firewall/white_table.sh) | 管理IP白名单和端口访问控制 | 无 |

### 备份脚本

| 脚本                   | 下载                                                       | 功能描述                                                                                 | crontab                                           |
| ---------------------- | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------- |
| 备份目录               | [backup_dir.sh](https://noodb.com/sharkshell/backup/backup_dir.sh)   | 备份目录到指定目录,保留最近2次文件；可以备份数据库目录 /var/lib/mysql；或者应用/opt/apps | */5 * * * * /opt/shark-shell/backup/backup_dir.sh |
| MySQL全库Dump备份      | [backup_mysql.sh](https://noodb.com/sharkshell/backup/backup_mysql.sh) | 备份MySQL所有数据库到指定目录；也可只指定数据库                                          | */5 * * * * /opt/shark-shell/backup/backup_dir.sh |
| MySQL备份导入          | [import_mysql.sh](https://noodb.com/sharkshell/backup/import_mysql.sh) | 导入通过backup_mysql.sh备份的数据库                                                      | 无                                                |
| PostgreSQL全库Dump备份 | [backup_pg.sh](https://noodb.com/sharkshell/backup/backup_pg.sh)    | 备份postgresql所有数据库到指定目录；也可只指定数据库                                     | */5 * * * * /opt/shark-shell/backup/backup_pg.sh  |
| PostgreSQL备份导入     | [import_pg.sh](https://noodb.com/sharkshell/backup/import_pg.sh)    | 导入通过backup_pg.sh备份的数据库                                                         | 无                                                |

### Docker 安装软件

| 软件                 | 下载链接                                                         | 安装命令                                            |
| -------------------- | ---------------------------------------------------------------- | --------------------------------------------------- |
| openeuler 安装docker | [docker_install_el.sh](https://noodb.com/sharkshell/dockers/docker_install_el.sh) | `bash docker_install_el.sh`                         |
| 通用linux安装docker  | [docker_install.sh](https://noodb.com/sharkshell/dockers/docker_install.sh) | `bash docker_install.sh`                         |
| calibre-web          | [calibre-web.zip](https://noodb.com/sharkshell/dockers/calibre-web.zip)      | `unzip calibre-web.zip && docker-compose up -d`     |
| gitlab               | [gitlab.zip](https://noodb.com/sharkshell/dockers/gitlab.zip)           | `unzip gitlab.zip && docker-compose up -d`          |
| jira                 | [jira.zip](https://noodb.com/sharkshell/dockers/jira.zip)             | `unzip jira.zip && docker-compose up -d`            |
| mcms                 | [mcms.zip](https://noodb.com/sharkshell/dockers/mcms.zip)             | `unzip mcms.zip && docker-compose up -d`            |
| mysql                | [mysql.zip](https://noodb.com/sharkshell/dockers/mysql.zip)            | `unzip mysql.zip && docker-compose up -d`           |
| poste                | [poste.zip](https://noodb.com/sharkshell/dockers/poste.zip)            | `unzip poste.zip && docker-compose up -d`           |
| postgres-single      | [postgres-single.zip](https://noodb.com/sharkshell/dockers/postgres-single.zip)  | `unzip postgres-single.zip && docker-compose up -d` |
| redis                | [redis.zip](https://noodb.com/sharkshell/dockers/redis.zip)            | `unzip redis.zip && docker-compose up -d`           |
| taos                 | [taos.zip](https://noodb.com/sharkshell/dockers/taos.zip)             | `unzip taos.zip && docker-compose up -d`            |
| thingsboard          | [thingsboard.zip](https://noodb.com/sharkshell/dockers/thingsboard.zip)      | `unzip thingsboard.zip && docker-compose up -d`     |

## 代码规范，易扩展

比如

```shell
#!/bin/bash

# 配置端口和对应的启动命令
ports=("8081" "8099")
commands=(
    "nohup java -jar /opt/nbcio/nbcio-boot-module-system-3.1.jar > /dev/null 2>&1 &"
    "nohup java -jar -Dspring.profiles.active=prod /opt/service/taos/jeecg-system-start-3.4.4.jar > /dev/null 2>&1 &"
)

# 检查端口是否在监听状态
check_port() {
    local port=$1
    netstat -tunlp | grep ":$port " | wc -l
}

# 主循环
for i in "${!ports[@]}"; do
    if [[ $(check_port "${ports[i]}") -eq 0 ]]; then
        echo "端口 ${ports[i]} 未监听，执行启动命令: ${commands[i]}"
        eval "${commands[i]}"
    else
        echo "端口 ${ports[i]} 已监听"
    fi
done
```

## 文章集合

[多次失败登录，锁住账号.md](./0doc/多次失败登录，锁住账号.md)   
[禁止ssh连接root用户.md](./0doc/禁止ssh连接root用户.md)   
[禁用telnet服务.md](./0doc/禁用telnet服务.md)   
[linux如何用iptables做网路完全控制](./firewall/README.md)
[linux增加tmp大小.md](./0doc/linux增加tmp大小.md)   
[linux资源使用情况定位.md](./0doc/linux资源使用情况定位.md)   
[maven如何查看jar的依赖来源.md](./0doc/maven如何查看jar的依赖来源.md)   
[xfs_growfs命令和resize2fs命令.md](./0doc/xfs_growfs 命令和resize2fs命令.md)

---

## star

[![Star History Chart](https://api.star-history.com/svg?repos=jettzhan/shark-shell&type=Date)](https://www.star-history.com/#jettzhan/shark-shell&Date)
