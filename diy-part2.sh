#!/bin/bash

# 1. 修改默认 IP 为 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 2. 强制设置默认语言为中文
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 3. 【核心补丁】修复 mt7986 驱动编译报错：手动注入缺失的宏定义
# 这一步会直接修改 target/linux/mediatek/ 路径下的驱动头文件
target_header="target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/mtk_eth_soc.h"
if [ -f "$target_header" ]; then
    echo "Applying mtk_eth_soc.h patch..."
    sed -i '/#define MTK_ETH_SOC_H/a #define HIT_BIND_FORCE_TO_CPU 0x3\n#define MTK_FE_START_RESET 0x10\n#define MTK_FE_RESET_DONE 0x11\n#define MTK_FE_RESET_NAT_DONE 0x12\n#define MTK_WIFI_CHIP_ONLINE 0x13\n#define MTK_WIFI_CHIP_OFFLINE 0x14\n#define MTK_WIFI_RESET_DONE 0x15' "$target_header"
fi

# 4. 预下载 AdGuardHome 核心 (ARM64)
mkdir -p files/usr/bin/AdGuardHome
AGH_CORE=$(curl -s https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_arm64.tar.gz | cut -d '"' -f 4)
wget -qO- $AGH_CORE | tar xz -C files/usr/bin/AdGuardHome --strip-components=2
chmod +x files/usr/bin/AdGuardHome/AdGuardHome

# 5. 预下载 OpenClash 核心 (ARM64)
mkdir -p files/etc/openclash/core
wget -qO- "https://raw.githubusercontent.com/vernesong/OpenClash/master/resources/overrides/clash-linux-arm64.tar.gz" | tar xz -C files/etc/openclash/core
CLASH_META_URL=$(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest | grep "mihomo-linux-arm64-v8a-v" | grep ".tar.gz" | cut -d '"' -f 4)
wget -qO- $CLASH_META_URL | tar xz -C files/etc/openclash/core
mv files/etc/openclash/core/mihomo files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash*

# 6. 移除不需要的插件源
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
