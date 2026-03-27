#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 1. 添加 OpenClash 官方源 (确保能搜到这个插件)
sed -i '$a src-git openclash https://github.com/vernesong/OpenClash.git' feeds.conf.default

# 2. (可选) 添加其他你需要的源，如果 padavanonly 源码里已经有了则不需要
# src-git packages https://github.com/immortalwrt/packages.git
# src-git luci https://github.com/immortalwrt/luci.git

# 3. 如果你想强制移除某些你不想要的源以保持极致精简，可以在这里注销掉
# sed -i 's/^src-git helloworld/#src-git helloworld/g' feeds.conf.default
