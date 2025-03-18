#!/bin/bash
# author: noodzhan@163.com
set -e 

des="/opt/apexapp/web"

filename=dist$(date +"%Y%m%d%s")
sudo cp -r $des/dist $des/$filename
ls -clt $des |head -n 5

cur=$(pwd)

exist=$(ls -alct $cur | grep dist.zip |wc -l) 

if [ $exist -eq 1 ] ;then
	sudo cp $cur/dist.zip $des
  sudo unzip -o $des/dist.zip -d $des
	sudo cp $des/$filename/static/config.js $des/dist/static/
	echo "update ok "	
else
   echo 'this path not found dist.zip'

fi

