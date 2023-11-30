wget -c http://devops.upyun.com/kernel-ml-5.4.5-1.el7.elrepo.x86_64.rpm
curl -X GET -u shaohy:Geminis987 -o /usr/lib/systemd/system/docker.service http://devops.upyun.com:88/docker.service
rpm -ivh kernel-ml-5.4.5-1.el7.elrepo.x86_64.rpm
grub2-set-default "CentOS Linux (5.4.5-1.el7.elrepo.x86_64) 7 (Core)"
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-editenv list
sed -r -i 's@nobarrier,@@g;/ntpdate /d' /etc/rc.d/rc.local
sed -r -i '1a /usr/sbin/ntpdate -u -o3 192.168.147.20 ntp.aliyun.com 211.115.194.21' /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
