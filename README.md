
## 有问题直接在issue里面提！！！！

顺带各位hxd，如果觉得我的这个脚本使用还可以，能否给个star！😁

### 一键安装幸福工厂脚本

本脚本为幸福工厂（satisfactory）私人服务器（ea版本）一键部署脚本！

目前已经实现在centos7.9、debian10上完美运行，centos8未测试，ubuntu未测试（理论可以完美运行）！

***

！！！！！

经实际测试服务器配置使用2h4g完美运行！
但需要开启swap分区（即windows虚拟内存），脚本已经内置swap创建！

！！！！！

***

实现功能：
* 检测系统版本 ×
* 检测服务器配置 √
* 进行虚拟分区  √
* 服务器安装  √
* 创建服务进行启动  √

### 使用方法

centos7:

```bash
#国外服务器使用
wget https://github.com/yingyi666/satisfactory/raw/main/satisfactory_c7.sh &&chmod +x satisfactory_c7.sh&& ./satisfactory_c7.sh
#国内服务器使用
wget https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@main/satisfactory_c7.sh &&chmod +x satisfactory_c7.sh&& ./satisfactory_c7.sh
```

centos8:

```bash
#国外服务器使用
wget https://github.com/yingyi666/satisfactory/raw/main/satisfactory_c8.sh &&chmod +x satisfactory_c8.sh&& ./satisfactory_c8.sh
#国内服务器使用
wget https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@main/satisfactory_c8.sh &&chmod +x satisfactory_c8.sh&& ./satisfactory_c8.sh
```

ubuntu / debian:
```bash
#国外服务器使用
wget https://github.com/yingyi666/satisfactory/raw/main/satisfactory_d.sh &&chmod +x satisfactory_d.sh&& ./satisfactory_d.sh
#国内服务器使用
wget https://cdn.jsdelivr.net/gh/yingyi666/satisfactory@main/satisfactory_d.sh &&chmod +x satisfactory_d.sh&& ./satisfactory_d.sh
```

命令：

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

### 配置

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