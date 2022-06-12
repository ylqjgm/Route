#!/bin/bash

# 设置默认主题
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
sed -i 's#luci-theme-bootstrap#luci-theme-infinityfreedom#g' feeds/luci/collections/luci/Makefile

# 修改默认IP
sed -i 's#192.168.1.1#10.9.8.1#g' package/base-files/files/bin/config_generate

# 修改版本号
sed -i "s/OpenWrt /KangNuo build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# 修改lxc命令
sed -i 's#lxc-download --list --no-validate --server#lxc-download --list -- --no-validate --server#g' package/feeds/luci/luci-app-lxc/luasrc/controller/lxc.lua

git clone https://github.com/jerrykuku/luci-app-ttnode.git package/luci-app-ttnode
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
