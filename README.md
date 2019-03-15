# FrontEnd In Docker   v 4.0

该项目使用Docker容器化相关技术，可以在Windows平台下快速搭建基于NodeJS的前端开发环境，同时保证环境统一，避免开发机臃肿

**release note：**

- 4.0.0：由于VirtualBox vboxsf性能较差，改为Samba方式共享文件

  https://thepracticalsysadmin.com/how-to-fix-docker-shared-folder-performance-issues/

- 3.0.0：替换images方案，由centos换为node

- 2.0.0：梳理目录结构与文档

- 1.0.0：实现基本功能

# 一、项目思路：

http://wurang.net/docker_frontend/

# 二、概要说明：

## 2.1 支持的操作系统

win7 x64及以上

## 2.2 其他说明及限制【重要】

- 在BIOS中开启虚拟化技术
- win8及以上需关闭Hyper-V
- 默认映射80端口和445端口，其他端口不能访问，如需修改请参考“开发者文档 4.3.5”
- **由于使用Samba共享文件，而数据持久化在DockerMachine（虚拟机）而非本机，故有数据丢失的风险（虚拟机崩溃，Volume无法找回），建议使用git等工具，保证数据及时同步到远端仓库**

## 2.3 控制台

基于Docker Toolbox，在`start.sh`的基础上实现了以下功能：

- 设置Docker Machine Volume，注意该操作会删除已存在的Volume和数据，一般在初次启用时设置即可
- 基于Dockerfile自定义NodeJS Image，Samba用于共享文件，Nginx用于反向代理
- 启动容器
- 进入容器
- 进入Docker Machine终端
- 重启Docker Machine
- 清除所有Docker Volume Image和Container
- 退出控制台

![](../master/images/shell.jpg)

## 2.4 Dockerfile

基于node镜像，用Dockerfile增加如下功能：
- cnpm
- nginx
- samba
- nasm 
- bzip2

## 2.5 项目目录结构

- setup
    - DockerToolbox.exe
- source
    - nginx.conf
    - smb.conf
    - sources.list
    - Dockerfile
- boot2docker.iso
- docker_machine_shell.sh
- nginx_config.conf
- start.bat

# 三、使用者文档 #

## 3.1 初次使用与重新安装

- 运行setup文件夹下的`DockerToolbox.exe`安装DockerToolbox。如果系统中已安装Virutal Box和Git，则不需要勾选，否则一定要注意勾选这两项
  ![](../master/images/docker_toolbox.jpg)
- 运行`start.bat`，等待自动安装，直至出现如下的界面（若有文字提示“Deault Boot2Docker ISO is out-of-date, downloading the latest release...”可联系开发或维护人员更新boot2docker.iso，或者具有良好的网络条件，自动从github下载）
  ![](../master/images/shell.jpg)
- 在控制台输入`1`，回车，由于该操作会清除已存在的工作目录和数据，误操作可以Ctrl+C退出，否则继续回车直至完成
  ![](../master/images/workspace.jpg)
- 输入`2`，回车，等待安装开发环境的镜像，直至完成。按回车继续
  ![](../master/images/setup.jpg)
- 剩余步骤见3.2

## 3.2 每次开机或重启电脑后操作

- 运行`start.bat`，正常进入控制台

- 输入`3`，回车，绿色文字提示`Start/Restart Container Sucess!`，按回车继续

- 注意，以下操作仅需在第一次安装时执行一次

  - Win+R 打开运行，输入"\\192.168.99.100"，回车，用户名密码随便填写

  ![](../master/images/add.jpg)

  - 右键“app”文件夹，映射网络驱动器，分配盘符Z

    ![](../master/images/disk.jpg)

- 剩余步骤见3.3

## 3.3 正常使用

- 运行`start.bat`，正常进入控制台

- 输入`4`，回车，进入Docker容器，绿色文字提示`WelCome to Docker! IP: 192.168.99.100`，即为成功，使用这个IP就可以访问Docker内的应用。使用命令`cd /app`，即可进工作目录

  ![](../master/images/enter.jpg)

- 本机的网络磁盘Z，即是容器内的工作目录在本地的映射，可以直接操作，如遇到只能读不能写的问题，需在容器内执行命令  `chmod 777 -R /app`

- 可以多次运行`start.bat`，多开项目

## 3.4 示例

nodejs项目示例

- 运行`start.bat`，正常进入控制台

- 输入4进入开发环境

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

- **复制该Docker项目文件夹根目录的`nginx_config.conf`到网络磁盘Z的根目录，修改文件名为`项目名称.conf`(如Z:\website.conf)**

- 编辑该文件，**不要**修改`listen`端口，修改`server_name`为所需的域名，修改`location`为本地nodejs服务路径。
  ![](../master/images/nginx.jpg)

- 每次修改"项目名称.conf"文件后，在控制台进入容器，输入命令`nginx -s reload`，重启Docker中的nginx服务器，若无任何消息提示，则表示配置文件无误，重启完成。

- 随后可在本机修改`hosts`文件，将nginx配置文件中填写的域名指向到Docker的IP。
  ![](../master/images/hosts.jpg)

- 在本机浏览器输入域名，即可访问

## 3.5 更新前端开发环境

如需升级或安装开发环境的软件，需联系开发或维护人员，修改Dockerfile

- 重新pull该项目
- 运行`start.bat`，正常进入控制台
- 输入`2`，回车，构建镜像
- 输入`3`，回车，重启容器

## 3.6 开发环境异常处理

如果使用过程中发现环境异常，可以重启开发环境

- 运行`start.bat`，正常进入控制台
- 输入`3`，重启容器

## 3.7 其他功能

- 在控制台菜单输入`5`，即可进入Docker Machine的终端，一般用于维护，查看等进阶操作。
- 在控制台菜单输入`6`，可重启Docker Machine。某些时候重启以解决奔溃或者虚拟机异常等问题。
- 在控制台菜单输入`9`，清除所有Docker挂载卷，镜像和容器，谨慎使用！！
- 在控制台菜单输入`0`，退出控制台。

# 四、开发者文档 #

## 4.1 文件说明

- **setup\\DockerToolbox.exe【建议维护】**

  可在docker官网[下载](https://www.docker.com/products/docker-toolbox)，由于国内网络部分被墙，速度非常慢，需要vpn访问。开发者可定期下载，更新替换项目中的DockerToolbox安装包。国内网络也可在代理网站[下载](https://get.daocloud.io/toolbox/)。


- **source\\nginx.conf【一般维护】**

  nginx配置，用于替换Docker中安装的nginx的默认配置文件。主要增加一行配置` include /app/*.conf;`，将/app文件夹下的所有配置文件加载进来。

- **boot2docker.iso【建议维护】**

  boot2docker发布的用于安装docker的linux最小系统。Docker Toolbox安装后，目录中已经有boot2docker.iso文件，但有可能版本不是最新，启动Docker Machine时会检查对应的boot2docker.iso的版本，如果不是最新，会从github下载，还是国内网速影响，经常会失败。所以开发者可以定期通过vpn下载新版的boot2docker.iso，启动脚本时，会自动将该目录的boot2docker.iso拷贝到Docker Machine中。

- **docker_machine_shell.sh【一般维护】**

  基于Docker Toolbox安装目录的`start.sh`修改的脚本。代码中凡是添加了`##Custom Addition Begin`标注的都是自定义的内容并配有注释，其他的均是Docker Toolbox的`start.sh`源码。

  其他代码不建议修改，但由于默认只开放了80、9080和445端口，如需开启其他端口映射，需要修改下面的代码：

  ```shell
  docker-machine ssh "${VM}" 'docker run -d --name myfrontend --privileged=true -p 80:80  -p 9080:9080 -p 445:445 -v /data:/app node:mynode'
  ```

- **source\Dockerfile【一般维护】**
  见Dockerfile注释

- **nginx_config.conf【一般维护】**

  使用者基于该配置文件，在工作目录的根目录，为每一个项目配置nginx，通过代理，访问nodejs。

- **start.bat【不建议维护】**

   为了解决NTFS磁盘在Virtual Box共享目录以及linux下的种种问题，需使用管理员权限打开Virtual Box。于是在[docker_machine_shell.sh]外，再包一层批处理，自动使用windows管理员权限。