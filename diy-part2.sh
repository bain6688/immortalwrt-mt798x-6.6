#!/bin/bash

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 下载 AdGuardHome (已经稳了，保留)
echo "Downloading AdGuardHome..."
wget -t 5 -T 15 "https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_arm64.tar.gz" -O- | tar xz -C files/usr/bin/AdGuardHome --strip-components=2

# 下载 OpenClash Dev 核心 (修正路径)
echo "Downloading OpenClash Dev Core..."
wget -t 5 -T 15 "https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-arm64.tar.gz" -O- | tar xz -C files/etc/openclash/core

# 下载 OpenClash Meta 核心 (修正文件名为 v8a-v 开头的格式)
echo "Downloading OpenClash Meta Core..."
# 针对 mihomo 仓库，我们直接抓取最新的 release 链接
META_URL=$(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest | grep "browser_download_url" | grep "linux-arm64-v8a" | grep "tar.gz" | head -n 1 | cut -d '"' -f 4)
wget -t 5 -T 15 "$META_URL" -O- | tar xz -C files/etc/openclash/core

# 重命名 Meta 核心以匹配 OpenClash
mv files/etc/openclash/core/mihomo files/etc/openclash/core/clash_meta 2>/dev/null

chmod +x files/usr/bin/AdGuardHome/AdGuardHome files/etc/openclash/core/clash* 2>/dev/null
