#!/bin/bash

# 添加插件
rm -rf package/feeds/luci/luci-app-netdata
mkdir -p package/ylqjgm
pushd package/ylqjgm
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom
git clone https://github.com/sirpdboy/luci-app-advanced.git
git clone https://github.com/zzsj0928/luci-app-pushbot.git
svn co https://github.com/sirpdboy/netspeedtest/trunk/luci-app-netspeedtest
git clone https://github.com/sirpdboy/luci-app-netdata.git
git clone https://github.com/KFERMercer/luci-app-tcpdump.git
git clone https://github.com/rufengsuixing/luci-app-autoipsetadder.git

# 科学上网
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/tcping
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ssocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/dns2socks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/dns2tcp
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ipt2socks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/microsocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/pdnsd-alt
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/hysteria
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-plugin
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocks-rust
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocksr-libev
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-plugin
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/simple-obfs
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-geodata
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/naiveproxy
popd

# 设置默认主题
sed -i 's#luci-theme-bootstrap#luci-theme-infinityfreedom#g' feeds/luci/collections/luci/Makefile

# 调整菜单
sed -i 's/services/vpn/g' package/ylqjgm/luci-app-passwall/luasrc/controller/*.lua
sed -i 's/services/vpn/g' package/ylqjgm/luci-app-passwall/luasrc/model/cbi/passwall/*/*.lua
sed -i 's/services/vpn/g' package/ylqjgm/luci-app-passwall/luasrc/view/passwall/*/*.htm

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 修改Hostname
sed -i 's/OpenWrt/Bypass/g' package/base-files/files/bin/config_generate

# 修改默认IP
sed -i 's#192.168.1.1#10.9.8.2#g' package/base-files/files/bin/config_generate

# 修改版本号
sed -i "s/OpenWrt /ylqjgm build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
sed -i 's/${3:-LuCI}/ylqjgm/g' feeds/luci/modules/luci-base/src/mkversion.sh
sed -i 's/${2:-Git}/$(TZ=UTC-18 date "+%Y-%m-%d")/g' feeds/luci/modules/luci-base/src/mkversion.sh
