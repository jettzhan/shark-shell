#!/bin/bash

# Kafka 安装路径
KAFKA_PATH="/usr/local/kafka/bin"
# Kafka 主题
KAFKA_TOPIC="your_topic"
# Kafka 消费者组
KAFKA_GROUP="alarm_group"

# 统计 Kafka 消息的生产量和消费量

# 初始化上一次的值
LAST_PRODUCED=0
LAST_CONSUMED=0
FIRST_RUN=true

while true; do
    echo "当前时间: $(date)"

    # 获取消费者组信息
    $KAFKA_PATH/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group $KAFKA_GROUP
    CONSUMER_INFO=$($KAFKA_PATH/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group $KAFKA_GROUP)
    # 提取消息的生产量和消费量
    PRODUCED=$(echo "$CONSUMER_INFO" | awk '/CURRENT-OFFSET/ {getline; print $5}')
    CONSUMED=$(echo "$CONSUMER_INFO" | awk '/CURRENT-OFFSET/ {getline; print $4}')

    # 输出统计结果
    echo "消息生产量偏移: $PRODUCED"
    echo "消息消费量偏移: $CONSUMED"
    echo "--------------------------"

    # 计算差值
    if $FIRST_RUN; then
        PRODUCED_DIFF=0
        CONSUMED_DIFF=0
        FIRST_RUN=false
    else
        PRODUCED_DIFF=$((PRODUCED - LAST_PRODUCED))
        CONSUMED_DIFF=$((CONSUMED - LAST_CONSUMED))
    fi

    # 计算比值（避免除数为0）
    if [ $CONSUMED_DIFF -ne 0 ]; then
        RATIO=$(echo "scale=2; $PRODUCED_DIFF / $CONSUMED_DIFF" | bc)
    else
        RATIO="N/A"
    fi

    # 输出统计结果
    echo "消息生产量: $PRODUCED (差值: $PRODUCED_DIFF)"
    echo "消息消费量: $CONSUMED (差值: $CONSUMED_DIFF)"
    echo "生产/消费比值: $RATIO"
    echo "--------------------------"

    # 更新上一次的值
    LAST_PRODUCED=$PRODUCED
    LAST_CONSUMED=$CONSUMED

    # 等待 5 分钟
    sleep 300
done