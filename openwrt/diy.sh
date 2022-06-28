#!/bin/bash

# 添加插件
rm -rf package/feeds/luci/luci-app-netdata
rm -rf package/feeds/luci/luci-app-baidupcs-web
mkdir -p package/ylqjgm
pushd package/ylqjgm
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom
git clone https://github.com/sirpdboy/luci-app-advanced.git
git clone https://github.com/zzsj0928/luci-app-pushbot.git
svn co https://github.com/sirpdboy/netspeedtest/trunk/luci-app-netspeedtest
git clone https://github.com/sirpdboy/luci-app-netdata.git
git clone https://github.com/KFERMercer/luci-app-tcpdump.git
git clone https://github.com/kiddin9/luci-app-baidupcs-web.git
git clone https://github.com/jerrykuku/luci-app-ttnode.git
svn co https://github.com/kenzok8/openwrt-packages/trunk/adguardhome
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-adguardhome
git clone https://github.com/vernesong/OpenClash.git
popd

# 设置默认主题
sed -i 's#luci-theme-bootstrap#luci-theme-infinityfreedom#g' feeds/luci/collections/luci/Makefile

# 修复糖甜
sed -i 's|src="/ttnode/jquery.min.js|src="/luci-static/ttnode/jquery.min.js|' package/ylqjgm/luci-app-ttnode/luasrc/view/ttnode/login_form.htm
sed -i '/if.*(d.error == 0)/{n;s/settime()/countdown = 60\;\n\t\t\t\t\t&/g}' package/ylqjgm/luci-app-ttnode/luasrc/view/ttnode/login_form.htm
sed -i '/jq.cookie(.ltime., 0)/{n;s/countdown = 60/\/\/&/g}' package/ylqjgm/luci-app-ttnode/luasrc/view/ttnode/login_form.htm

# 修复百度云盘启动项
rm -f package/ylqjgm/luci-app-baidupcs-web/root/etc/init.d/baidupcs-web
cp openwrt/baidupcs-web package/ylqjgm/luci-app-baidupcs-web/root/etc/init.d/baidupcs-web

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 修改默认IP
sed -i 's#192.168.1.1#10.9.8.2#g' package/base-files/files/bin/config_generate

# 修改版本号
sed -i "s/OpenWrt /ylqjgm build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
sed -i 's/${3:-LuCI}/ylqjgm/g' feeds/luci/modules/luci-base/src/mkversion.sh
sed -i 's/${2:-Git}/$(TZ=UTC-18 date "+%Y-%m-%d")/g' feeds/luci/modules/luci-base/src/mkversion.sh
