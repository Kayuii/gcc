# GCC 交叉编译工具链 Docker 镜像

本项目提供了用于构建 ARM GNU 工具链的 Docker 镜像，支持多种 GCC 版本和架构。

## 🚀 快速开始

### 使用构建脚本（推荐）

```bash
# 构建默认版本 (arm64 + gcc-10)
./build.sh

# 构建指定架构和版本
./build.sh amd64 13

# 构建并推送到容器仓库
./build.sh arm64 12 --push

# 查看帮助
./build.sh -h
```

## 📋 支持的配置

### 支持的架构
- **arm64** → aarch64 (默认)
- **amd64** → x86_64

### 支持的 GCC 版本
- **版本 8, 9, 10**: 使用 [Legacy 下载页面](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads)
- **版本 11, 12, 13, 14**: 使用 [新版下载页面](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)

## 🛠️ 构建选项

### 基本使用

```bash
# 使用默认设置
./build.sh                    # arm64 + gcc-10

# 指定架构
./build.sh amd64              # x86_64 + gcc-10

# 指定版本
./build.sh arm64 9            # aarch64 + gcc-9

# 完整指定
./build.sh amd64 14           # x86_64 + gcc-14
```

### 推送到容器仓库

```bash
# 构建并推送
./build.sh arm64 13 --push

# --push 参数位置灵活
./build.sh --push amd64 12
```

## 📦 镜像标签

构建的镜像使用以下命名规则：
```
gcc:${架构}-${版本}
```

示例：
- `gcc:arm64-10`
- `gcc:amd64-13`
- `gcc:arm64-14`

## 🔧 高级用法

### 手动构建

如果需要手动控制构建过程：

```bash
# 构建旧版本 (8-10)
podman build \
  --platform linux/arm64 \
  --build-arg ARCH=aarch64 \
  --build-arg GCC_VERSION=10 \
  --build-arg DOWNLOAD_URL=https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads \
  --tag gcc:arm64-10 \
  --file gnu/ubuntu/Dockerfile \
  gnu/ubuntu

# 构建新版本 (11-14)
podman build \
  --platform linux/arm64 \
  --build-arg ARCH=aarch64 \
  --build-arg GCC_VERSION=13 \
  --build-arg DOWNLOAD_URL=https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads \
  --tag gcc:arm64-13 \
  --file gnu/ubuntu/Dockerfile \
  gnu/ubuntu
```

## 🏗️ Dockerfile 参数

### 构建参数 (ARG)
- **ARCH**: 目标架构 (aarch64, x86_64)
- **GCC_VERSION**: GCC 版本号 (8-14)
- **DOWNLOAD_URL**: ARM 官方下载页面 URL

### 环境变量 (ENV)
- **DEBIAN_FRONTEND**: 设置为 `noninteractive` 避免交互提示
- **TZ**: 时区设置为 `Asia/Shanghai`

## 🌏 镜像源配置

如果从默认源下载较慢，可以使用国内镜像源：

### 在 Dockerfile 中添加镜像源设置

```dockerfile
ARG UBUNTU_MIRROR=mirrors.aliyun.com
RUN sed -i.bak s/archive.ubuntu.com/${UBUNTU_MIRROR}/g /etc/apt/sources.list
```

### 推荐的国内镜像源
- **阿里云**: `mirrors.aliyun.com`
- **清华大学**: `mirrors.tuna.tsinghua.edu.cn`
- **中科大**: `mirrors.ustc.edu.cn`
- **网易**: `mirrors.163.com`
- **上海交大**: `ftp.sjtu.edu.cn`

## 📂 项目结构

```
gcc/
├── build.sh                    # 主构建脚本
├── gnu/ubuntu/
│   └── Dockerfile             # 通用 Dockerfile
├── base/                      # 基础镜像
│   ├── alpine/
│   └── debian/
├── xilinx/                    # Xilinx 相关工具
└── README.md                  # 本文档
```

## 🔄 版本特性

### 自动版本检测
构建脚本会自动根据 GCC 版本选择正确的：
- 下载 URL (Legacy vs 新版页面)
- 文件名格式 (`gcc-arm-*` vs `arm-gnu-toolchain-*`)

### 多阶段构建
- **第一阶段**: Alpine Linux，用于下载工具链
- **第二阶段**: Ubuntu 20.04，用于安装和配置工具链

## 🐛 故障排除

### SSL 证书问题
如果遇到 SSL 错误，Dockerfile 已自动处理：
```bash
w3m -insecure -o display_link_number=1 -dump "${DOWNLOAD_URL}"
```

### 交互提示问题
已设置环境变量避免 tzdata 等交互提示：
```dockerfile
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
```

### 文件名不匹配
脚本会自动检测 GCC 版本并使用正确的文件名模式：
- GCC 8-10: `gcc-arm-${VERSION}.*-${ARCH}.*arm-none-linux-gnueabihf.tar.xz`
- GCC 11+: `arm-gnu-toolchain-${VERSION}.*-${ARCH}.*arm-none-linux-gnueabihf.tar.xz`

## 📖 使用示例

### 构建不同版本的工具链

```bash
# 构建所有支持的版本
for version in 8 9 10 11 12 13 14; do
    ./build.sh arm64 $version
done

# 构建并推送所有版本
for version in 8 9 10 11 12 13 14; do
    ./build.sh arm64 $version --push
done
```

### 在容器中使用工具链

```bash
# 运行容器
podman run -it --rm gcc:arm64-13

# 在容器中编译
aarch64-13-linux-gnu-gcc --version
aarch64-13-linux-gnu-gcc hello.c -o hello
```

## 📄 许可证

本项目基于开源许可证发布，具体请查看项目中的 LICENSE 文件。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目！

---

**注意**: 首次构建可能需要较长时间，因为需要从 ARM 官方下载工具链文件（约 100MB+）。后续构建会利用 Docker 缓存加速。
