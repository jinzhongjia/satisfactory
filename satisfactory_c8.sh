#!/bin/bash
#幸福工厂服务器搭建脚本

# 判断是否安装了所需的依赖

#root权限检测,，无则退出脚本
root_need() {
    if [[ $EUID -ne 0 ]]; then
        echo "错误：脚本必须以root权限运行!" 1>&2
        exit 1
    fi
}

enviroment_check() {
    if ! [ "$(command -v curl)" ]; then
        echo "curl未安装！"
        exit 0
    fi
    if ! [ "$(command -v bc)" ]; then
        echo "bc未安装！"
        exit 0
    fi
}

########
#系统检测
########

root_need

enviroment_check

#配置检测
########
# 获取物理内存总量
pyhMem=$(awk '($1 == "MemTotal:"){print $2}' /proc/meminfo)
#获取虚拟内存总量
virMem=$(awk '($1 == "SwapTotal:"){print $2}' /proc/meminfo)
# 获取内存总容量
mem=$(awk "BEGIN{print $pyhMem + $virMem}")
# 获取cpu总核数
cpuNum=$(grep -c "model name" /proc/cpuinfo)
#获取本机ip地址
# intranetIp=$(ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:")

#获取外网ip地址
ip=$(curl -s ifconfig.me)
# 对内存大小进行判断
if [ "$mem" -gt 12582912 ]; then
    echo -e "\033[;32m物理内存大小：$pyhMem\033[0m"
    echo -e "\033[;32m虚拟内存大小：$virMem\033[0m"
else
    echo -e "\033[;31m注意：内存不够用！请使用虚拟内存或者升级更高配置的服务器！\033[0m"
fi

# 对内核数进行判断
if [ "$cpuNum" -gt 1 ]; then
    echo -e "\033[;32m内核数：$cpuNum个\033[0m"
else
    echo -e "\033[;31m注意：内核数不够用！请升级更高配置的服务器！\033[0m"
    exit 0
fi

if [ "$mem" -gt 12582912 ] && [ "$cpuNum" -gt 1 ]; then
    echo "恭喜你！你的配置足够搭建服务器！"
fi

sleep 3s
clear

if [ "$mem" -lt 12582912 ]; then
    echo "当前系统总内存小于12G，是否开启虚拟内存？"
    echo "1为是，其他为否"
    read -r tmpNum
    if [ "$tmpNum" == 1 ]; then
        clear

        echo "请输入你要设置的swap大小，以G为单位，推荐总内存至少为12G"
        read -r swap_input
        swap_num=$(printf %.0f "$(echo "$swap_input*1024*1024" | bc -l)")

        if [ "$swap_num" -le 0 ]; then
            echo "输入的swap大小不是正数,请重新运行脚本！"
            exit 0
        fi

        echo "接下来将会进行大量文件读写来创建swap分区，服务器响应可能会有卡顿！"
        #使用dd命令创建名为swapfile 的swap交换文件
        dd if=/dev/zero of=/var/swapfile bs=1024 count="$swap_num"
        #对交换文件格式化并转换为swap分区
        mkswap /var/swapfile
        #添加权限
        chmod -R 0600 /var/swapfile
        #挂载并激活分区
        swapon /var/swapfile
        #修改 fstab 配置，设置开机自动挂载该分区
        echo "/var/swapfile   swap  swap  defaults  0  0" >>/etc/fstab
        echo "虚拟内存配置完成！"
    else
        echo "选择不配置swap,退出脚本"
        exit 1
    fi
fi

echo "接下来将安装steamCMD以及游戏所需环境，3秒后开始安装"
sleep 3s

#安装steamCMD以及游戏所需环境
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
yum install glibc.i686 libstdc++.i686 libcurl.i686 screen SDL2.i686 SDL2.x86_64 -y

echo "steamCMD以及游戏所需环境安装完成！"
echo "接下来将安装steamCMD，3秒后开始安装"
sleep 3s

useradd -m steam

#进行steamCMD的安装
fileDir="/home/steam"
#新建游戏存放目录
su - steam -c "mkdir ~/steamcmd"
#下载文件
if ! [ "$(wget -P $fileDir/steamcmd https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz)" ]; then
    echo "下载steamcmd完成！"
else
    echo "steamcmd源文件下载失败，请重新运行脚本！"
    exit 0
fi

# 更改文件拥有者为steam
chown steam "$fileDir/steamcmd/steamcmd_linux.tar.gz"

#解压文件
su - steam -c "tar -zxvf $fileDir/steamcmd/steamcmd_linux.tar.gz -C ~/steamcmd"
#删除下载的压缩包
su - steam -c "rm -f $fileDir/steamcmd/steamcmd_linux.tar.gz"
#运行steamCMD安装
su - steam -c "$fileDir/steamcmd/steamcmd.sh +quit"

mkdir -p /home/steam/.steam/sdk64/

ln -s /home/steam/steamcmd/linux64/steamclient.so /home/steam/.steam/sdk64/

echo "steamCMD安装完成！"
echo

echo "请选择安装的分支，实验版本请输入0,普通版本请输入任意字符（如果你不知道它们的区别，请输入非0字符）"
read -r game_version

echo "接下来将安装幸福工厂，3秒后开始安装"
sleep 3s

if [ "$game_version" == 0 ]; then
    su - steam -c "$fileDir/steamcmd/steamcmd.sh +force_install_dir ~/SatisfactoryDedicatedServer +login anonymous +app_update 1690800 -beta experimental validate +quit"
else
    su - steam -c "$fileDir/steamcmd/steamcmd.sh +force_install_dir ~/SatisfactoryDedicatedServer +login anonymous +app_update 1690800 validate +quit"
fi

su - steam -c "mkdir -p $fileDir/.config/Epic/FactoryGame/Saved/SaveGames/server"

su - steam -c "echo 存档位置为：$(pwd)"
echo "创建启动脚本"

cat >/home/steam/SatisfactoryDedicatedServer/start_server.sh <<EOF
#!/bin/bash

export InstallationDir=/home/steam/SatisfactoryDedicatedServer
export templdpath=\$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=\$InstallationDir/linux64:\$LD_LIBRARY_PATH
# Install or update the server before launching it
/home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/SatisfactoryDedicatedServer +login anonymous \$InstallationDir +app_update 1690800 validate +quit
# Launch the server
\$InstallationDir/FactoryServer.sh

export LD_LIBRARY_PATH=\$templdpath

EOF

chmod +x $fileDir/SatisfactoryDedicatedServer/start_server.sh

echo "创建服务，使之开机运行！"
cat >/etc/systemd/system/satisfactory.service <<EOF
[Unit]
Description=Satisfactory Server
Wants=network.target
After=syslog.target network-online.target

[Service]
Type=simple
Restart=always
RestartSec=10
User=steam
WorkingDirectory=/home/steam/SatisfactoryDedicatedServer
ExecStart=/home/steam/SatisfactoryDedicatedServer/start_server.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl enable satisfactory.service
systemctl start satisfactory.service
echo "安装完成！游戏服务已经启动！"
echo "安装目录为："$fileDir
echo "可以使用命令进行操作："
echo -e "本机ip为：""\033[;32m$ip\033[0m"
echo -e "\033[;32m启动游戏：systemctl start satisfactory.service\033[0m"
echo -e "\033[;32m重启游戏：systemctl restart satisfactory.service\033[0m"
echo -e "\033[;32m关闭游戏：systemctl stop satisfactory.service\033[0m"
echo "0 4    * * *    root    systemctl restart satisfactory.service" >>/etc/crontab
