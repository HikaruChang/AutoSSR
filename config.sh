#===================================================================
# script by Hikaru Chang 2016-07-03  
# version: v1.0
#===================================================================

#set -x

#读取SS配置信息
if [ ! -f ./info ]; then  
	sh password.sh $1 $2
	if [ ! "1$?" = "11" ]; then
		return 0
	fi
fi
#配置信息为空，结束脚本
if [ ! -f ./info ]; then  
	return 0
fi

server=`sed -n '1p' ./info`
sport=`sed -n '2p' ./info`
password=`sed -n '3p' ./info`
encryption=`sed -n '4p' ./info`

#设置配置信息到CONFIG
sed -i "s/^.*option server .*$/	option server '$server'/g" /etc/config/shadowsocks-rss
sed -i "s/^.*option password .*$/	option password '$password'/g" /etc/config/shadowsocks-rss
sed -i "s/^.*option method .*$'/	option method '$encryption'/g" /etc/config/shadowsocks-rss
sed -i "s/^.*option server_port .*$/	option server_port '$sport'/g" /etc/config/shadowsocks-rss

#设置配置信息到JSON
sed -i "s/^.*\"server\".*$/	\"server\": \"$server\",/g" /tmp/etc/shadowsocks-rss/ssr-redir.json
sed -i "s/^.*\"server_port\".*$/	\"server_port\": \"$sport\",/g" /tmp/etc/shadowsocks-rss/ssr-redir.json
sed -i "s/^.*\"password\".*$/	\"password\": \"$password\",/g" /tmp/etc/shadowsocks-rss/ssr-redir.json
sed -i "s/^.*\"method\".*$/	\"method\": \"$encryption\",/g" /tmp/etc/shadowsocks-rss/ssr-redir.json

#重启SSR
killall ssr-local
killall ssr-redir
/usr/bin/ssr-redir -c /tmp/etc/shadowsocks-rss/ssr-redir.json -f /var/run/ssr-redir
/usr/bin/ssr-local -c /tmp/etc/shadowsocks-rss/ssr-local.json -f /var/run/ssr-local

#记录当前配置的密码
echo $password>oldpw

rm -f info*
return 1