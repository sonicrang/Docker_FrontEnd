# FrontEnd In Docker   v 5.0

该项目使用Docker容器化相关技术，可以在Windows平台下快速搭建基于NodeJS的前端开发环境，同时保证环境统一，避免开发机臃肿

**release note：**

- 5.0.0：升级到Docker Desktop版本，不再支持win10以下系统

- 4.0.0：由于VirtualBox vboxsf性能较差，改为Samba方式共享文件

  https://thepracticalsysadmin.com/how-to-fix-docker-shared-folder-performance-issues/

- 3.0.0：替换images方案，由centos换为node

- 2.0.0：梳理目录结构与文档

- 1.0.0：实现基本功能

# 一、项目思路：

http://wurang.net/docker_frontend/

# 二、概要说明：

## 2.1 支持的操作系统

Requires Microsoft Windows 10 Professional or Enterprise 64-bit.

## 2.2 其他说明及限制【重要】

- 开启Hyper-V

- 可能会与其他VMWare有冲突

- 默认映射80端口和445端口，其他端口不能访问，如需修改请参考2.5

- **由于共享目录性能较差，如果遇到工作目录app操作速度慢，可以在Windows Defender中把挂载目录添加到排除列表**

  <https://docs.docker.com/docker-for-windows/#shared-drives>

  ![](../master/images/exclude.jpg)

## 2.3 控制台

- 基于Dockerfile自定义NodeJS Image，并挂载用户指定目录
- 启动容器
- 进入容器
- 进入Docker 控制台
- 清除该项目的Image和Container
- 退出控制台

![](../master/images/shell.jpg)

## 2.4 Dockerfile

基于node镜像，用Dockerfile增加如下功能：
- cnpm
- nginx
- nasm 
- bzip2

## 2.5 文件说明

- source\\nginx.conf

  nginx配置，用于替换Docker中安装的nginx的默认配置文件。主要增加一行配置` include /app/*.conf;`，将/app文件夹下的所有配置文件加载进来。

- console.sh

  控制台操作逻辑。其他代码不建议修改，但由于默认只开放了80、9080端口，如需开启其他端口映射，需要修改下面的代码：

  ```shell
  docker run -d --name myfrontend --privileged=true -p 80:80 -p 9080:9080 -v ${hostPath}:/app node:mynode
  ```

- source\Dockerfile
  见Dockerfile注释

- nginx_config.conf

  使用者基于该配置文件，在工作目录的根目录，为每一个项目配置nginx，通过代理，访问nodejs。

# 三、使用文档 #

## 3.1 初次使用与重新安装

- 打开HyperV
  ![](../master/images/hyperv.jpg)

- 下载Docker Desktop 并安装 https://hub.docker.com/editions/community/docker-ce-desktop-windows

- 运行`console.sh`，进入控制台

- 在控制台输入`1`，回车，提示“ Input hostPath (Eg. e:/workspace): ”时输入需要挂载的本地工作目录，注意是斜杠不是反斜杠，若目录不正确则在容器中看不到本地目录的文件

  ![](../master/images/path.jpg)

- 后续操作见3.2

## 3.2 每次开机或重启电脑后操作

- 输入`2`，回车，启动容器
- 后续操作见3.3

## 3.3 正常使用

- 输入`3`，回车，进入容器的工作目录

  ![](../master/images/app.jpg)

- 可以多次运行`console.bat`，多开项目

## 3.4 示例

nodejs项目示例

- 通过`cd`命令进入所需的项目

  ```shell
  cd /app/test
  ```

- 使安装必要的module

  ```shell
  cnpm install
  ```

- 根据实际要求编译或启动整个项目

  ```shell
  npm run dev
  ```

- **复制项目文件夹根目录的`nginx_config.conf`到本地工作目录的根目录，修改文件名为`项目名称.conf`(如e:\workspace\website.conf)**

- 编辑该文件，**不要**修改`listen`端口，修改`server_name`为所需的域名，修改`location`为本地nodejs服务路径。
  ![](../master/images/nginx.jpg)

- 每次修改"项目名称.conf"文件后，在控制台进入容器，输入命令`nginx -s reload`，重启Docker中的nginx服务器，若无任何消息提示，则表示配置文件无误，重启完成。

- 随后可在本机修改`hosts`文件，将nginx配置文件中填写的域名指向到Docker的IP。
  ![](../master/images/hosts.jpg)

- 在本机浏览器输入域名，即可访问

## 3.5 更新前端开发环境

如需升级或安装开发环境的软件，修改Dockerfile的Image版本

- 重新执行`1`安装镜像

## 3.6 其他功能

- 在控制台菜单输入`4`，即可进入Docker 控制台
- 在控制台菜单输入`9`，清除**该项目**的所有镜像和容器，谨慎使用！！
- 在控制台菜单输入`0`，退出控制台。
