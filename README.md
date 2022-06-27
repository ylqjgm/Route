# 自用路由固件编译

此固件为自用固件，仅包含自己所需的APP，并不一定适用于您。

组网说明：

R86S安装PVE虚拟iKuai作为主路由，负责拨号上网，虚拟OpenWRT作为旁路由，负责广告过滤、科学上网等，K2P作为AP使用。

**K2P使用Padavvan默认配置**

### OpenWRT 配置

| 登录地址 | 默认帐号 | 默认密码 |
| ---- | ---- | ---- |
| 10.9.8.2 | root | password |

* 插件列表

| 插件 | 说明 |
| ---- | ---- |
| luci-app-advanced | 高级配置 |
| luci-app-autoreboot | 定时重启 |
| luci-app-ttnode | 甜糖星愿自动采集 |
| luci-app-aliyundrive-fuse | 阿里云盘 FUSE |
| luci-app-adguardhome | AdGuard Home 广告过滤 |
| luci-app-pushbot | 钉钉推送 |
| luci-app-openclash | OpenClash 分流、科学上网 |
| luci-app-ddns | 动态域名 |
| luci-app-vlmcsd | KMS 服务器 |
| luci-app-docker | Docker容器 |
| luci-app-dockerman | Docker管理 |
| luci-app-zerotier | 异地组网 |
| luci-app-aria2 | Aria2下载 |
| luci-app-baidupcs-web | 百度网盘 |
| luci-app-tcpdump | 网络抓包 |
| luci-app-netspeedtest | 网速测试 |
| luci-theme-infinityfreedom | infinityfreedom主题 |

## 感谢

- [https://github.com/features/actions](https://github.com/features/actions)
- [https://github.com/coolsnowwolf/lede.git](https://github.com/coolsnowwolf/lede.git)
- [https://github.com/hanwckf/padavan-4.4.git](https://github.com/hanwckf/padavan-4.4.git)
- [https://wetransfer.com/](https://wetransfer.com/)

## License

[MIT](https://github.com/ylqjgm/Route/blob/master/LICENSE) © ylqjgm
