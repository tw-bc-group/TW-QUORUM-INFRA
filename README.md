# TW-QUORUM-INFRA
helm, k8s, quorum 

## 运行方法

```bash
kubectl create namespace quorum-namespace

helm install quorum ./ --namespace=quorum-namespace

```


# minikube

```bash

brew install minikube
minikube start --memory 6144

# you should be able to ssh into minikube
minikube ssh

# update your kubectl command see: https://stackoverflow.com/questions/55417410/kubernetes-create-deployment-unexpected-schemaerror 
$> rm /usr/local/bin/kubectl
$> brew link --overwrite kubernetes-cli
# version tested with
$> kubectl version
```


## 启动四个节点组网

helm install one ./ --set name=node1
helm install two ./ --set name=node2  
helm install three ./ --set name=node3 
helm install four ./ --set name=node4  