#!/bin/bash

# 进入dockers目录
cd dockers || exit

# 遍历dockers下的所有子目录
for dir in */; do
    # 去除目录名后的斜杠
    dir_name=${dir%/}
    echo "正在压缩目录: $dir_name"

    # 压缩目录为zip文件
    zip -r "../${dir_name}.zip" "$dir_name"
done

echo "所有docker子目录已压缩完成"