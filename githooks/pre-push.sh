#!/bin/sh

# 获取本地分支和远程分支的名称
local_branch=$(git rev-parse --abbrev-ref HEAD)
remote_branch=$(git rev-parse --abbrev-ref @{u})

# 判断是否有远程分支
if [ -z "$remote_branch" ]; then
	echo '没有设置远程分支upstream'
	if [ $(git show --name-status HEAD | grep 'pom.xml' | wc -l) -gt 0 ]; then
		exit 0
	else
		echo -e "\033[31mfatal: 本次push内容没有修改pom文件，可能是版本号没有修改\033[0m"
		exit 1
	fi
else
	if [ $(git diff --name-only $local_branch..$remote_branch |grep 'pom.xml' | wc -l ) -le 0 ]; then
		echo -e "\033[31mfatal: 本次push内容没有修改pom文件，可能是版本号没有修改\033[0m"
			exit 1
	fi
	exit 0
fi


