#!/bin/bash

# 设置数据库连接信息
PGUSER="postgres"
PGHOST="127.0.0.1"

# 获取当前目录下所有以 .backup 结尾的文件
BACKUP_FILES=$(find . -type f -name "*.backup")

# 循环遍历每个备份文件并使用 pg_restore 导入
for BACKUP_FILE in $BACKUP_FILES; do
  # 提取备份文件的基础名称（不包含路径和扩展名）
  TARGET_DB=$(basename "$BACKUP_FILE" .backup)

  # 创建目标数据库（如果数据库不存在的话）
  echo "正在创建数据库：$TARGET_DB（如果不存在）"
  psql -U $PGUSER -h $PGHOST -c "CREATE DATABASE $TARGET_DB;" 2>/dev/null

  # 使用 pg_restore 恢复数据库
  echo "正在恢复数据库：$TARGET_DB 从备份文件：$BACKUP_FILE"
  pg_restore -U $PGUSER -h $PGHOST -d $TARGET_DB -v $BACKUP_FILE

  # 检查恢复是否成功
  if [ $? -eq 0 ]; then
    echo "恢复成功: $BACKUP_FILE 到数据库 $TARGET_DB"
  else
    echo "恢复失败: $BACKUP_FILE"
  fi
done
