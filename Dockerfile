FROM centos:latest

MAINTAINER wurang

RUN yum -y update 

#安装字符集
RUN yum -y install kde-l10n-Chinese \
    && yum -y reinstall glibc-common \
    && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 

#设置编码格式
ENV LANG zh_CN.utf8 
ENV LC_ALL zh_CN.utf8 

#安装常用库
RUN yum -y install gcc-c++  \
    && yum -y install pcre pcre-devel \ 
    && yum -y install zlib zlib-devel \ 
    && yum -y install openssl openssl--devel \
    && yum -y install autoconf automake libjpeg libjpeg-devel libpng libpng-devel libtool libdrm-devel\
    && yum -y install freetype freetype-devel curl curl-devel libxml2 libxml2-devel nasm\
    && yum -y install glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel 

#安装epel-release 和 nginx
RUN yum -y install epel-release \
    && yum -y install nginx

#安装nodejs,cnpm,pm2
RUN yum -y install nodejs \
    && npm install -g cnpm --registry=https://registry.npm.taobao.org \
    && cnpm install -g pm2 

#clean
RUN yum clean all

#复制nginx配置
COPY /source/nginx.conf /etc/nginx/

CMD ["nginx", "-g", "daemon off;"]
