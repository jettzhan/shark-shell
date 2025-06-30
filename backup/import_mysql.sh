#!/bin/bash

BAKDIR="/opt/mysqlbackup"
DBUSER=root
DBPWD=123456
HOST="127.0.0.1"

echo 'import mysql'

for file in $(ls ${BAKDIR}/*.sql); do
  # 获取数据库名称
  DBNAME=$(basename $file | cut -d'2' -f1 | rev | cut -c2- | rev)

  echo "Importing database: ${DBNAME}"

  echo $file

  mysql -h${HOST} -u${DBUSER} -p${DBPWD} -e "DROP DATABASE IF EXISTS ${DBNAME};"

  # 创建新数据库
  mysql -h${HOST} -u${DBUSER} -p${DBPWD} -e "CREATE DATABASE ${DBNAME};"

  mysql -h${HOST} -u${DBUSER} -p${DBPWD} ${DBNAME} <$file

done

echo 'MySQL import completed'
