#!/bin/bash

#https://gitee.com/cym1102/svnWebUI

apt-get update

apt-get install subversion


nohup java -jar -Dfile.encoding=UTF-8 svnWebUI.jar --server.port=6060 > /dev/null &


