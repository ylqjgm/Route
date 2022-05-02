#!/bin/bash

# 添加额外软件包
git clone https://github.com/jerrykuku/luci-app-ttnode.git package/luci-app-ttnode
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/luci-app-smartdns
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# smartdns
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.2022.36/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=24661c2419a81e660b11a0e3d35a3bc269cd4bfa/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=0835be621f0359bec24fe2ec112f455aef8d403167be33a8366630db9fdbdbaa/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.2022.36/g' package/luci-app-smartdns/Makefile

# kkolddns
git clone https://github.com/xrouterservice/luci-app-koolddns.git package/luci-app-koolddns
chmod 0755 package/luci-app-koolddns/root/etc/init.d/koolddns
chmod 0755 package/luci-app-koolddns/root/usr/share/koolddns/aliddns
chmod 0755 package/luci-app-koolddns/root/usr/share/koolddns/dnspod

# dockerd
sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# python-docker
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=5.0.3/g' feeds/packages/lang/python/python-docker/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=d916a26b62970e7c2f554110ed6af04c7ccff8e9f81ad17d0d40c75637e227fb/g' feeds/packages/lang/python/python-docker/Makefile
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile

# btrfs-progs
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=5.17/g' feeds/packages/utils/btrfs-progs/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=63b778fe4c2bad18e371dce58ed35488e08f583921367454fdd88507a3d0d89e/g' feeds/packages/utils/btrfs-progs/Makefile
rm -rf feeds/packages/utils/btrfs-progs/patches

# curl
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=7.83.0/g' feeds/packages/net/curl/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=bbff0e6b5047e773f3c3b084d80546cc1be4e354c09e419c2d0ef6116253511a/g' feeds/packages/net/curl/Makefile
rm -f feeds/packages/net/curl/patches/0001-wolfssl-fix-compiler-error-without-IPv6.patch

# docker-compose
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2.5.0/g' feeds/packages/utils/docker-compose/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=e002f4f50bfb1b3c937dc0a86a8a59395182fe1288e4ed3429db5771f68f7320/g' feeds/packages/utils/docker-compose/Makefile

# containerd
sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/packages/utils/containerd/Makefile

# 替换默认IP
sed -i 's#192.168.1.1#192.168.1.2#g' package/base-files/files/bin/config_generate

# 替换默认主题
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
sed -i 's#luci-theme-bootstrap#luci-theme-infinityfreedom#g' feeds/luci/collections/luci/Makefile

# cpufreq
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile
sed -i 's/services/system/g'  feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua



./scripts/feeds update -a
./scripts/feeds install -a