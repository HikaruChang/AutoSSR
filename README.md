# AutoSSR
A SSR account auto get and auto write script.</br>
</br>
# 使用方法</br>
将autossr文件夹上传到路由器root目录，通过SSH执行
<pre>sh /root/autossr/autossr.sh [1-3]</pre></br>
数字代表：1美国、2香港、3日本</br>
</br>
可配合Crontab使用自动获取</br>
<pre>*/30 * * * * sh /root/autossr/autossr.sh [1-3]</pre></br>
</br>
需安装SSR for openwrt</br>
<a href="https://github.com/hikaruchang/openwrt-ssr">https://github.com/hikaruchang/openwrt-ssr</a>
</br>
PS：SSR账号来自互联网。
