#!/bin/bash

# 设置默认主题
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
sed -i 's#luci-theme-bootstrap#luci-theme-infinityfreedom#g' feeds/luci/collections/luci/Makefile

# 修改默认IP
sed -i 's#192.168.1.1#10.9.8.1#g' package/base-files/files/bin/config_generate

./scripts/feeds update -a
./scripts/feeds install -a