#!/bin/bash

# 使用说明
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "使用方法: $0 [ARCH]"
    echo "支持的架构:"
    echo "  arm64    -> aarch64 (默认)"
    echo "  amd64    -> x86_64"
    echo ""
    echo "示例:"
    echo "  $0           # 使用默认架构 arm64"
    echo "  $0 amd64     # 构建 x86_64 架构"
    exit 0
fi

echo "开始构建镜像..."

# 设置架构映射，允许通过命令行参数传入，默认为arm64
INPUT_ARCH="${1:-arm64}"

# 从简化的架构名称映射到完整平台和目标架构
case "$INPUT_ARCH" in
    "arm64")
        PLATFORM="linux/arm64"
        ARCH="aarch64"
        ;;
    "amd64")
        PLATFORM="linux/amd64"
        ARCH="x86_64"
        ;;
    *)
        echo "不支持的架构: $INPUT_ARCH"
        echo "支持的架构: arm64, amd64"
        exit 1
        ;;
esac

echo "输入架构: $INPUT_ARCH"
echo "Docker平台: $PLATFORM"
echo "编译目标架构: $ARCH"

# 构建镜像
podman build \
  --platform $PLATFORM \
  --build-arg ARCH=$ARCH \
  --tag gcc-arm32v7:latest \
  --file /Users/gecko/project/docker/gcc/gnu/ubuntu/10/Dockerfile \
  /Users/gecko/project/docker/gcc/

if [ $? -eq 0 ]; then
    echo "构建完成！"
    echo "镜像标签: gcc-arm32v7:latest"
else
    echo "构建失败！"
    exit 1
fi
