# 项目简介 v 2.0 #

# 一、心路历程：

http://wurang.net/docker_frontend/

# 二、基本功能：

## 2.1 控制台

基于Docker Toolbox，在`start.sh`的基础上实现了以下功能：

- 设置本地工作目录，自动共享至虚拟机Docker Machine（Virtual Box）的`/develop` 下
- 基于centos:latest和自定义的Dockerfile一键安装前端开发环境
- 启动Docker容器
- 一键启动并进入前端开发环境
- 进入Docker Machine终端
- 重启Docker Machine
- 清除所有Docker Image和Container
- 退出控制台

![](../master/images/shell.jpg)

## 2.2 前端开发环境内容

其中前端开发环境基于centos镜像，用Dockerfile增加如下功能：
- 安装常用工具如curl、gcc等
- 安装中文UTF-8字符集
- 安装epel-release
- 安装nginx
- 安装nodejs
- 安装cnpm
- 安装pm2工具
- 替换nginx配置文件，以读取本机应用的nginx配置

## 2.3 项目目录结构

- setup
    - DockerToolbox.exe
- source
    - nginx.conf
- boot2docker.iso
- centos.tar
- docker_machine_shell.sh
- Dockerfile
- nginx_config.conf
- start.bat

## 2.4 支持的操作系统

win7 x64及以上

## 2.5 其他说明及限制【重要】

- 在BOIS中开启虚拟化技术
- win8及以上需关闭Hyper-V
- 默认映射80端口和9081端口，其他端口不能访问，如需修改请参考“开发者文档 4.3.5”

**综述：**

由于项目使用Docker Machine在非linux环境下安装Docker，不能体现出Docker的秒级启动特性，同时由于Docker Machine基于Virtual Box，稳定性和综合性能都有所损耗。使用Dockerfile创建前端开发环境所需的镜像文件，使维护和管理更加清晰方便是唯一的优势。 所以该项目更多用于团队内学习和了解Docker的使用。

# 三、使用者文档 #

## 3.1 初次使用与重新安装

- 运行setup文件夹下的`DockerToolbox.exe`安装DockerToolbox。如果系统中已安装Virutal Box和Git，则不需要勾选，否则一定要注意勾选这两项
  ![](../master/images/docker_toolbox.jpg)
- 运行`start.bat`，等待自动安装，直至出现如下的界面（若有文字提示“Deault Boot2Docker ISO is out-of-date, downloading the latest release...”可联系开发或维护人员更新boot2docker.iso）
  ![](../master/images/shell.jpg)
- 在控制台输入`1`，回车，绿色文字提示输入工作目录。注意这里输入的是所有项目所在的文件夹。路径使用linux规范，如本机工作目录是`e:\Repository`，则应该输入`/e/Repository`。如果路径输入错误或路径不存在，则会提示，并要求重新输入。随后等待直至出现绿色文字提示`Set Sharedfolder Success!`。按回车继续
  ![](../master/images/share_folder.jpg)
- 输入`2`，回车，等待安装开发环境的镜像，直至出现绿色文字`Setup Develop Dockerfile Sucess!`。按回车继续
  ![](../master/images/setup.jpg)
- 剩余步骤见3.2

## 3.2 每次开机或重启电脑后操作

- 运行`start.bat`，正常进入控制台
- 输入`3`，回车，绿色文字提示`Start/Restart Docker Sucess!`，按回车继续
- 剩余步骤见3.3

## 3.3 正常使用

- 运行`start.bat`，正常进入控制台

- 输入`4`，回车，进入Docker容器，绿色文字提示`WelCome to Docker! IP: 192.168.99.100`，即为成功，使用这个IP就可以访问Docker。使用命令`cd /develop`，即可进入挂载的本地工作目录

  ![](../master/images/enter.jpg)

- 可以多次运行`start.bat`，多开项目

## 3.4 更新与替换本地工作目录

- 运行`start.bat`，正常进入控制台
- 输入`1`，回车，绿色文字提示输入工作目录。注意这里输入的是所有项目所在的文件夹。路径使用linux规范，如本机工作目录是`e:\Repository`，则应该输入`/e/Repository`。如果路径输入错误或路径不存在，则会提示，并要求重新输入。随后等待直至出现绿色文字提示`Set Sharedfolder Success!`。按回车继续
- 输入`3`，回车，绿色文字提示`Start/Restart Docker Sucess!`，按回车继续

## 3.5 更新前端开发环境

如需升级或安装开发环境的软件，需联系开发或维护人员，修改Dockfile

- 重新pull该项目
- 运行`start.bat`，正常进入控制台
- 输入`2`，回车，等待安装开发环境的镜像，直至出现绿色文字`Setup Develop Dockerfile Sucess!`。按回车继续
- 输入`3`，回车，绿色文字提示`Start/Restart Docker Sucess!`，按回车继续

## 3.6 开发环境异常处理

如果使用过程中发现环境异常，可以重启开发环境

- 运行`start.bat`，正常进入控制台
- 输入`3`，回车，绿色文字提示`Start/Restart Docker Sucess!`，按回车继续

## 3.7 其他功能

- 在控制台菜单输入`5`，即可进入Docker Machine的终端，一般用于维护，查看等进阶操作。
- 在控制台菜单输入`6`，可重启Docker Machine。某些时候重启以解决奔溃或者虚拟机异常等问题。
- 在控制台菜单输入`9`，清除所有Docker镜像和容器，谨慎使用！！
- 在控制台菜单输入`0`，退出控制台。

## 3.8 示例

nodejs项目示例

- 运行`start.bat`，正常进入控制台

- 输入4进入开发环境

- 通过`cd`命令进入所需的项目

  ```shell
  cd /develop/test
  ```

- 使安装必要的module

  ````shell
  cd frontend
  cnpm install
  ````

- 根据实际要求编译或启动整个项目

  ```shell
  npm run test
  ```

- **复制该Docker项目文件夹根目录的`nginx_config.conf`到工作目录的根目录，修改文件名为`项目名称.conf`(如e:\Repository\website.conf)**

- 编辑该文件，**不要**修改`listen`端口，修改`server_name`为所需的域名，修改`location`为本地nodejs服务路径。
  ![](../master/images/nginx.jpg)

- 每次修改"项目名称.conf"文件后，在控制台输入命令`nginx -s reload`，重启Docker中的nginx服务器，若无任何消息提示，则表示配置文件无误，重启完成。

- 随后可在本机修改`hosts`文件，将nginx配置文件中填写的域名指向到Docker的IP。
  ![](../master/images/hosts.jpg)

- 在本机浏览器输入域名，即可访问

# 四、开发者文档 #

## 4.1 维护建议说明

- 建议维护：代表建议开发者定期更新或修改
- 一般维护：代表开发者无需频繁维护或可以对该文件不予理会
- 不建议维护：代表不建议开发者修改该文件

## 4.2 维护文件

### 4.2.1 setup\DockerToolbox.exe【建议维护】

可在docker官网[下载](https://www.docker.com/products/docker-toolbox)，由于国内网络部分被墙，速度非常慢，需要ss或vpn访问。开发者可定期下载，更新替换项目中的DockerToolbox安装包。国内网络也可在代理网站[下载](https://get.daocloud.io/toolbox/)。

### 4.2.2 source\nginx.conf【一般维护】

nginx配置，用于替换Docker中安装的nginx的默认配置文件。主要增加一行配置` include /develop/*.conf;`，将/develop文件夹下的所有配置文件加载进来。

### 4.2.3 boot2docker.iso【建议维护】

boot2docker发布的用于安装docker的linux最小系统。Docker Toolbox安装后，目录中已经有boot2docker.iso文件，但有可能版本不是最新，启动Docker Machine时会检查对应的boot2docker.iso的版本，如果不是最新，会从github下载，还是国内网速影响，经常会失败。所以开发者可以定期通过ss或vpn下载新版的boot2docker.iso，启动脚本时，会自动将该目录的boot2docker.iso拷贝到Docker Machine中。

### 4.2.4 centos.tar【不建议维护】

制作的centos:latest 文件的导出包。如果需要更新最新的centos:latest版本，或者使用其他版本如centos:6.5。可以参考“使用者文档”，通过控制台选择`Enter Docker Machine`，进入Docker Machine终端：

- 键入命令`docker images` 查看是否存在centos:latest镜像
- 如果存在，键入命令`docker rmi -f centos:latest`删除现有的centos:latest
- 键入命令`docker pull centos:latest`或`docker pull centos:6.5`下载最新的centos或指定版本的centos
- 若下载非centos:latest，建议使用命令`docker tag centos:6.5 centos:latest`将其命名成latest，因为在[docker_machine_shell.sh]和[Dockerfile]中，很多指令基于centos:latest，以免引起不必要的麻烦。如果你很熟悉docker命令，可以修改[docker_machine_shell.sh]和[Dockerfile]的内容。
- 键入命令`docker save centos:latest > /e/centos.tar`，就可以将centos:latest导出到E盘根目录，名称为centos.tar


### 4.3.5 docker_machine_shell.sh【一般维护】

基于Docker Toolbox安装目录的`start.sh`修改的脚本。代码中凡是添加了`##Custom Addition Begin`标注的都是自定义的内容并配有注释，其他的均是Docker Toolbox的`start.sh`源码。

其他代码不建议修改，但由于默认只开放了80和9081端口，如需开启其他端口映射，需要修改下面的代码：

```shell
docker-machine ssh "${VM}" 'docker run -d --name heygears --privileged=true -p 80:80 -p 9081:9081 -v /develop:/develop centos:heygears'
```

增加端口映射可增加

```shell
-p 宿主机端口:容器端口
```



### 4.3.6 Dockerfile【建议维护】

默认基于centos:latest，生成前端开发环境系统镜像的指令集。如需执行其他系统命令，或安装其他软件，可以直接修改Dockerfile。使用者参考使用者文档3.5，重新安装开发环境即可完成更新。

### 4.3.7 nginx_config.conf【一般维护】

使用者基于该配置文件，在工作目录的根目录，为每一个项目配置nginx，通过代理，访问nodejs。

### 4.3.8 start.bat【不建议维护】

为了解决NTFS磁盘在Virtual Box共享目录以及linux下的种种问题，需使用管理员权限打开Virtual Box。于是在**[docker_machine_shell.sh]**外，再包了一层批处理，自动使用windows管理员权限。