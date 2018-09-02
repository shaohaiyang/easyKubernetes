#!/bin/sh
source ../lists_k8s
DIR="/etc/kubernetes/ssl"
#cfssl print-defaults csr > ca-csr.json
#cfssl print-defaults config > ca-config.json

# CN = Common Name，浏览器使用该字段验证网站是否合法,一般写的是域名,非常重要。
mkca(){
cat  >ca-csr.json <<EOF
{
  "CN": "$Master",
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
      "OU": "System"
    }
  ]
}
EOF

cat >ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "87600h"
      }
    }
  }
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca
}


mkk8s(){
cat > k8s-csr.json <<EOF 
{
    "CN": "$Master",
    "hosts": [
      "127.0.0.1",
      "10.0.0.0/8",
      "192.168.0.0/16",
      "192.168.13.142",
      "10.254.0.1",
      "master.service.upyun",
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
        "OU": "System"
        }
    ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  k8s-csr.json | cfssljson -bare k8s
}

mkadmin(){
cat > admin-csr.json <<EOF
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
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
}

mkproxy(){
cat > kube-proxy-csr.json <<EOF 
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
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-proxy-csr.json | cfssljson -bare kube-proxy
}
mkca
mkk8s
mkadmin
mkproxy
