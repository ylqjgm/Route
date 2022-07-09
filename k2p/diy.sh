#!/bin/sh

valtime=$(TZ='Asia/Shanghai' date '+%Y-%m-%d %H:%M')
val2="\\1 footer_code +='编译日期 $valtime by <a href=\"https://github.com/ylqjgm/Route\" target=\"blank\">KangNuo</a>';"
sed -i "s#\(.*Non-Commercial Use Only[^;]*;\).*#$val2#" /opt/padavan/trunk/user/www/n56u_ribbon_fixed/state.js
grep "Non-Commercial Use Only" /opt/padavan/trunk/user/www/n56u_ribbon_fixed/state.js