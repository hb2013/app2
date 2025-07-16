#!/bin/bash

# 检查是否提供了版本号参数
if [ -z "$1" ]; then
  echo "错误: 请提供版本号"
  echo "用法: ./release.sh v1.0.6"
  exit 1
fi

VERSION=$1

# 确认版本号格式是否正确
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "错误: 版本号格式不正确，应为 vX.Y.Z 格式 (例如: v1.0.6)"
  exit 1
fi

echo "准备发布版本: $VERSION"

# 清理Android构建目录
echo "清理Android构建目录..."
rm -rf src-tauri/gen/android

# 执行发布流程
git add .
git commit -m "$VERSION"
git push

# 创建并推送标签
git tag $VERSION
git push origin $VERSION

echo "✅ 发布完成! 版本 $VERSION 已成功发布" 