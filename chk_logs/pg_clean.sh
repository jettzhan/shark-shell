#!/bin/bash

# author: zhanzhihu
# mail: noodzhan@163.com

# 定义数据库用户名、密码和数据库名称
DB_USER="postgres"
DB_PASSWORD="postgres"
DB_NAME="thingsboard"

# description: 清理postgresql的ts_kv_*表，清理规则为3个月前的数据，清理前判断磁盘 / 目录的使用率是否大于 80%，如果大于 80%，则执行清理，否则不执行清理。

# 定义日志文件路径
LOG_FILE="$HOME/pg_clean.log"

echo "$LOG_FILE"

# 记录脚本开始执行
echo "$(date '+%Y-%m-%d %H:%M:%S') - Script started." >>$LOG_FILE

clean_sql="DO \$\$
           DECLARE
               partition_name text;
           BEGIN
               FOR partition_name IN
                   SELECT table_name
                   FROM information_schema.tables
                   WHERE table_name LIKE 'ts_kv_%'
                     AND table_name < 'ts_kv_' || to_char(now() - interval '3 months', 'YYYY_MM')
               LOOP
                   EXECUTE 'DROP TABLE IF EXISTS '|| partition_name;
               END LOOP;
           END \$\$;"

# 获取磁盘 / 目录的使用率
usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# 判断使用率是否大于 80%
if [ $usage -gt 80 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - 磁盘 / 目录使用率超过 80%，执行脚本。" >>$LOG_FILE

  echo "$clean_sql" >/tmp/clean_sql.sql

  # 执行指定脚本
  sudo -i -u $DB_USER psql -U $DB_USER -d $DB_NAME -f /tmp/clean_sql.sql 2>>$LOG_FILE

  echo -e "$(date '+%Y-%m-%d %H:%M:%S') - SQL 脚本。\n $clean_sql" >>$LOG_FILE

  if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - SQL 脚本执行成功。" >>$LOG_FILE
  else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - SQL 脚本执行失败。" >>$LOG_FILE
  fi
else
  echo "$(date '+%Y-%m-%d %H:%M:%S') - 磁盘 / 目录使用率未超过 80%，不执行脚本。" >>$LOG_FILE
fi

# 记录脚本执行结束
echo "$(date '+%Y-%m-%d %H:%M:%S') - Script finished." >>$LOG_FILE
