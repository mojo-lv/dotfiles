# dotfiles

openSUSE Leap 15.3 with i3wm

## 设置

### 将/tmp挂载到内存

```shell
sudo cp /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable tmp.mount
```

### 启用tlp

```shell
systemctl enable tlp.service
systemctl enable tlp-sleep.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket
```

### 睿频

```shell
# 临时修改，root用户执行，1关闭，0开启
echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
# 永久修改，编辑/etc/default/tlp，0关闭，1开启
CPU_BOOST_ON_AC=0
CPU_BOOST_ON_BAT=0
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

### 首选应用程序

```shell
exo-preferred-applications
```

### 触控板自然滚动

```shell
# /etc/X11/xorg.conf.d/40-libinput.conf
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "On"
        Option "NaturalScrolling" "True"
EndSection
```

## 软件

```shell
i3-gaps
picom(jonaburg's)
dunst
conky
rofi
polybar
tint2
xfce4-terminal
xfce4-appfinder
xfce4-power-manager
thunar
flameshot
simplescreenrecorder
proxychains-ng
blueman
NetworkManager-applet
gebaar-libinput
lxappearance
ranger
feh
zathura
Visual Studio Code
Motrix
Koodo-Reader
GIMP
VMware Workstation
Qv2ray
vlc
```

## 其他

### zypper包缓存路径

```shell
/var/cache/zypp/packages/
```

### lightdm配置路径

```shell
/etc/lightdm/lightdm-gtk-greeter.conf
```

## 参考

[Using a bare Git repository to store Linux dotfiles](https://martijnvos.dev/using-a-bare-git-repository-to-store-linux-dotfiles/)

[ayamir's dwm-dotfiles](https://github.com/ayamir/dwm-dotfiles)

[siduck76's bspwm-dotfiles](https://github.com/siduck76/bspwm-dotfiles)

[dracula theme](https://draculatheme.com/)
