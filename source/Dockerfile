# nodejs version
FROM node:10.15

MAINTAINER wurang

#change apt-get source
COPY sources.list /etc/apt/sources.list

# use nginx for proxy and samba for sharefolder
RUN mkdir /app  && \
    apt-get update -y && \
    apt-get install -y nasm bzip2 && \
    apt-get install -y samba nginx && \
    npm install -g cnpm --registry=https://registry.npm.taobao.org && \
    apt-get clean

#copy nginx.conf
COPY nginx.conf /etc/nginx/

WORKDIR /app

CMD nginx -g 'daemon off;'


