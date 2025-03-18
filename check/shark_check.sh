#!/bin/bash

# author: zhanzhihu
# datetime: 2025/01/22
# 让实施人员降低对linux系统的要求，只要求熟悉sharkcheck一个命令，就可以定位发现问题;并处理问题，提供可预见的解决方案。 目前支持centos操作系统

app_path="/opt/app/services"

debug=0
check_port() {
  is_alive=$(sudo netstat -tunlp | grep $2 | grep -v 'grep' | wc -l)
  if [ $is_alive -eq 0 ]; then
    echo_error "\033[31m$1 port $2 ------------is fail\033[0m"
    return 1
  fi
  echo "$1 port $2 ------------is ok"
  return 0
}

# 从环境变量获取 service_name 和 service_port，如果未设置则使用默认值；默认配置在~/.bashrc中
if [ -z "$SERVICE_NAMES" ]; then
  service_name=("nacos" "mysql" "postgresql" "kafka" "zookeeper" "minio" "thingsboard" "taos" "nginx")
else
  service_name=($(echo $SERVICE_NAMES | tr ',' '\n'))
fi

if [ -z "$SERVICE_PORTS" ]; then
  service_port=("8848" "3306" "5432" "9092" "2181" "9000" "8080" "6030" "80")
else
  service_port=($(echo $SERVICE_PORTS | tr ',' '\n'))
fi

# 从环境变量获取 app_name 和 app_port，如果未设置则使用默认值
if [ -z "$APP_NAMES" ]; then
  app_name=("app1" "app2" "app3")
else
  app_name=($(echo $APP_NAMES | tr ',' '\n'))
fi

if [ -z "$APP_PORTS" ]; then
  app_port=("8080" "8081" "8082")
else
  app_port=($(echo $APP_PORTS | tr ',' '\n'))
fi


if [ ${#service_name[@]} -ne ${#service_port[@]} ]; then
  echo "config is error,please check it"
fi

check_all_port() {
  #  echo "===============check service================"
  service_index=0
  for name in ${service_name[@]}; do
    check_port $name ${service_port[$service_index]}
    ((service_index++))
  done
  #  echo "=================check app===================="
  app_index=0
  for name in ${app_name[@]}; do
    check_port $name ${app_port[app_index]}
    ((app_index++))
  done

}

echo_error() {
  echo -e "\033[31m$1\033[0m"
}

check_docker() {
  #  echo "===============check docker================"
  has_docker=$(which docker | wc -l)
  exec_cmd_detail "which docker"
  if [ $has_docker -eq 0 ]; then
    echo "no docker"
    return 1
  fi
  active=$(sudo systemctl is-active docker)
  if [ "$active"!="active" ]; then
    echo_error "docker process -------------- is fail"
  else
    sudo docker ps
  fi
}

check_dog() {
  #  echo "===========check dog=============="
  exec_cmd_detail "crontab -l"
  cron=$(crontab -l | grep skcron | wc -l)
  if [ $cron -gt 0 ]; then
    echo "ypcron -------------------is ok"
  else
    echo_error "ypcron ---------------is fail"
  fi
}

show_os_version() {
  cat /etc/os-release
}

exec_cmd_detail() {
  cmd=$1
  if [ $debug -eq 1 ]; then
    echo $cmd
    eval $cmd
  fi
}

show_app_version() {
  total=0
  for dir in "$app_path/*/"; do
    # 使用 sudo 列出目录中的 .jar 文件
    first_jar=$(sudo ls -ct $dir | grep jar | head -n 1)
    if [[ -n "$first_jar" ]]; then
      # 使用 basename 去掉路径，仅显示文件名
      echo "$dir $first_jar"
      ((total++))
    fi
  done
  echo "total $total"
}

show_help() {
  echo "帮助信息："
  echo "  sharkcheck h           ; 查看帮助信息"
  echo "  sharkcheck             ; 检查所有系统和应用是否正常运行"
  echo "  sharkcheck osv         ; 查看系统版本"
  echo "  sharkcheck appv        ; 查看应用版本"
  echo "  sharkcheck port        ; 查看应用端口是否正常"
  echo "  sharkcheck disk        ; 查看磁盘使用情况"
  echo "  sharkcheck docker      ; 查看docker是否正常"
  echo "  sharkcheck dog         ; 查看看门狗是否配置"
  echo "  sharkcheck status      ; 查看应用运行所使用的内存和cpu占用情况"
}

# 查看应用运行所使用的内存和cpu占用情况
show_app_runtime_status() {
  echo "------------os-----------------"
  sudo free -lh

  #  echo "------------cpu-----------------"
  #
  #  sudo lscpu

  echo "------------app-----------------"
  java_pid=$(sudo ps uax | grep java | grep javaagent | awk '{print $2}' | paste -sd, -)
  if [ -z $java_pid ]; then
    echo_error "java process is not running"
    return 1
  fi
  sudo ps -p $java_pid -o %cpu,%mem,cmd --sort=-%cpu,-%mem
}

check_all() {
  check_all_port
  check_dog
  check_docker
  check_disk
}

check_disk() {
  # Define the directories to check
  directories=("/" "/home")
  flag=0
  # Loop through each directory to check its disk usage
  exec_cmd_detail "df -h"
  for dir in "${directories[@]}"; do
    # Get the disk usage of the directory
    disk_usage=$(df "$dir" | awk 'NR==2 {print $5}' | sed 's/%//')

    # Check if the disk usage is greater than 80%
    if [ -n $disk_usage ] && [ "$disk_usage" -gt 80 ]; then
      #      echo_error "Warning: Disk usage for $dir exceeds 80%, current usage is $disk_usage%"
      flag=1
      #    else
      #      echo "$dir disk usage is normal: $disk_usage%"
    fi
  done
  if [ $flag -ne 0 ]; then
    echo_error "disk usage -----------------------------is fail"
    return 1
  fi
  echo "disk usage -----------------------------is ok"
  return 0
}

if [ $# -eq 0 ]; then
  check_all
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
  -v)
    echo "sharkcheck version is v1.0.0"
    shift
    ;;
  -osv | osv | osversion)
    show_os_version
    shift
    ;;
  -appv | appv | appversion)
    show_app_version
    shift
    ;;
  -p | port | p)
    echo "check service port"
    check_all_port
    shift
    ;;
  -d | docker)
    debug=1
    check_docker
    debug=0
    shift
    ;;
  -disk | disk)
    debug=1
    check_disk
    debug=0
    shift
    ;;
  -dog | dog)
    debug=1
    check_dog
    debug=0
    shift
    ;;
  -h | h | help)
    show_help
    shift
    ;;
  -s | status)
    show_app_runtime_status
    shift
    ;;
  --version)
    echo "sharkcheck version is v1.0.0"
    shift
    ;;
  *)
    echo "Invalid option: $1"
    show_help
    shift
    ;;
  esac
done
