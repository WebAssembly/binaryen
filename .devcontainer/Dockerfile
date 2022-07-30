
FROM csighub.tencentyun.com/admin/tlinux2.2-bridge-base-tcloud:latest

# install git git-lfs
RUN rpm --rebuilddb && yum -y install zlib zlib-devel curl perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker gcc curl-devel expect make wget msgfmt gettext zip unzip \
    && yum -y remove git \
    && yum -y --enablerepo=tlinux-testing install git git-lfs \
    && git lfs install

# cmake
RUN mkdir -p /data/App \
    && cd /data/App \
    && wget https://cmake.org/files/v3.24/cmake-3.24.0-rc4-linux-x86_64.tar.gz --no-check-certificate \
    && tar zxvf cmake-3.24.0-rc4-linux-x86_64.tar.gz \
    && mv cmake-3.24.0-rc4-linux-x86_64 cmake

# # gcc
RUN yum -y install centos-release-scl scl-utils \
    && yum -y install devtoolset-7-gcc* \
    && source /opt/rh/devtoolset-7/enable \
    && gcc --version

# ENV
ENV LANG=en_US.UTF-8 \
    CMAKE_HOME=/data/App/cmake \
    GCC_HOME=/opt/rh/devtoolset-7/root/usr/ \
    CC=/opt/rh/devtoolset-7/root/usr/bin/gcc \
    CXX=/opt/rh/devtoolset-7/root/usr/bin/g++ \
    LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib64:$LD_LIBRARY_PATH \
    PATH=/opt/rh/devtoolset-7/root/usr/bin:/data/App/cmake/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Test
# docker build -f $(pwd)/.devcontainer/Dockerfile -t vsc-test $(pwd)/.devcontainer
# docker run --rm -it -v $(pwd):/workspace/ vsc-test /bin/bash

