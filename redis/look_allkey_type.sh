#!/bin/bash
cursor=0
while [ "$cursor" != "0" ]; do
    # 扫描获取键列表
    result=$(redis-cli scan $cursor)
    cursor=$(echo $result | awk '{print \$1}')
    keys=$(echo $result | awk '{\$1=""; print \$0}')

    # 对每个键检查类型
    for key in $keys; do
        type=$(redis-cli type $key)
        if [ "$type" == "list" ]; then
            echo "List key: $key"
        fi
    done
done
