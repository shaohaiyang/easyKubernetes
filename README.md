# Kubernetes with ansible playbook and kubeadm toolkit
## 初始化系统及docker环境部署
`ansible-playbook -i lists_k8s main.yml -e "host=all" -t init,docker`

## 使用yum方式单独部署 etcd cluster
`ansible-playbook -i lists_k8s main.yml -e "host=all" -t etcd`

## 使用k8s 二进制方式部署docker和k8s组件（包含以下的 kube-proxy,flannel）
`ansible-playbook -i lists_k8s main.yml -e "host=all" -t k8s-bin`

## 使用k8s 二进制方式部署docker和k8s组件（包含以下的 kube-router）
`ansible-playbook -i lists_k8s main.yml -e "host=all" -t kube-router`
#`ansible-playbook -i lists_k8s main.yml -e "host=all" -t init,docker,etcd,k8s-bin,kube-router`

## 使用yum方式部署docker和k8s组件（包含以下的etcd,flannel）
`ansible-playbook -i lists_k8s main.yml -e "host=all" -t k8s`

## 使用yum方式单独部署 flannel
#`ansible-playbook -i lists_k8s main.yml -e "host=all" -t flannel`

## 使用 kubeadm方式部署指定版本的k8s（此方式官方推荐，但仍在开发中）
`ansible-playbook -i lists_k8s main.yml -e "host=all" -t init,kubeadm`
