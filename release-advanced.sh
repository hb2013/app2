#!/bin/bash

# 检查是否提供了版本号参数
if [ -z "$1" ]; then
  echo "错误: 请提供版本号"
  echo "用法: ./release-advanced.sh v1.0.6"
  exit 1
fi

VERSION=$1
# 去掉版本号前面的v，用于更新package.json和tauri.conf.json
VERSION_NO_V="${VERSION#v}"

# 确认版本号格式是否正确
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "错误: 版本号格式不正确，应为 vX.Y.Z 格式 (例如: v1.0.6)"
  exit 1
fi

echo "准备发布版本: $VERSION"

# 清理Android构建目录
echo "清理Android构建目录..."
rm -rf src-tauri/gen/android

# 更新package.json中的版本号
echo "更新package.json版本号..."
sed -i '' "s/\"version\": \"[0-9]*\.[0-9]*\.[0-9]*\"/\"version\": \"$VERSION_NO_V\"/" package.json

# 更新tauri.conf.json中的版本号
echo "更新tauri.conf.json版本号..."
sed -i '' "s/\"version\": \"[0-9]*\.[0-9]*\.[0-9]*\"/\"version\": \"$VERSION_NO_V\"/" src-tauri/tauri.conf.json

# 执行发布流程
echo "提交更改..."
git add .
git commit -m "$VERSION"
git push

# 创建并推送标签
echo "创建并推送标签..."
git tag $VERSION
git push origin $VERSION

echo "✅ 发布完成! 版本 $VERSION 已成功发布"
echo "GitHub Actions 工作流将自动构建并发布此版本" 