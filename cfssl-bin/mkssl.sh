#!/bin/sh
. ../lists_k8s
DIR="/etc/kubernetes/ssl"
#cfssl print-defaults csr > ca-csr.json
#cfssl print-defaults config > ca-config.json
OU="System"
HOST=
for ip in $Service_cluster_ip `sed -r -n '/ansible_ssh_host=/s@.*ansible_ssh_host=(.*) [A-Z].*@\1@p' ../lists_k8s |awk '{print $1}'`;do
	HOST=$HOST"\"$ip\",\n"
done
# CN = Common Name，浏览器使用该字段验证网站是否合法,一般写的是域名,非常重要。
mkca(){
cat <<EOF | tee ca-csr.json
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "ZJ",
      "L": "HZ",
      "O": "k8s",
      "OU": "$OU"
    }
  ]
}
EOF

cat <<EOF | tee ca-config.json
{
  "signing": {
    "default": {
      "expiry": "876000h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "876000h"
      }
    }
  }
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
}

mketcd(){
cat <<EOF | tee etcd-csr.json
{
    "CN": "etcd",
    "hosts": [
EOF
echo -en $HOST >> etcd-csr.json
cat <<EOF | tee -a etcd-csr.json
      "$Master",
      "127.0.0.1",
      "10.0.0.0/8",
      "192.168.0.0/16",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
        "C": "CN",
        "ST": "ZJ",
        "L": "HZ",
        "O": "etcd",
        "OU": "$OU"
        }
    ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  etcd-csr.json | cfssljson -bare etcd
}

mkapiserver(){
cat <<EOF | tee k8s-csr.json
{
    "CN": "kubernetes",
    "hosts": [
EOF
echo -en $HOST >> k8s-csr.json
cat <<EOF | tee -a k8s-csr.json
      "$Master",
      "127.0.0.1",
      "10.0.0.0/8",
      "192.168.0.0/16",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
        "C": "CN",
        "ST": "ZJ",
        "L": "HZ",
        "O": "k8s",
        "OU": "$OU"
        }
    ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  k8s-csr.json | cfssljson -bare k8s
}

mkadmin(){
cat <<EOF | tee admin-csr.json 
{
  "CN": "admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "ZJ",
      "L": "HZ",
      "O": "system:masters",
      "OU": "$OU"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
}

mkcontroller(){
cat <<EOF | tee kube-controller-csr.json
{
  "CN": "system:kube-controller-manager",
  "hosts": [
EOF
echo -en $HOST >> kube-controller-csr.json
cat <<EOF | tee -a kube-controller-csr.json
      "127.0.0.1",
      "10.0.0.0/8",
      "192.168.0.0/16",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "ZJ",
      "L": "HZ",
      "O": "system:kube-controller-manager",
      "OU": "$OU"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-controller-csr.json | cfssljson -bare kube-controller
}

mkscheduler(){
cat <<EOF | tee kube-scheduler-csr.json
{
  "CN": "system:kube-scheduler",
  "hosts": [
EOF
echo -en $HOST >> kube-scheduler-csr.json
cat <<EOF | tee -a kube-scheduler-csr.json
      "127.0.0.1",
      "10.0.0.0/8",
      "192.168.0.0/16",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "ZJ",
      "L": "HZ",
      "O": "system:kube-scheduler",
      "OU": "$OU"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-scheduler-csr.json | cfssljson -bare kube-scheduler
}

mkproxy(){
cat <<EOF | tee kube-proxy-csr.json
{
  "CN": "system:kube-proxy",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "ZJ",
      "L": "HZ",
      "O": "system:kube-proxy",
      "OU": "$OU"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-proxy-csr.json | cfssljson -bare kube-proxy
}
mkca
mketcd
mkadmin
mkapiserver
mkcontroller
mkscheduler
mkproxy
mkdir -p ./$DIR
mv *.pem ./$DIR/
chmod 444 ./$DIR/*
