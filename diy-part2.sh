#!/bin/bash

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 2. 仅保留 AdGuardHome (可选)
mkdir -p files/usr/bin/AdGuardHome
echo "Downloading AdGuardHome..."
wget -t 5 -T 15 "https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_arm64.tar.gz" -O agh.tar.gz && \
tar -xzf agh.tar.gz -C files/usr/bin/AdGuardHome --strip-components=2 && rm agh.tar.gz || echo "AGH download failed"

# 暴力修复：直接在驱动头文件中插入缺少的定义
sed -i '40i #define HIT_BIND_FORCE_TO_CPU 0x3\n#define MTK_FE_START_RESET 0x10\n#define MTK_FE_RESET_DONE 0x11\n#define MTK_FE_RESET_NAT_DONE 0x12\n#define MTK_WIFI_CHIP_ONLINE 0x13\n#define MTK_WIFI_CHIP_OFFLINE 0x14\n#define MTK_WIFI_RESET_DONE 0x15' target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/mtk_eth_soc.h
# 3. 赋权并退出
chmod -R +x files/usr/bin/AdGuardHome 2>/dev/null
exit 0
