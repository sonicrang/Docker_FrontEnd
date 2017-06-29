FROM centos:latest

MAINTAINER wurang

#复制本地yum源、nodejs安装包、nginx安装包
COPY source/CentOS7-Base-163.repo /etc/yum.repos.d
COPY source/node-v6.11.0-linux-x64.tar.xz /usr/local
COPY source/nginx-1.13.1.tar.gz /usr/local

#nodejs 环境变量
ENV PATH="/usr/local/node-v6.11.0-linux-x64/bin:$PATH"
#nginx 环境变量
ENV PATH="/usr/local/nginx/sbin:$PATH"

#支持库

#更新源、安装常用库、安装nginx、nodejs、cnpm、pm2、nginx
RUN cd /etc/yum.repos.d/ \
    && mv CentOS-Base.repo CentOS-Base.repo.bak \
    && mv CentOS7-Base-163.repo CentOS-Base.repo \
    && yum clean all \
    && yum makecache \
    && yum -y update \
    && yum -y install gcc-c++  \
    && yum -y install pcre pcre-devel \ 
    && yum -y install zlib zlib-devel \ 
    && yum -y install openssl openssl--devel \
    && yum -y install autoconf automake libjpeg libjpeg-devel libpng libpng-devel libtool libdrm-devel\
    && yum -y install freetype freetype-devel curl curl-devel libxml2 libxml2-devel nasm\
    && yum -y install glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel \
    && cd /usr/local \
    && tar -zxvf nginx-1.13.1.tar.gz \
    && cd nginx-1.13.1 \
    && ./configure \
    && make \
    && make install \
    && cd /usr/local \
    && rm -rf /usr/local/nginx-1.13.1.tar.gz \
    && rm -rf /usr/local/nginx-1.13.1 \
    && xz -d node-v6.11.0-linux-x64.tar.xz \
    && tar -xvf node-v6.11.0-linux-x64.tar \
    && rm -rf node-v6.11.0-linux-x64.tar \
    && npm install -g cnpm --registry=https://registry.npm.taobao.org \
    && cnpm install -g pm2 \
    && yum clean all 

#复制nginx配置
COPY /source/nginx.conf /usr/local/nginx/conf

CMD ["nginx", "-g", "daemon off;"]

