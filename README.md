# TW-QUORUM-INFRA
helm, k8s, quorum 

## 本地测试方法

### 用`minikube`运行
```sh

# --driver=docker 在mac上好用，--driver=hyperkit 可能会导致image拖不下来

minikube start  --cpus=6 --memory 8192 --cache-images=true  --driver=docker --disk-size='10g' --image-mirror-country='cn' --image-repository='registry.cn-hangzhou.aliyuncs.com/google_containers'

kubectl create namespace quorum-namespace
helm install quorum ./ --namespace=quorum-namespace
helm uninstall quorum 
```

### 加快第一次启动速度

可以提前把image下载了

```sh
minikube ssh
docker pull quorumengineering/tessera:0.11
docker pull quorumengineering/quorum:2.5.0
```
### 调试方法

pod 启动不了用这些命令

```
kubectl describe deployment/<deployname>
kubectl describe replicaset/<rsname>
kubectl get pods
kubectl describe pod/<podname>
kubectl logs <podname> --previous

# 命名空间使用`kubectl apply -f`后被污染，删除objects
kubectl delete --all deployments,configmaps,pods,pvc,service --namespace=default 
kubectl delete --all deployments,configmaps,pods,pvc,service --namespace=quorum-namespace  

```

### 访问节点

```sh

# 导出端口
kubectl get deployments -o wide
nohup kubectl port-forward deployment/quorum-node1-deployment 8546:8546 &

# 查询eth
npm install tw-eth-cli -g
echo "module.exports = { url: 'http://127.0.0.1:8546/'}" > ~/tw-eth-cli-config1.js 
tw-eth-cli balanceOf 0xed9d02e382b34818e88b88a309c7fe71e65f419d
```

## 配置文件解释

| 文件 | 作用 | 如何生成 | 
| --- | --- | --- |
|