# 前言

本脚本是游戏《幸福工厂》的一键安装脚本，安装方式为在宿主机安装server,如果你在寻找容器化安装方法，可以参考这里 [DockerGame](https://github.com/jinzhongjia/DockerGame/blob/main/Satisfactory/README_CN.md)

## 幸福工厂自动部署脚本

在以下linux发行版经过测试，可正常运行：

* centos7.9
* centos8
* debian9
* debian10
* ubuntu18.04
* Ubuntu 20.04

**提示**：

* 服务器提供商默认的系统镜像可能并不纯净，在遇到部署完成后发现服务运行正常，但无法连接游戏的情况，可以考虑dd系统镜像重新安装
* 如果在安装过程中失败，请直接重新运行脚本，原因通常为下载游戏资源失败导致

**用户反馈的问题**：

* 华为云部署后连接服务器一直超时，端口已经放开，和客服反馈后仍未解决！

实现功能：

* 检测系统（OS）版本 ×
* 检测服务器配置 √
* 进行虚拟分区  √
* 服务器安装  √
* 创建服务进行启动  √

## 使用方法

### 安装须知

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

2. 推荐使用`Debian`全系、`Ubuntu`全系，`Centos stream`，由于`centos`已经停止维护，故不推荐使用

### 安装过程

#### 安装命令

注意：该版本会将信息直接输出到控制台，推荐对linux无使用经验的玩家使用

`centos7` / `Centos stream`:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/jinzhongjia/satisfactory/raw/script/satisfactory_c7.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/jinzhongjia/satisfactory@script/satisfactory_c7.sh)
```

`centos8`:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/jinzhongjia/satisfactory/raw/script/satisfactory_c8.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/jinzhongjia/satisfactory@script/satisfactory_c8.sh)
```

`ubuntu` / `debian`:

```bash
#国外服务器使用
bash <(wget -qO- https://github.com/jinzhongjia/satisfactory/raw/script/satisfactory_d.sh)
#国内服务器使用
bash <(wget -qO- https://cdn.jsdelivr.net/gh/jinzhongjia/satisfactory@script/satisfactory_d.sh)
```

#### 操作命令

```bash
# 如果是在普通用户下执行，请使用sudo
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

`steamcmd`和`satisfactory`存放位置：`/home/steam/`

#### 存档位置

路径：`/home/steam/.config/Epic/FactoryGame/Saved/SaveGames/server`

#### 游戏更新

本脚本已经内置了游戏服务在每晚4点重新启动，并进行检测更新！

如果想要手动更新游戏版本，只需要对游戏服务进行重启即可!

```bash
# 如果是在普通用户下执行，请使用sudo
systemctl restart satisfactory
#重启游戏服务，用于进行游戏更新
```

#### 脚本完整删除方法

1. 删除/home/steam文件夹

```bash
rm -rf /home/steam
```

2. 删除steam用户

```bash
userdel –r steam
```

#### 相关资料

官网：[www.satisfactorygame.com/](https://www.satisfactorygame.com)

交互式地图：[satisfactory-calculator.com/en/interactive-map/](https://satisfactory-calculator.com/en/interactive-map/)

MOD平台：[ficsit.app](https://ficsit.app)

官方问题反馈论坛：[questions.satisfactorygame.com](https://questions.satisfactorygame.com/)

官方维基：[satisfactory.gamepedia.com/Satisfactory_Wiki](https://satisfactory.gamepedia.com/Satisfactory_Wiki)

专属服务器维基：[Dedicated_servers](https://satisfactory.fandom.com/wiki/Dedicated_servers)
