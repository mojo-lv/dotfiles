# dotfiles

openSUSE Tumbleweed with xmonad

## 设置

### 按用户挂载分区

```shell
# /etc/fstab
UUID=612F-BEFE /home/VM exfat defaults,dmask=0022,fmask=0133,uid=1000,gid=100 0 0
```

### vmware服务启动

```shell
# /usr/share/applications/vmware-workstation.desktop
Exec=xfce4-terminal -e "bash -c 'sudo -i /etc/init.d/vmware start;'" && /usr/bin/vmware %U
```

### 睿频

```shell
# 临时修改，root用户执行，1关闭，0开启
echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
```

### cpupower调频

```shell
# 查看cpu信息
cpupower frequency-info
cpupower -c all frequency-info
# 设置governor
sudo cpupower frequency-set -g powersave    # 省电模式
sudo cpupower frequency-set -g performance  # 高性能模式
```

## 软件

```shell
picom(jonaburg's)
dunst
conky
tint2
xfce4-terminal
thunar
flameshot
proxychains-ng(不支持ping，用curl测试)
blueman
NetworkManager-applet
gebaar-libinput
lxappearance
ranger
feh
zathura
evince
Visual Studio Code
Motrix
Koodo-Reader
GIMP
VMware Workstation
Qv2ray
vlc
file-roller
thunar-plugin-archive
hack-fonts
font-manager
```

## 其他

### zypper包缓存路径

```shell
/var/cache/zypp/packages/
```

### lightdm使用lightdm-slick-greeter

```shell
# 安装lightdm-slick-greeter
sudo zypper in lightdm-slick-greeter
# 修改默认greeter
sudo update-alternatives --config lightdm-default-greeter.desktop
```

