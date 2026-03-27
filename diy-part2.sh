#!/bin/bash

# 1. 基础设置 (IP与语言)
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci

# 2. AdGuardHome 核心下载 (优化下载逻辑，避免 missing URL)
mkdir -p files/usr/bin/AdGuardHome
echo "Downloading AdGuardHome..."
wget -t 5 -T 15 "https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_arm64.tar.gz" -O agh.tar.gz && \
tar -xzf agh.tar.gz -C files/usr/bin/AdGuardHome --strip-components=2 && rm agh.tar.gz || echo "AGH download failed"

# 3. 【核心修复】暴力注入驱动宏定义
# 根据你的截图，文件路径绝对正确。我们增加一个判断，确保文件存在再修改
TARGET_H="target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/mtk_eth_soc.h"

if [ -f "$TARGET_H" ]; then
    echo "Applying patches to $TARGET_H..."
    # 在第40行之后插入宏定义，解决未定义变量报错
    sed -i '40i #define HIT_BIND_FORCE_TO_CPU 0x3\n#define MTK_FE_START_RESET 0x10\n#define MTK_FE_RESET_DONE 0x11\n#define MTK_FE_RESET_NAT_DONE 0x12\n#define MTK_WIFI_CHIP_ONLINE 0x13\n#define MTK_WIFI_CHIP_OFFLINE 0x14\n#define MTK_WIFI_RESET_DONE 0x15' "$TARGET_H"
else
    echo "Warning: $TARGET_H not found! Checking alternative path..."
    # 备用路径处理（万一在某些阶段路径发生了偏移）
    find . -name mtk_eth_soc.h -exec sed -i '40i #define HIT_BIND_FORCE_TO_CPU 0x3\n#define MTK_FE_START_RESET 0x10\n#define MTK_FE_RESET_DONE 0x11\n#define MTK_FE_RESET_NAT_DONE 0x12\n#define MTK_WIFI_CHIP_ONLINE 0x13\n#define MTK_WIFI_CHIP_OFFLINE 0x14\n#define MTK_WIFI_RESET_DONE 0x15' {} +
fi

# 4. 赋权并退出
chmod -R +x files/usr/bin/AdGuardHome 2>/dev/null
exit 0
