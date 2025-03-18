#!/bin/bash
# author: noodzhan@163.com

# 定义源目录和目标目录
source_dir="/path/to/source"
target_dir="/path/to/target"

# 获取当前日期
current_date=$(date +"%Y%m%d")

# 创建以当前日期为名称的目标文件夹
backup_dir="${target_dir}/${current_date}"
mkdir -p "$backup_dir"

# 复制源目录到目标目录
cp -R "$source_dir" "$backup_dir"

# 压缩目标目录
tar -czvf "${target_dir}/backup_${current_date}.tar.gz" "$backup_dir"

# 删除旧的备份文件，保留最近两个
cd "$target_dir"
ls -t backup_*.tar.gz | tail -n +3 | xargs rm -f

# 清理临时目录
rm -rf "$backup_dir"
