#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8

clear

if [ ! -d /www/server/panel/BTPanel ];then
	echo "============================================="
	echo "錯誤, 5.x不可以使用此命令升級!"
	echo "請備份數據安裝最新版本"
	exit 0;
fi

public_file=/www/server/panel/install/public.sh
publicFileMd5=$(md5sum ${public_file} 2>/dev/null|awk '{print $1}')
md5check="f6189955e62bd1b4a2cea5073dfdfa3d"
if [ "${publicFileMd5}" != "${md5check}"  ]; then
	wget -O Tpublic.sh https://mod.nde.tw/bt/public.sh -T 20;
	publicFileMd5=$(md5sum Tpublic.sh 2>/dev/null|awk '{print $1}')
	if [ "${publicFileMd5}" == "${md5check}"  ]; then
		\cp -rpa Tpublic.sh $public_file
	fi
	rm -f Tpublic.sh
fi
. $public_file

Centos8Check=$(cat /etc/redhat-release | grep ' 8.' | grep -iE 'centos|Red Hat')
if [ "${Centos8Check}" ];then
	if [ ! -f "/usr/bin/python" ] && [ -f "/usr/bin/python3" ] && [ ! -d "/www/server/panel/pyenv" ]; then
		ln -sf /usr/bin/python3 /usr/bin/python
	fi
fi

mypip="pip"
env_path=/www/server/panel/pyenv/bin/activate
if [ -f $env_path ];then
	mypip="/www/server/panel/pyenv/bin/pip"
fi

download_Url=https://mod.nde.tw/bt
setup_path=/www
version=$(curl -Ss --connect-timeout 5 -m 2 https://api.yu.al/api/panel/get_version)
if [ "$version" = '' ];then
	version='7.8.0'
fi
armCheck=$(uname -m|grep arm)
if [ "${armCheck}" ];then
	version='7.7.0'
fi
wget -T 5 -O /tmp/panel.zip $download_Url/LinuxPanelCrack-7.9.0.zip
dsize=$(du -b /tmp/panel.zip|awk '{print $1}')
if [ $dsize -lt 10240 ];then
	echo "獲取更新包失敗！"
	exit;
fi
unzip -o /tmp/panel.zip -d $setup_path/server/ > /dev/null
rm -f /tmp/panel.zip
cd $setup_path/server/panel/
check_bt=`cat /etc/init.d/bt`
if [ "${check_bt}" = "" ];then
	rm -f /etc/init.d/bt
	wget -O /etc/init.d/bt $download_Url/bt/bt.init -T 20
	sed -i 's/[0-9\.]\+[ ]\+www.bt.cn//g' /etc/hosts
	chmod +x /etc/init.d/bt
fi
rm -f /www/server/panel/*.pyc
rm -f /www/server/panel/class/*.pyc
#pip install flask_sqlalchemy
#pip install itsdangerous==0.24

pip_list=$($mypip list)
request_v=$(echo "$pip_list"|grep requests)
if [ "$request_v" = "" ];then
	$mypip install requests
fi
openssl_v=$(echo "$pip_list"|grep pyOpenSSL)
if [ "$openssl_v" = "" ];then
	$mypip install pyOpenSSL
fi

#cffi_v=$(echo "$pip_list"|grep cffi|grep 1.12.)
#if [ "$cffi_v" = "" ];then
#	$mypip install cffi==1.12.3
#fi

pymysql=$(echo "$pip_list"|grep pymysql)
if [ "$pymysql" = "" ];then
	$mypip install pymysql
fi

pymysql=$(echo "$pip_list"|grep pycryptodome)
if [ "$pymysql" = "" ];then
	$mypip install pycryptodome
fi

#psutil=$(echo "$pip_list"|grep psutil|awk '{print $2}'|grep '5.7.')
#if [ "$psutil" = "" ];then
#	$mypip install -U psutil
#fi

if [ -d /www/server/panel/class/BTPanel ];then
	rm -rf /www/server/panel/class/BTPanel
fi

chattr -i /etc/init.d/bt
chmod +x /etc/init.d/bt
echo "====================================="
rm -f /dev/shm/bt_sql_tips.pl
rm -rf /www/server/panel/data/bind.pl
#rm -rf /www/server/panel/class/pluginAuth.cpython-37m-aarch64-linux-gnu.so
rm -rf /www/server/panel/class/pluginAuth.cpython-37m-i386-linux-gnu.so
rm -rf /www/server/panel/class/pluginAuth.cpython-37m-loongarch64-linux-gnu.so
#rm -rf /www/server/panel/class/pluginAuth.cpython-37m-x86_64-linux-gnu.so
rm -rf /www/server/panel/class/pluginAuth.cpython-310-aarch64-linux-gnu.so
rm -rf /www/server/panel/class/pluginAuth.cpython-310-x86_64-linux-gnu.so
#rm -rf /www/server/panel/class/pluginAuth.so
rm -rf /www/server/panel/class/libAuth.aarch64.so
rm -rf /www/server/panel/class/libAuth.glibc-2.14.x86_64.so
rm -rf /www/server/panel/class/libAuth.loongarch64.so
rm -rf /www/server/panel/class/libAuth.x86-64.so
rm -rf /www/server/panel/class/libAuth.x86.so
#cd /www/server/panel/plugin && rm -rf *
kill $(ps aux|grep -E "task.pyc|main.py"|grep -v grep|awk '{print $2}')
/etc/init.d/bt start
echo 'True' > /www/server/panel/data/restart.pl
pkill -9 gunicorn &
echo "已成功升級到[$version]企業版";
echo -e "\033[32m 來源: https://www.zhujitao.com/981.html \033[0m"