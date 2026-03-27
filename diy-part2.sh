#!/bin/bash

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 2. 提前创建多级目录 (确保 tar 有地方解压)
mkdir -p files/usr/bin/AdGuardHome
mkdir -p files/etc/openclash/core

# 3. 插件核心下载 (使用静态 CDN 或固定链接，避开 API 限制)
echo "Downloading AdGuardHome..."
wget -t 5 -T 15 "https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_arm64.tar.gz" -O agh.tar.gz
tar -xzf agh.tar.gz -C files/usr/bin/AdGuardHome --strip-components=2 && rm agh.tar.gz

echo "Downloading OpenClash Dev Core..."
# 换成这个项目专门存放 core 的 master 路径
wget -t 5 -T 15 "https://raw.githubusercontent.com/vernesong/OpenClash/master/resources/overrides/clash-linux-arm64.tar.gz" -O dev.tar.gz
tar -xzf dev.tar.gz -C files/etc/openclash/core && rm dev.tar.gz

echo "Downloading OpenClash Meta Core..."
# 暂时使用固定版本链接以确保 100% 成功，后续进系统再更新即可
wget -t 5 -T 15 "https://github.com/MetaCubeX/mihomo/releases/download/v1.19.1/mihomo-linux-arm64-v8a.tar.gz" -O meta.tar.gz
tar -xzf meta.tar.gz -C files/etc/openclash/core && rm meta.tar.gz
mv files/etc/openclash/core/mihomo files/etc/openclash/core/clash_meta 2>/dev/null

# 赋权
chmod +x files/usr/bin/AdGuardHome/AdGuardHome files/etc/openclash/core/clash* 2>/dev/null
