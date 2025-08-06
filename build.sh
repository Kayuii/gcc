#!/bin/bash

# 使用说明
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "使用方法: $0 [ARCH] [GCC_VERSION]"
    echo "支持的架构:"
    echo "  arm64    -> aarch64 (默认)"
    echo "  amd64    -> x86_64"
    echo ""
    echo "支持的GCC版本:"
    echo "  8, 9, 10 (旧版本，使用legacy下载页面)"
    echo "  11, 12, 13, 14 (新版本，使用新下载页面，默认: 10)"
    echo ""
    echo "示例:"
    echo "  $0                    # 使用默认: arm64 + gcc-10"
    echo "  $0 amd64              # 使用 x86_64 + gcc-10"
    echo "  $0 arm64 9            # 使用 aarch64 + gcc-9 (旧版本)"
    echo "  $0 amd64 8            # 使用 x86_64 + gcc-8 (旧版本)"
    echo "  $0 arm64 13           # 使用 aarch64 + gcc-13 (新版本)"
    echo "  $0 amd64 14           # 使用 x86_64 + gcc-14 (新版本)"
    exit 0
fi

echo "开始构建GCC交叉编译工具链镜像..."

# 设置架构映射，允许通过命令行参数传入，默认为arm64
INPUT_ARCH="${1:-arm64}"
GCC_VERSION="${2:-10}"

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

# 验证GCC版本并设置对应的下载URL
case "$GCC_VERSION" in
    "8"|"9"|"10")
        # 旧版本，使用legacy下载页面
        DOWNLOAD_URL="https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads"
        echo "使用旧版下载页面 (legacy)"
        ;;
    "11"|"12"|"13"|"14")
        # 新版本，使用新下载页面
        DOWNLOAD_URL="https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads"
        echo "使用新版下载页面"
        ;;
    *)
        echo "不支持的GCC版本: $GCC_VERSION"
        echo "支持的版本: 8, 9, 10, 11, 12, 13, 14"
        exit 1
        ;;
esac

echo "输入架构: $INPUT_ARCH"
echo "Docker平台: $PLATFORM"
echo "编译目标架构: $ARCH"
echo "GCC版本: $GCC_VERSION"
echo "下载URL: $DOWNLOAD_URL"

# 构建镜像
podman build \
  --platform $PLATFORM \
  --build-arg ARCH=$ARCH \
  --build-arg GCC_VERSION=$GCC_VERSION \
  --build-arg DOWNLOAD_URL=$DOWNLOAD_URL \
  --tag gcc-${INPUT_ARCH}-${GCC_VERSION}:latest \
  --file gnu/ubuntu/Dockerfile \
  gnu/ubuntu

if [ $? -eq 0 ]; then
    echo "构建完成！"
    echo "镜像标签: gcc-${INPUT_ARCH}-${GCC_VERSION}:latest"
else
    echo "构建失败！"
    exit 1
fi
