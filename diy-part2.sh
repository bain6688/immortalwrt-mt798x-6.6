#!/bin/bash

# =============================================================
# 1. 基础设置
# =============================================================
# 修改默认 IP 为 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 设置默认语言为中文
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci


# =============================================================
# 2. 【核心修复】解决驱动编译报错 (undeclared macros)
# =============================================================
echo "Searching for mtk_eth_soc.h to apply patches..."
find target/linux/mediatek/ -name "mtk_eth_soc.h" | while read -r header; do
    echo "Found: $header. Patching..."
    if ! grep -q "HIT_BIND_FORCE_TO_CPU" "$header"; then
        sed -i '/#define MTK_ETH_SOC_H/a #define HIT_BIND_FORCE_TO_CPU 0x3\n#define MTK_FE_START_RESET 0x10\n#define MTK_FE_RESET_DONE 0x11\n#define MTK_FE_RESET_NAT_DONE 0x12\n#define MTK_WIFI_CHIP_ONLINE 0x13\n#define MTK_WIFI_CHIP_OFFLINE 0x14\n#define MTK_WIFI_RESET_DONE 0x15' "$header"
    fi
done


# =============================================================
# 3. 预下载核心 (加速编译 & 刷机即用)
# =============================================================
# 创建目录 (注意：此处在 openwrt 源码根目录下运行)
mkdir -p files/usr/bin/AdGuardHome
mkdir -p files/etc/openclash/core

# 下载 AdGuardHome (ARM64)
AGH_CORE=$(curl -s https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64.tar.gz | cut -d '"' -f 4)
wget -qO- $AGH_CORE | tar xz -C files/usr/bin/AdGuardHome --strip-components=2

# 下载 OpenClash Dev 核心
wget -qO- "https://raw.githubusercontent.com/vernesong/OpenClash/master/resources/overrides/clash-linux-arm64.tar.gz" | tar xz -C files/etc/openclash/core

# 下载 OpenClash Meta 核心
META_URL=$(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest | grep "mihomo-linux-arm64-v8a-v" | grep ".tar.gz" | cut -d '"' -f 4)
wget -qO- $META_URL | tar xz -C files/etc/openclash/core
mv files/etc/openclash/core/mihomo files/etc/openclash/core/clash_meta

# 赋权
chmod +x files/usr/bin/AdGuardHome/AdGuardHome
chmod +x files/etc/openclash/core/clash*


# =============================================================
# 4. 彻底精简 (删除不需要的科学插件源)
# =============================================================
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
