#!/bin/bash

# 设置默认主题
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
sed -i 's#luci-theme-bootstrap#luci-theme-infinityfreedom#g' feeds/luci/collections/luci/Makefile

# 修改默认IP
sed -i 's#192.168.1.1#192.168.1.254#g' package/base-files/files/bin/config_generate

# 添加各种包
git clone https://github.com/jerrykuku/luci-app-ttnode.git package/luci-app-ttnode
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/rufengsuixing/luci-app-autoipsetadder.git package/luci-app-autoipsetadder
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
svn co https://github.com/QiuSimons/openwrt-mos/trunk/luci-app-mosdns package/luci-app-mosdns

# 科学上网
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/tcping package/tcping
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core package/xray-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook package/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng package/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus package/trojan-plus
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ssocks package/ssocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/hysteria package/hysteria
svn co https://github.com/fw876/helloworld/trunk/xray-plugin package/xray-plugin
svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/shadowsocks-rust
svn co https://github.com/fw876/helloworld/trunk/shadowsocksr-libev package/shadowsocksr-libev
svn co https://github.com/fw876/helloworld/trunk/v2ray-plugin package/v2ray-plugin
svn co https://github.com/fw876/helloworld/trunk/simple-obfs package/simple-obfs
svn co https://github.com/fw876/helloworld/trunk/trojan package/trojan
svn co https://github.com/fw876/helloworld/trunk/v2ray-core package/v2ray-core
svn co https://github.com/fw876/helloworld/trunk/v2ray-geodata package/v2ray-geodata
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos
svn co https://github.com/fw876/helloworld/trunk/naiveproxy package/naiveproxy

# socat
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-socat package/luci-app-socat
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.4.3/g' feeds/packages/net/socat/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=d47318104415077635119dfee44bcfb41de3497374a9a001b1aff6e2f0858007/g' feeds/packages/net/socat/Makefile
sed -i '75i\	  sc_cv_getprotobynumber_r=2 \\' feeds/packages/net/socat/Makefile

# smartdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/luci-app-smartdns
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.2022.36/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=24661c2419a81e660b11a0e3d35a3bc269cd4bfa/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=0835be621f0359bec24fe2ec112f455aef8d403167be33a8366630db9fdbdbaa/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.2022.36/g' package/luci-app-smartdns/Makefile

# btrfs-progs
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=5.17/g' feeds/packages/utils/btrfs-progs/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=63b778fe4c2bad18e371dce58ed35488e08f583921367454fdd88507a3d0d89e/g' feeds/packages/utils/btrfs-progs/Makefile
rm -rf feeds/packages/utils/btrfs-progs/patches

# curl
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=7.83.0/g' feeds/packages/net/curl/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=bbff0e6b5047e773f3c3b084d80546cc1be4e354c09e419c2d0ef6116253511a/g' feeds/packages/net/curl/Makefile
rm -f feeds/packages/net/curl/patches/0001-wolfssl-fix-compiler-error-without-IPv6.patch

# dockerd
sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# python-docker
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=5.0.3/g' feeds/packages/lang/python/python-docker/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=d916a26b62970e7c2f554110ed6af04c7ccff8e9f81ad17d0d40c75637e227fb/g' feeds/packages/lang/python/python-docker/Makefile

# docker-compose
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2.5.0/g' feeds/packages/utils/docker-compose/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=e002f4f50bfb1b3c937dc0a86a8a59395182fe1288e4ed3429db5771f68f7320/g' feeds/packages/utils/docker-compose/Makefile

# containerd
sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/packages/utils/containerd/Makefile

./scripts/feeds update -a
./scripts/feeds install -a