#!/bin/bash

# author: noodzhan@163.com
# 通过参数传递 PostgreSQL 用户、主机和备份目录，支持当前目录作为默认备份目录
PGUSER=$1
PGHOST=$2
dir=$3

# 检查参数是否存在
if [[ -z "$PGUSER" || -z "$PGHOST" ]]; then
  echo "Usage: $0 <PGUSER> <PGHOST> [BACKUP_DIR]"
  exit 1
fi

# 如果没有提供备份目录，则使用当前目录
if [[ -z "$dir" ]]; then
  dir="./"  # 当前目录
fi

# 获取所有非模板数据库名称
databases=$(psql -U $PGUSER -h $PGHOST -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

# 循环遍历每个数据库并导出
for db in $databases
do
  if [[ -n "$db" ]]; then  # Skip empty lines
    # 使用 pg_dump 导出每个数据库
    echo "Backing up database: $db"

    pg_dump -U $PGUSER -h $PGHOST -F c -b -v -f "$dir$db.backup" $db
    if [ $? -eq 0 ]; then
        echo "Backup of $db succeeded."
    else
        echo "Backup of $db failed."
    fi
  fi
done

echo "Backup completed."
