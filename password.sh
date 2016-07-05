#===================================================================
# script by Hikaru Chang 2016-07-03  
# version: v1.0
#===================================================================


#set -x
#清除执行缓存文件
rm -f ./info*
rm -f ./temp*

#如果第二个参数如果为空，就默认去www.ishadowsocks.com拿信息
if [ "1$2" = "1" ]; then
	addr=http://www.ishadowsocks.com/
else
	addr=$2
fi

#输出脚本执行LOG
echo wget start>>autossr-log

#联网去拿SS源码
wget -t 10 -O tempindex $addr
if [ ! -f ./tempindex ]; then  
	echo wget error>>autossr-log
	return 0 
fi

echo wget pass>>autossr-log

#如果第一个参数为空，就默认拿第一个SS服务器的信息
if [ -n $1 ]; then
  sed -n '215,218p' tempindex > temp
fi
if [ "p$1" = "p1" ]; then
	sed -n '215,218p' tempindex > temp
fi
if [ "p$1" = "p2" ]; then
	sed -n '223,226p' tempindex > temp
fi
if [ "p$1" = "p3" ]; then
	sed -n '231,234p' tempindex > temp
fi

#得到SS服务器代理地址，端口，密码，加密类型
host=`sed -n '1p' ./temp | cut -d ':' -f 2 | cut -d '<' -f 1`
server=`nslookup $host 127.0.0.1 | awk 'NR==5 { print $3 }'`
sport=`sed -n '2p' ./temp | cut -d ':' -f 2 | cut -d '<' -f 1`
password=`sed -n '3p' ./temp | cut -d ':' -f 2 | cut -d '<' -f 1`
encryption=`sed -n '4p' ./temp | cut -d ':' -f 2 | cut -d '<' -f 1`

echo server:$server>>autossr-log
echo sport:$sport>>autossr-log
echo password:$password>>autossr-log
echo encryption:$encryption>>autossr-log
#保存SS服务器代理地址，端口，密码，加密类型
echo $server>info
echo $sport>>info
echo $password>>info
echo $encryption>>info

#如果服务器代理地址，端口，密码，加密类型有一个为空，则脚本获取失败退出
if [ "p$server" = "p" ] || [ "p$sport" = "p" ] || [ "p$password" = "p" ] || [ "p$encryption" = "p" ]; then
	echo can not get server info>>autossr-log
	return 0
fi


rm ./temp*
#返回成功
return 1