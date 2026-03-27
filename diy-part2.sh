#!/bin/bash

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 2. 仅保留 AdGuardHome (可选)
mkdir -p files/usr/bin/AdGuardHome
echo "Downloading AdGuardHome..."
wget -t 5 -T 15 "https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_arm64.tar.gz" -O agh.tar.gz && \
tar -xzf agh.tar.gz -C files/usr/bin/AdGuardHome --strip-components=2 && rm agh.tar.gz || echo "AGH download failed"

# 3. 赋权并退出
chmod -R +x files/usr/bin/AdGuardHome 2>/dev/null
exit 0
