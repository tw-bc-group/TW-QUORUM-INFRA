# 1. Deployment Architecture

Date: 2020-07-14

## Status

2020-07-14 proposed

## Context

### 当下问题

使用docker-compose在一台ec2上部署了7个节点，并且磁盘使用的和业务服务是一样的，会遇到以下问题：
   1. 磁盘需要手动扩容
   2. 磁盘没有监控
   3. 单点故障，ec2重启所有节点都重启
   4. 重启一个节点不方便
   5. 无法加入一个新节点
   6. 修改配置很复杂，需要抽象（helm）和自动化（ansible）

### 业务需求
1. 自动化启动最小的quorum网络
2. 启动一个节点，加入到1所创建的网络，组件联盟
3. 1所创建的网络，需要对外有域名可以访问

### 安全性需求
1. 网络需要通过某种手段限制访问：域名，VPN，IP，网段，认证（优先级低）。
2. 实践：更新合约需要通过CI机器，不能在本地更新
3. 网络发现：加入网络的quorum节点需要有白名单机制

### 技术需求
1. 组件联盟，指定不同域名，比如org1.quorum.com
2. 基于raft共识，不出空块
3. 使用 tessera 支持私有交易
4. 节点启动有自定义的10个账号，分配100eth
5. 有监控，磁盘满了可以自动增加

### 云部署高可用
1. 使用不同的可用区，防止可用区出问题
2. 使用EKS，转移和简化运维责任，支持自动伸缩集群
3. 支持不同的数据中心互联共建网络，数据中心可以是同一云的VPC，也可以是异构云的VPC，也可以是私有化部署的网络。（优先级低）
4. tessera 有高可用方案
5. quorum 有高可用方案（纵向），可以增加节点到网络，增加cpu，内存

### 里程碑

#### Wallet-Infra

![](../images/tw-wallet-infra.jpg)

参考文档：[基础设施升级到EKS](https://github.com/tw-bc-group/tw-wallet-infra/blob/master/docs/adr/0002-%E5%9F%BA%E7%A1%80%E8%AE%BE%E6%96%BD%E5%8D%87%E7%BA%A7%E4%B8%BAeks.md)

#### M1. 主要目标：内网quorum高可用

使用 k8s，部署quorum 节点在不同的 pod 上，挂载各自的磁盘，可以使用多台机器

|checklist|作用|是否完成|
|--- | --- | --- |
| 使用 helm 部署 | 一键建立网络，一键删除 | 是|
| 配置静态组网 | 不让其他节点加入 | 是 | 
| 配置 tessera 权限 | 不允许发起私有交易 | 是 |
| 设置创世区块 | 分配 personal 账号和 eth | 是 | 
| 使用多个可用区 | 防止硬件问题 | 是，目前有三个可用区 |
| 使用 EKS | k8s 可以管理多台机器，本身高可用 | 是|
| 有对外域名访问网络 | EIP+LB对外提供节点访问 | 是 |
| 使用多台 EC2 | 防止 EC2 资源不足 | 是 | 

#### M2. 主要目标：动态组网

启动一个节点加入网络

|checklist|作用|是否完成|
|--- | --- | --- |
| 启动 quorum 加入网络 | 组成联盟 | 否 |
| 启动 quorum + tessera 加入网络 | 可以发起私有交易 | 否 |
| 每个节点在不同 namespace，有自己端口和域名 | 隔离网络，管理 | 否 |
| 抽离 helm 内部各种配置 | 生产环境不能用默认私钥 | 否 |
| 磁盘监控和自动扩容 | quorum需要大容量磁盘 | 否 |


#### M3. 主要目标：内网 tessera 高可用

|checklist|作用|是否完成|
|--- | --- | --- |
| tessera 多服务 | tessera 是java+数据库服务，可以部署多个，用 lb 负载 | 否 |
| tessera 和 quorum 部署在不同 container | tessera 和 quorum 互不影响 |否 |
| tessera 数据库 HA | 数据库高可用， tessera使用同一个数据库| 否 |
| LB HA | LB 高可用 | 否，内网可以依赖 k8s 的 service |
| tessera 切换数据库 | 当前数据库是 H2 | 否 | 

#### M4. 异构网络组网

|checklist|作用|是否完成|
|--- | --- | --- |
| 联盟中的各个节点在不同可以用区 | 保证可用区容灾 | 否 |
| 在不同 PVC | 异构网络组网 | 否 |
| tessera数据库如何处理 | 异构网络组网 | 否 |


### M1+M2 部署图

![M1+M2 部署图](../images/M1_2.jpg)

1. 上图 VM 可以看成 K8s Pod 中的 container.
2. 图片上部分是 M1 目标
2. 图片下部分是 M1 目标
3. M1,M2 不包含 P2P LB（需要调研，不太明确其作用）

### M3 部署图1

Tessera 在自己的 container 中

![M3 部署图1](../images/M3_1.jpg)

### M3 部署图2
![M3 部署图1](../images/M3_2.jpg)


### M3 多数据中心

![k8s](../images/k8s.png)

上图显示了两个数据中心，我们使用Helm部署quorum节点，分别部署了quorum网络，代表不同的公司，通过p2p协议组成了联盟链。在k8s内部，使用namespace划分不同的域名，quorum节点通过域名互相在内网发现。k8s需要使用一个公网ip让其他网络可以发现本网络，同时quorum需要验证对方是否有合法的证书可以接入网络。对于合约的部署，需要有白名单机制，让规定的用户上传到网络。

### M3 多数据中心云的管理

![VPC](../images/VPC.png)

云环境一般都提供了 VPC，VPC下有可用区，可用区隔离了电力，机房等硬件环境，我们为了提高可用性，可以把quorum最小网络部署在不同的VPC和可用区。

> quorum network 指的是集群，各个 quorum network 共同组件了一个网络

### 流程

![](../images/blockchain-automation-framework-quorum.png)

1. 上图的 ansible 还未使用

## Decision

按照里程碑分布开发，首先完成M1

## Consequences

Consequences here...


## 参考资料

1. [How-To-Guides/HA_Setup](http://docs.goquorum.com/en/latest/How-To-Guides/HA_Setup/)
2. [7nodes Example](https://github.com/jpmorganchase/qubernetes/tree/master/7nodes)
3. [Data recovery](https://docs.goquorum.com/en/latest/Privacy/Tessera/Tessera%20Services/Transaction%20Manager/)
4. [Running Tessera with Postgres](https://medium.com/@arun.s/running-tessera-with-postgres-ea182d6aefb3)
5. [Creating a network from scratch](http://docs.goquorum.com/en/latest/Getting%20Started/Creating-A-Network-From-Scratch/)
6. [DNS for Quorum](http://docs.goquorum.com/en/latest/Quorum%20Features/dns/#static-nodes)
