#几分钟一次，与定时任务配合,600为10分钟，以此类推
searchtime="602"
#数据库名
Default="zfka"
#数据库用户名
READ_USER="zfka"
#数据库密码
READ_PSWD="123456"
#订单号前缀,默认为zlkb，如果你在zafka后台改了前缀就填你改的
STARTID="zlkb"
#消息提示标题
text="卡网有生意拉"
#你的server酱发送消息SCKey
sckey="SCU1099999999999999999999999999999999999999999"
#############################之间无需修改###########################
nowtime=$(date "+%Y-%m-%d %H:%M:%S")
nowtime2=$(date -d "$nowtime" +%s)
lasttime=$[nowtime2-searchtime]
data=$(mysql -u$READ_USER -p$READ_PSWD -D$Default -e "SELECT orderid,productname,paymoney FROM t_order WHERE $lasttime<=paytime AND paytime<=$nowtime2;")
rm -rf /root/zfaka.txt
echo $data >> "/root/zfaka.txt"
size=$(ls -l /root/zfaka.txt | awk '{print $5}')
if [ $size -gt 3 ]
then 
echo "有订单"
else 
echo "没有订单" && exit
fi
sed -i '1,1 s/^.............................//g' /root/zfaka.txt
sed -i 's/'"$STARTID"'/\n'"$STARTID"'/g'  /root/zfaka.txt
sed -i '/^$/d' /root/zfaka.txt
sed -i 's/[ ][ ]*/--/g' /root/zfaka.txt
while read -r desp
do
 echo $desp
 curl https://sc.ftqq.com/$sckey.send?desp=$desp\&text=$text
done < /root/zfaka.txt
#############################之间无需修改###########################
