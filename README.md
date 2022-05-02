# 自用路由固件编译

此固件为自用固件，仅包含部分APP，并不一定适用于您。

组网说明：

N1主路由桥接光猫拨号上网，K2P等作为AP提供WIFI，本地NAS虚拟一个OpenWRT作为旁路由提供上网，如此组网的原因：

1. K2P做主路由可能为因用网需求过大而宕机（有过多次了）
2. N1主路由可保证本地500M带宽的满速保障
3. 不在N1中开启科学上网，则是为了避免因特殊原因导致的家中无需科学的设备流量爆炸

**固件通过获取lede源码来确定是否更新**

## 刷机方法

1. 将固件写入U盘
2. 将U盘插入N1距HDMI最近的USB接口
3. N1通电进入固件
4. 使用shell登录N1，执行命令：`/root/install-to-emmc.sh`

## 更新方法

**手动更新**

1. 将`update-amlogic-openwrt.sh`及新固件镜像文件`xxx.img`上传到`/mnt/mmcblk2p4`
2. 登录shell，执行命令：`cd /mnt/mmcblk2p4 && bash update-amlogic-openwrt.sh xxx.img`

**在线更新**

![luci-app-amlogic](https://user-images.githubusercontent.com/68696949/145738345-31dd85cf-5e43-444e-a624-f21a28be2a7c.gif)

## 手动清空分区表方法

shell登录N1，执行命令：`dd if=/dev/zero of=/dev/mmcblk2 bs=512 count=1 && sync`

### N1配置

1. 登录地址：`192.168.1.2`
2. 登录帐号：`root`
3. 登录密码：`password`

### x86配置

1. 登录地址：`192.168.1.254`
2. 登录帐号：`root`
3. 登录密码：`password`

### K2P配置

Padavan默认配置

## 感谢

- [https://github.com/features/actions](https://github.com/features/actions)
- [https://github.com/coolsnowwolf/lede.git](https://github.com/coolsnowwolf/lede.git)
- [https://github.com/hanwckf/padavan-4.4.git](https://github.com/hanwckf/padavan-4.4.git)
- [https://cowtransfer.com](https://cowtransfer.com)
- [https://wetransfer.com/](https://wetransfer.com/)

## License

[MIT](https://github.com/ylqjgm/Route/blob/master/LICENSE) © ylqjgm
