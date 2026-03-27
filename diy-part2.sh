#!/bin/bash

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 2. 插件核心下载 (优化后的稳定版)
mkdir -p files/usr/bin/AdGuardHome files/etc/openclash/core
echo "Downloading Cores..."
wget -t 5 -T 15 "https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_arm64.tar.gz" -O- | tar xz -C files/usr/bin/AdGuardHome --strip-components=2
wget -t 5 -T 15 "https://raw.githubusercontent.com/vernesong/OpenClash/master/resources/overrides/clash-linux-arm64.tar.gz" -O- | tar xz -C files/etc/openclash/core
wget -t 5 -T 15 "https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-arm64-v8a.tar.gz" -O- | tar xz -C files/etc/openclash/core
[ -f files/etc/openclash/core/mihomo ] && mv files/etc/openclash/core/mihomo files/etc/openclash/core/clash_meta
chmod +x files/usr/bin/AdGuardHome/AdGuardHome files/etc/openclash/core/clash* 2>/dev/null
