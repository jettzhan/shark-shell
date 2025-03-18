#!/bin/bash
# author: noodzhan@163.com

# 全局配置变量
threshold_days=5                                # 删除天数阈值
size_threshold_gb=1                          # 目录大小阈值（GB）
size_threshold_mb=$((size_threshold_gb * 1024)) # 将GB转换为MB

# 指定要检测和删除文件的目录列表
dirs=("/var/log/nginx/access.log" "/var/log/taos/taos.log")

# 遍历每个目录
for dir in "${dirs[@]}"; do
  # 使用 du 命令获取目录大小（单位为KB）
  dir_size_kb=$(du -s "$dir" | awk '{print $1}')

  # 将KB转换为MB
  dir_size_mb=$((dir_size_kb / 1024))

  # 检查目录大小是否大于阈值
  if [ "$dir_size_mb" -gt "$size_threshold_mb" ]; then
    echo "Directory $dir size is greater than $size_threshold_gb GB ($dir_size_mb MB)"

    # 计算删除日期
    delete_date=$(date -d "$threshold_days days ago" "+%Y%m%d")

    # 删除指定日期之前的文件
    find "$dir" -type f -mtime +$threshold_days | while read file; do
      file_date=$(date -r "$file" "+%Y%m%d")
      if [ "$file_date" -le "$delete_date" ]; then
        rm "$file"
        echo "Deleted old file: $file"
      fi
    done
  else
    echo "Directory $dir size is not greater than $size_threshold_gb GB ($dir_size_mb MB)"
  fi
done
