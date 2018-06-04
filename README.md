# ansible-playbook -i lists_k8s main.yml -e "host=all" -t init,docker,k8s
# ansible-playbook -i lists_k8s main.yml -e "host=all" -t etcd
# ansible-playbook -i lists_k8s main.yml -e "host=all" -t flannel
# ansible-playbook -i lists_k8s main.yml -e "host=all" -t init,kubeadm

# grub2-set-default "`sed -r -n "s/^menuentry '(.*)' --class.*/\1/p" /boot/grub2/grub.cfg|grep 4.16`"
# grub2-mkconfig -o /boot/grub2/grub.cfg

# yum makecache fast
# yum --enablerepo=docker-ce-stable  --showduplicates list docker-ce
# yum --enablerepo=kubernetes install -y kubelet kubeadm kubectl 
# yum --enablerepo=docker-ce-stable --enablerepo=kubernetes install docker-ce-17.03.2.ce-1.el7.centos kubelet kubeadm kubectl
# kubeadm init --kubernetes-version=v1.10.3 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=0.0.0.0 # 初始化集群
# kubectl apply -f https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n') # 安装weave网络
# kubectl apply -f http://mirror.faasx.com/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml # 安装calico网络
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml # 安装flannel网络
# kubectl taint nodes k8s-m1 node-role.kubernetes.io/master- # 允许master参与工作负载分担

# 安装dashboard & heapster
# kubectl apply -f http://mirror.faasx.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
# kubectl create -f http://mirror.faasx.com/kubernetes/heapster/deploy/kube-config/influxdb/influxdb.yaml
# kubectl create -f http://mirror.faasx.com/kubernetes/heapster/deploy/kube-config/influxdb/grafana.yaml
# kubectl create -f http://mirror.faasx.com/kubernetes/heapster/deploy/kube-config/influxdb/heapster.yaml
# kubectl create -f http://mirror.faasx.com/kubernetes/heapster/deploy/kube-config/rbac/heapster-rbac.yaml
# kubectl -n kube-system edit service kubernetes-dashboard # 修改dashboard，暴露端口
# kubectl -n kube-system get service kubernetes-dashboard # 获取随机端口

# 创建admin-user账号和权限，用于访问 dashboard
# kubectl create -f admin-user.yaml
# kubectl create -f admin-user-role-binding.yaml
# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

# docker pull registry:2
# docker run -tid --restart=always -p 5000:5000 --name registry -v /data/registry:/var/lib/registry registry:2 
# 将registry的数据卷与本地关联，便于管理和备份registry数据
# docker pull nginx # 从外网registry拉一个nginx镜像过来
# docker tag nginx registry.service.upyun:5000/nginx # 为本地镜像打tag
# docker push registry.service.upyun:5000/nginx # 推送至本地registry
# docker rmi registry.service.upyun:5000/nginx # 删除本地镜像
