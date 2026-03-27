#!/bin/bash

# 1. 强制设定默认语言和时区
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci
sed -i 's/os.strftime("%Z")/os.strftime("CST-8")/g' feeds/luci/modules/luci-base/luasrc/sys.lua

# 2. 预下载 AdGuardHome 核心 (加速固件运行)
# 针对 MT7986 (ARM64 架构)
mkdir -p files/usr/bin/AdGuardHome
AGH_CORE=$(curl -s https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64.tar.gz | cut -d '"' -f 4)
wget -qO- $AGH_CORE | tar xz -C files/usr/bin/AdGuardHome --strip-components=2
chmod +x files/usr/bin/AdGuardHome/AdGuardHome

# 3. 移除残留的组播/科学插件配置文件 (可选)
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
