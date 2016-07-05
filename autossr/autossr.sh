#===================================================================
# script by Hikaru Chang 2016-07-03  
# version: v1.0
#===================================================================

#set -x
clear
echo 1>info

#记录时间日志
date>autossr-log

#读shadowsocks进程，得到启动状态
ssrlocal=`ps|grep "/usr/bin/ssr-local"| grep -v grep|sed -n '1p'|cut -d '/' -f 4|cut -d ' ' -f 1`
ssredir=`ps|grep "/usr/bin/ssr-redir"| grep -v grep|sed -n '1p'|cut -d '/' -f 4|cut -d ' ' -f 1`

#读上一次的服务器序号和上一次的SS 密码
svrnum=`sed -n '1p' ./svrnum`
oldpw=`sed -n '1p' ./oldpw`

#记录日志
echo svrnum:$svrnum>>autossr-log
echo ssrlocal:$ssrlocal>>autossr-log
echo ssredir:$ssredir>>autossr-log
echo p:$1>>autossr-log
echo oldpw:$oldpw>>autossr-log

#判断shadowsocks是否已经启动？
if [ "1$ssrlocal" = "1ss-local" ] && [ "2$ssredir" = "2ss-redir" ]; then
	#shadowsocks已经启动，判断这次更新的服务器序号和上一次是不是一样
	if [ "1$svrnum" = "1$1" ]; then  
		#序号一样就判断密码是不是一样
		sh getpw.sh $1 $2 #启动拿密码脚本
		if [ ! "1$?" = "11" ]; then
			exit #拿不到密码，中止脚本
		fi	
		
		#拿到新密码，判断和上一次密码是不是一样，
		newpw=`sed -n '3p' ./info`
		if [ "1$oldpw" = "1$newpw" ]; then
			exit #密码一样，就中止脚本
		fi
	fi
fi

#如果shadowsocks没有启动，或者变更服务器序号，或者密码不一样，就继续执行更新本地数据

#检查是否有新密码
newpw=`sed -n '3p' ./info`
if [ "1$newpw" = "1" ]; then
	#没有新密码就启动拿密码脚本
	sh password.sh $1 $2 
	if [ ! "1$?" = "11" ]; then
		exit #拿不到密码，中止脚本
	fi
fi

#记录新的服务器序号
echo $1>svrnum

#启动更新本地配置脚本
echo Start to update config file SSR ... ...
sh ./config.sh $1 $2
echo Start to update config file SSR PASS
#删除缓存文件
rm -f ./temp*
rm -f ./info*
