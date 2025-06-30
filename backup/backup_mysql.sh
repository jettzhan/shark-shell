#!/bin/bash
# author: noodzhan@163.com

BAKDIR="/opt/mysqlbackup"
DBUSER=root
DBPWD=123456
HOST="127.0.0.1"
mkdir -p ${BAKDIR}
dbs=`/usr/bin/mysql -h${HOST} -u${DBUSER} -p${DBPWD} -e "show databases;" |grep -v \+ |grep -v Database |grep -v mysql | grep -v test |grep -v sys |grep -v information_schema |grep -v performance_schema`
for db in ${dbs}
do
  mysqldump -u${DBUSER} -p${DBPWD} -h${HOST}  -R ${db} |gzip >"${BAKDIR}"/${db}_`date +%F-%H:%M`.sql.gz
  if [ $? -eq 0 ]
  then
    count=`ls -lrt ${BAKDIR} |grep "${db}_.*\.sql.gz" |wc -l`
    if [ ${count} -gt 3 ]
    then
       del_count=$[ count - 3 ]
       ls -lrt  ${BAKDIR} |grep "${db}_.*\.sql.gz" |awk '{print $9}'|sed -n "1,${del_count}p" >/tmp/del_sql.log
       cd ${BAKDIR}
       for i in `cat /tmp/del_sql.log`
       do
           echo $i
          #rm -rf ${i}
       done
      cd -
    fi
  fi
done
