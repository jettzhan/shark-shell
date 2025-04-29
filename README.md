# Shark Shell

## 项目简介

Shark Shell 是一个用于管理和自动化常见系统任务的脚本集合。它汇集了在工作中和业余时间开发的各种 Shell 脚本，旨在简化软件安装、配置、启动等任务。该项目涵盖了常见的系统服务与应用的部署，并通过不断的迭代开发，确保脚本的有效性和易用性。

## 功能概述

Shark Shell 包含多个功能模块，适用于不同的系统管理需求。以下是各模块的简要介绍：

| 目录                  | 功能简介                                       |
|---------------------|-------------------------------------------|
| **backup**           | 提供定时备份功能，支持对 Shell 脚本、MySQL 和 PostgreSQL 数据库进行定期备份。      |
| **docker**           | 提供多个常见服务（如 MySQL、Jira、Redis、Taos 等）的 Docker Compose 配置文件。 |
| **es**               | 自动安装和配置 Elastic Stack（包括 Filebeat 和 Logstash），用于日志收集与处理。 |
| **firewall**         | 提供防火墙配置脚本，详细说明如何配置和管理防火墙。                               |
| **check**             | 提供系统检查功能，包括 Yarn 包管理器检查等。                           |
| **chk_frps**          | 实时监控 frp 内网穿透服务的状态，确保网络穿透功能正常。                        |
| **chk_https**         | 检查 SSL 证书有效期，确保网站安全性。                                 |
| **chk_logs**          | 提供日志自动清理功能，防止日志文件过大影响系统性能。                         |
| **githooks**         | 配置 Git 钩子（pre-commit 和 pre-push），在代码提交和推送时进行自动化检查。     |
| **grafana**          | 自动安装并配置 Grafana，用于监控 Taos 数据库。                            |
| **minio**            | 提供 MinIO 一键安装脚本，快速搭建分布式对象存储服务。                           |
| **prometheus**       | 安装并配置 Prometheus，用于监控 Linux 系统、Kafka、MySQL 和 PostgreSQL 等服务。 |
| **subversion**       | 提供 Subversion (SVN) 安装脚本，帮助快速搭建版本控制系统。                   |
| **taos**             | 自动化安装和配置 Taos 数据库，支持与脚本的配合执行。                       |
| **guard_kafka**         | 用于监控 Kafka 服务的运行状态，确保系统服务的健康。                   |
| **guard_nacos**         | 用于监控 Nacos 服务的运行状态，确保系统服务的健康。                   |


## 安装与使用

### 系统要求

- Linux 系统（支持常见的 Linux 发行版，如 Ubuntu、CentOS 等）
- 已安装 Docker 和 Docker Compose（对于涉及 Docker 容器的功能）
- 管理员权限（需要使用 `sudo` 执行脚本）

### 获取项目

你可以通过 Git 克隆项目代码：

```bash
git clone https://github.com/noodzhan/shark-shell.git
```

### 运行脚本

每个模块通常包含一个独立的脚本文件，你可以进入相应目录并执行脚本。例如：

1. **kafka监控：**

进入 `guard_kafka` 目录：

```bash
cd guard_kafka
./guard_kafka.sh
```

2. **备份脚本：**

进入 `backup` 目录：

```bash
cd backup
./backup_dir.sh
```

3. **Prometheus 监控配置：**

进入 `prometheus` 目录：

```bash
cd prometheus
./install_prometheus.sh
```

每个模块都提供了详细的安装说明和使用指南，你可以根据需要选择相应的脚本进行操作。

## 贡献指南

欢迎大家为 Shark Shell 项目贡献代码和脚本！以下是如何贡献的基本步骤：

1. Fork 项目并创建自己的分支。
2. 提交改动并确保脚本通过基本的测试。
3. 创建 Pull Request（PR），并简要描述你所做的更改。

## 授权协议

Shark Shell 遵循 MIT 开源协议，你可以自由使用和修改该项目的代码。

---

### 结语

Shark Shell 是一个方便的工具集，旨在提高工作效率并简化常见的系统管理任务。随着社区的贡献和项目的持续迭代，它将成为你在 Linux 环境中自动化任务的得力助手。如果有任何问题或建议，欢迎提出！