#!/bin/bash

# 删除自带netdata及百度云盘
rm -rf package/feeds/luci/luci-app-netdata
rm -rf package/feeds/luci/luci-app-baidupcs-web

# 创建插件目录
mkdir -p package/kangnuo
pushd package/kangnuo

# 拉取所需插件
svn co https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom/trunk/luci-theme-infinityfreedom
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/aliyundrive-fuse
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/luci-app-aliyundrive-fuse
git clone https://github.com/zzsj0928/luci-app-pushbot.git
svn co https://github.com/sirpdboy/netspeedtest/trunk/luci-app-netspeedtest
git clone https://github.com/sirpdboy/luci-app-netdata.git
git clone https://github.com/KFERMercer/luci-app-tcpdump.git
git clone https://github.com/kiddin9/luci-app-baidupcs-web.git
git clone -b revert-18-revert-17-master https://github.com/jerrykuku/luci-app-ttnode.git
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-mosdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/mosdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-adguardhome
svn co https://github.com/kenzok8/openwrt-packages/trunk/adguardhome
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/pdnsd-alt
popd

# 设置默认主题
sed -i 's#luci-theme-bootstrap#luci-theme-infinityfreedom#g' feeds/luci/collections/luci/Makefile

# 修复糖甜
sed -i 's|src="/ttnode/jquery.min.js|src="/luci-static/ttnode/jquery.min.js|' package/kangnuo/luci-app-ttnode/luasrc/view/ttnode/login_form.htm
sed -i '/if.*(d.error == 0)/{n;s/settime()/countdown = 60\;\n\t\t\t\t\t&/g}' package/kangnuo/luci-app-ttnode/luasrc/view/ttnode/login_form.htm
sed -i '/jq.cookie(.ltime., 0)/{n;s/countdown = 60/\/\/&/g}' package/kangnuo/luci-app-ttnode/luasrc/view/ttnode/login_form.htm

# 修复百度云盘启动项
rm -f package/kangnuo/luci-app-baidupcs-web/root/etc/init.d/baidupcs-web
cat > package/kangnuo/luci-app-baidupcs-web/root/etc/init.d/baidupcs-web <<'EOF'
#!/bin/sh /etc/rc.common

START=90
STOP=10
USE_PROCD=1

NAME=baidupcs-web
PROG=/usr/bin/baidupcs-web

_info() {
	logger -p daemon.info -t "$NAME" "$*"
}

_err() {
	logger -p daemon.err -t "$NAME" "$*"
}

_make_dir() {
	local d
	for d in "$@"; do
		if [ ! -d "$d" ]; then
			mkdir -p "$d" 2>/dev/null || return 1
		fi
	done

	return 0
}

_create_file() {
	touch "$@" 2>/dev/null
}

_change_owner() {
	local u="$1"; shift

	local d
	for d in "$@"; do
		if [ -f "$d" ]; then
			chown "$u" "$d" 2>/dev/null || return 1
		elif [ -d "$d" ]; then
			chown -R "$u" "$d" 2>/dev/null || return 1
		fi
	done

	return 0
}

_change_file_mode() {
	local mod="$1"; shift
	chmod "$mod" "$@" 2>/dev/null
}

_reset_dir_mode() {
	local d
	for d in "$@"; do
		if [ -d "$d" ]; then
			find "$d" -type d -exec chmod 755 {} \; 2>/dev/null
			find "$d" -type f -exec chmod 644 {} \; 2>/dev/null
		fi
	done
}

append_options() {
	local o; local v
	for o in "$@"; do
		v="$(eval echo "\$$o")"
		[ -n "$v" ] && \
			echo "${o//_/-}=$v" >>"$config_file_tmp"
	done
}

append_setting() {
	local s="$1"
	[ -n "$s" ] && \
		echo "$s" >>"$config_file_tmp"
}

append_header() {
	local h="$1"
	[ -n "$h" ] && \
		echo "header=\"$h\"" >>"$config_file_tmp"
}

baidupcs_validate() {
	uci_load_validate "$NAME" baidupcs-web "$1" "$2" \
		'enabled:bool:0' \
		'port:uinteger:5299' \
		'download_dir:string' \
		'max_download_rate:uinteger:0' \
		'max_upload_rate:uinteger:0' \
		'max_download_load:uinteger:1' \
		'max_parallel:uinteger:8' \
		'aria2:bool:0' \
		'aria2_RPC:string:http://127.0.0.1:6800/jsonrpc' \
		'aria2_secret:string'
}

baidupcs_start() {
	local section="$1"
	[ "$2" = "0" ] || { _err "Validation failed."; return 1; }

	[ "$enabled" = "1" ] || { _info "Instance \"$section\" disabled."; return 1; }

	# check directory existence before creating it
	if [ ! -e "$download_dir" ]; then
		_make_dir "$download_dir" || {
			_err "Can't create download dir: $download_dir"
			return 1
		}
	fi

	baidupcs-web config set                         \
	--savedir               "$download_dir"         \
	--max_download_rate	"$max_download_rate"	\
	--max_upload_rate	"$max_upload_rate"	\
	--max_download_load	"$max_download_load"	\
	--max_parallel		"$max_parallel"		\
	--max_upload_parallel	"$max_upload_parallel"	\
	>/dev/null 2>&1

	procd_open_instance "$NAME.$section"
	procd_set_param command "$PROG"
	[ $aria2 == '1' ] && procd_append_param command -a -au "${aria2_RPC}" -as "${aria2_secret}" || procd_append_param command --port "$port" --access

	procd_set_param respawn
	procd_set_param stdout 1
	procd_set_param stderr 1

	procd_add_jail "$NAME.$section" log
	procd_add_jail_mount_rw "$download_dir"
	procd_close_instance
}

service_triggers() {
	procd_add_reload_trigger "$NAME"
	procd_add_validation baidupcs_validate
}

start_service() {
	config_load "$NAME"
	config_foreach baidupcs_validate "baidupcs-web" baidupcs_start
}
EOF

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 修改默认IP
sed -i 's#192.168.1.1#10.9.8.2#g' package/base-files/files/bin/config_generate

# 修改版本号
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='KangNuo build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt '" >> package/base-files/files/etc/openwrt_release
sed -i 's/${3:-LuCI}/KangNuo/g' feeds/luci/modules/luci-base/src/mkversion.sh
sed -i 's/${2:-Git}/$(TZ=UTC-18 date "+%Y-%m-%d")/g' feeds/luci/modules/luci-base/src/mkversion.sh

# 修复连接数
sed -i '1i net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# 设置密码为空
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/emortal/default-settings/files/99-default-settings