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


## 手动组网

1. [Creating-A-Network-From-Scratch](http://docs.goquorum.com/en/latest/Getting%20Started/Creating-A-Network-From-Scratch/#tessera)
2. [Quorum手动搭建指南](https://www.jianshu.com/p/b4ddb24b2720)
3. [Quorum: permissioned-nodes.json and static-nodes.json](https://ethereum.stackexchange.com/questions/64267/quorum-permissioned-nodes-js-and-static-nodes-js)
4. [Quorum HA Setup](http://docs.goquorum.com/en/latest/How-To-Guides/HA_Setup/)
5. [Static node connections --nodiscover](https://docs.goquorum.com/en/latest/How-To-Guides/adding_nodes/)
6. [Peer-to-peer discovery](https://docs.goquorum.com/en/latest/How-To-Guides/adding_nodes/)