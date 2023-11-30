kubectl delete deployment tiller-deploy --namespace=kube-system ;  kubectl delete svc tiller-deploy --namespace=kube-system
helm del --purge maesh
helm list
helm install --name=maesh --namespace=maesh maesh/maesh

helm init --service-account tiller
kubectl -n kube-system get pods,deployment,svc
