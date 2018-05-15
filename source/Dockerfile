FROM node:8

MAINTAINER wurang

RUN apt-get update -y && \
    apt-get install -y nasm nginx && \
    npm install -g cnpm --registry=https://registry.npm.taobao.org && \
    apt-get clean

#复制nginx配置
COPY nginx.conf /etc/nginx/

CMD ["nginx", "-g", "daemon off;"]


