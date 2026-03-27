#!/bin/bash

# 1. 修改默认 IP 为 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 2. 强制设置默认语言为中文
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 3. 预下载 AdGuardHome 核心 (ARM64)
mkdir -p files/usr/bin/AdGuardHome
AGH_CORE=$(curl -s https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64.tar.gz | cut -d '"' -f 4)
wget -qO- $AGH_CORE | tar xz -C files/usr/bin/AdGuardHome --strip-components=2
chmod +x files/usr/bin/AdGuardHome/AdGuardHome

# 4. 预下载 OpenClash 核心 (ARM64)
mkdir -p files/etc/openclash/core
# 下载 Dev 核心
wget -qO- "https://raw.githubusercontent.com/vernesong/OpenClash/master/resources/overrides/clash-linux-arm64.tar.gz" | tar xz -C files/etc/openclash/core
# 下载 Meta (Mihomo) 核心
CLASH_META_URL=$(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest | grep "mihomo-linux-arm64-v8a-v" | grep ".tar.gz" | cut -d '"' -f 4)
wget -qO- $CLASH_META_URL | tar xz -C files/etc/openclash/core
mv files/etc/openclash/core/mihomo files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash*

# 5. 移除不需要的插件源 (彻底精简)
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
