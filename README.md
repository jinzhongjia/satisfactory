## 前言

顺带各位hxd，如果觉得我的这个脚本使用还可以，能否给个star！😁

---

本人搭建的公共幸福工厂服务器，连接地址：satisfactory.jinzh.me

---

### 一键安装幸福工厂脚本

本脚本为幸福工厂（satisfactory）私人服务器（ea版本）一键部署脚本！

以下linux系统以经过测试：

* centos7.9
* centos8
* debian9
* debian10
* ubuntu18.04
* Ubuntu 20.04

理论可以在所有linux系统运行！

**提示**：非国内外大厂售卖的vps自带的系统镜像可能存在不纯净等问题，如果使用脚本后（有时网络问题会导致脚本安装失效，重试即可），发现您的游戏服务运行状态正常，请自行在网络寻找dd脚本对服务器进行重新安装系统操作（更换纯净系统等等操作）

***

！！！！！

经实际使用腾讯云香港轻量1h1g测试，可以完美运行，不过在刚创建游戏地图时会出现短暂的cpu满载情况......

经实际测试服务器配置使用2h4g完美运行！
但需要开启swap分区（即windows虚拟内存），脚本已经内置swap创建！

！！！！！

***

实现功能：

* 检测系统（OS）版本 ×
* 检测服务器配置 √
* 进行虚拟分区  √
* 服务器安装  √
* 创建服务进行启动  √

### 使用方法

#### 安装须知

|        |                                           系统要求                                              |
|--------|------------------------------------------------------------------------------------------------|
|处理器  |x86/64架构的AMD或者Intel处理器，不支持ARM架构，游戏服务更吃单核性能，实际运行效果为一核为主，其他为辅   |
|内存    |至少6G,官方推荐4人及以上使用8G内存，物理内存不够可以使用swap达到要求                                 |
|存储空间|10GB用于游戏服务本身（不算Steamcmd的占用空间）                                                     |
|系统要求|主要的Linux发行版                                                                                |
|联网    |正常的互联网，可以使用端口转发                                                                    |

1. 首先确保你的服务器以下端口均已开放

|默认端口（UDP）|简述|作用|
|--------------|----|---|
|15777|查询端口   |第一次连接到游戏服务是使用的端口，可以自由进行端口转发|
|15000|标识端口   |无法端口转发，如果启动了多个游戏服务，它会自动递增|
|7777 |游戏端口   |此端口可在服务启动时使用 -Port 参数自由转发，例如 "-Port=10000" 将游戏端口更改为 10000。当该端口被占用时，会递增寻找可用端口|

2. 推荐使用Debian全系、Ubuntu全系、Centos7，不推荐在Centos8上使用脚本，Centos8目前官方已经停止维护

#### 安装过程

##### 版本一

注意：该版本会将信息直接输出到控制台，如果你对linux使用有所了解，使用该版本更容易安装

centos7:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/yingyi666/satisfactory/raw/main/satisfactory_c7.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@main/satisfactory_c7.sh)
```

centos8:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/yingyi666/satisfactory/raw/main/satisfactory_c8.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@main/satisfactory_c8.sh)
```

ubuntu / debian:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/yingyi666/satisfactory/raw/main/satisfactory_d.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@main/satisfactory_d.sh)
```

##### 版本二

注意：该版本会将信息输出到`/home/satisfactory_output.log`，如果你未使用过linux或者只是想安装一个游戏服务器来玩玩，请使用该版本！！！

中间可能出现安装过程中控制台无输出，即无响应情况，这是正常的，请耐心等待安装完成！

想要获取输出日志，可以使用以下命令：

```bash
cat /home/satisfactory_output.log
```

centos7:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/yingyi666/satisfactory/raw/dev/satisfactory_c7.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@dev/satisfactory_c7.sh)
```

centos8:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/yingyi666/satisfactory/raw/dev/satisfactory_c8.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@dev/satisfactory_c8.sh)
```

ubuntu / debian:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/yingyi666/satisfactory/raw/dev/satisfactory_d.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@dev/satisfactory_d.sh)
```


#### 操作命令

```bash
systemctl start satisfactory
#开启游戏服务
systemctl restart satisfactory
#重启游戏服务，用于进行游戏更新
systemctl stop satisfactory
#终止游戏服务
systemctl status satisfactory
#查看游戏服务状态
```

### 配置说明

脚本会在系统中创建一个steam账户用于安装steamcmd和satisfactory完成后的服务器运行（root账户无法运行该服务）！

steamcmd和satisfactory存放位置：`/home/steam/`

#### 存档位置

路径：`/home/steam/.config/Epic/FactoryGame/Saved/SaveGames/server`

#### 游戏更新

本脚本已经内置了游戏服务在每晚4点重新启动，并进行检测更新！

如果想要手动更新游戏版本，只需要对游戏服务进行重启即可!

```bash
systemctl restart satisfactory
#重启游戏服务，用于进行游戏更新
```

#### 脚本完整删除方法

1. 删除/home/steam文件夹
2. 删除steam用户

#### 官方文档

官网：[www.satisfactorygame.com/](https://www.satisfactorygame.com)

交互式地图：[satisfactory-calculator.com/en/interactive-map/](https://satisfactory-calculator.com/en/interactive-map/)

MOD平台：[ficsit.app](https://ficsit.app)

官方问题反馈论坛：[questions.satisfactorygame.com](https://questions.satisfactorygame.com/)

官方维基：[satisfactory.gamepedia.com/Satisfactory_Wiki](https://satisfactory.gamepedia.com/Satisfactory_Wiki)

专属服务器维基：[Dedicated_servers](https://satisfactory.fandom.com/wiki/Dedicated_servers)
