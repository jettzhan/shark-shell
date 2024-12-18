#!/bin/bash

# 设置 PostgreSQL 用户和主机
PGUSER="postgres"
PGHOST="127.0.0.1"

dir=""

# 获取所有非模板数据库名称
databases=$(psql -U $PGUSER -h $PGHOST -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

# 循环遍历每个数据库并导出
for db in $databases
do
  # 使用 pg_dump 导出每个数据库
  echo "Backing up database: $db"
  pg_dump -U $PGUSER -h $PGHOST -F c -b -v -f "$dir$db.backup" $db
done

echo "Backup completed."
