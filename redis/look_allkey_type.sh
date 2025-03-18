#!/bin/bash

# 初始化游标
cursor=0

while [ "$cursor" != "0" ]; do
    # 扫描获取键列表
    result=$(redis-cli scan $cursor)

    # 提取游标和键列表
    cursor=$(echo "$result" | awk '{print $1}')
    keys=$(echo "$result" | awk '{$1=""; print $0}' | tr -d '[:space:]')

    # 对每个键检查类型
    for key in $keys; do
        # 获取键的类型
        type=$(redis-cli type "$key")

        # 如果键的类型是list，则打印键名
        if [ "$type" == "list" ]; then
            echo "List key: $key"
        fi
    done
done
