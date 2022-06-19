#!/bin/bash

# 添加插件
rm -rf package/feeds/luci/luci-app-netdata
mkdir -p package/ylqjgm
pushd package/ylqjgm
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/aliyundrive-fuse
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/luci-app-aliyundrive-fuse
git clone https://github.com/jerrykuku/luci-app-ttnode.git
svn co https://github.com/sirpdboy/netspeedtest/trunk/luci-app-netspeedtest
git clone https://github.com/sirpdboy/luci-app-netdata.git
git clone https://github.com/KFERMercer/luci-app-tcpdump.git
popd

# 设置默认主题
sed -i 's#luci-theme-bootstrap#luci-theme-infinityfreedom#g' feeds/luci/collections/luci/Makefile

# 调整菜单
sed -i 's/services/nas/g' package/ylqjgm/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/ylqjgm/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
sed -i 's/services/nas/g' package/ylqjgm/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 修改默认IP
sed -i 's#192.168.1.1#10.9.8.1#g' package/base-files/files/bin/config_generate

# 修改Hostname
sed -i 's/ImmortalWrt/Primary/g' package/base-files/files/bin/config_generate

# 修改版本号
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='ylqjgm build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt '" >> package/base-files/files/etc/openwrt_release
sed -i 's/${3:-LuCI}/ylqjgm/g' feeds/luci/modules/luci-base/src/mkversion.sh
sed -i 's/${2:-Git}/$(TZ=UTC-18 date "+%Y-%m-%d")/g' feeds/luci/modules/luci-base/src/mkversion.sh

# 修正连接数
sed -i '1i net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# 设置密码为空
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/emortal/default-settings/files/99-default-settings

# 修改插件名字
sed -i 's/"Aria2 配置"/"Aria2"/g' `grep "Aria2 配置" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
sed -i 's/"SQM QoS"/"SQM流控"/g' `grep "SQM QoS" -rl ./`
sed -i 's/"TTYD 终端"/"终端"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"iKoolProxy 滤广告"/"广告过滤"/g' `grep "iKoolProxy 滤广告" -rl ./`
sed -i 's/"上网时间控制"/"上网控制"/g' `grep "上网时间控制" -rl ./`
sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
sed -i 's/"解除网易云音乐播放限制"/"网易云音乐"/g' `grep "解除网易云音乐播放限制" -rl ./`
sed -i 's/"阿里云盘 FUSE"/"阿里云盘"/g' `grep "阿里云盘 FUSE" -rl ./`
sed -i 's/"BaiduPCS Web"/"百度云盘"/g' `grep "BaiduPCS Web" -rl ./`
