#!/bin/bash
# diy-part2.sh
# 1. 强制设定默认语言为中文
sed -i 's/luci.main.lang=en/luci.main.lang=zh_cn/g' feeds/luci/modules/luci-base/root/etc/config/luci
# 2. 如果 Argon 主题没有自带中文包，可以手动添加下载指令到这里（通常 padavanonly 的仓库已经有了）
