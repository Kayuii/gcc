# GNU Cross Compile

## 1. init docker base images
```
$ docker buildx build --platform linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6 -t kayuii/gcc:base -f ./Dockerfile . --push
```
how to use [buildx](https://github.com/docker/buildx/blob/master/README.md)

## 2. build docker images for GNU Cross Compile
```
$ cd ./gnu 
docker buildx build --platform linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6 -t kayuii/gcc:latest -f ./Dockerfile . --push
```
If you download it slowly from Ubuntu mirror. You can change to other mirror.

### Third party mirror.
* 163 `mirrors.163.com`
* lupaworld `mirror.lupaworld.com`
* 电子科技大学 `ubuntu.uestc.edu.cn`
* 中国科技大学 `debian.ustc.edu.cn`
* 上海交通大学 `ftp.sjtu.edu.cn`
* 清华大学 `mirror.tuna.tsinghua.edu.cn`
* aliyun `mirrors.aliyun.com`
  
### Add the following code to dockerfile
```
ARG UBUNTU_MIRROR=mirror.tuna.tsinghua.edu.cn
RUN sed -i.bak s/archive.ubuntu.com/${UBUNTU_MIRROR}/g /etc/apt/sources.list
```