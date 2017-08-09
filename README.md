# 项目简介 #

**心路历程：**

http://wurang.net/docker_frontend/

**基本功能：**

基于Docker Toolbox，在`start.sh`的基础上实现了以下功能：

1. 自动启动Docker Machine（Virtual Box）
2. 设置本地工作目录，自动共享至虚拟机Docker Machine（Virtual Box）的`/develop` 下
3. 基于centos:latest和自定义的Dockerfile一键安装前端开发环境
4. 一键启动并进入前端开发环境
5. 进入Docker Machine终端
6. 重启Docker Machine

镜像的修改和安装软件如下：
1. 使用centos:latest
2. 替换yum源为163软件源
3. 安装常用工具如curl、gcc等
4. 安装nginx，初始版本为1.13.1
5. 安装nodejs，初始版本为v6.11.0
6. 安装cnpm
7. 安装pm2工具

**项目目录结构如下：**

- setup
    - DockerToolbox.exe
- source
    - CentOS7-Base-163.repo
    - nginx.conf
    - nginx-1.13.1.tar.gz
    - node-v6.11.0-linux-x64.tar.xz
- boot2docker.iso
- centos.tar
- docker_machine_shell.sh
- Dockerfile
- nginx_config.conf
- start.bat

**支持的操作系统：**

win7 x64及以上

**其他说明及限制：**

- 在BOIS中开启虚拟化技术
- win8及以上需关闭Hyper-V
- 默认只开启了Docker的80端口，其他端口不可访问，如需修改请参考“开发者文档”

**综述：**

由于项目使用Docker Machine在非linux环境下安装Docker，不能提现出Docker的秒级启动特性，同时由于Docker Machine基于Virtual Box，稳定性和综合性能都有所损耗。使用Dockerfile创建前端开发环境所需的镜像文件，使维护和管理更加清晰方便是唯一的优势。 所以该项目更多用于团队内学习和了解Docker的使用。

# 使用者文档 #

1. 运行setup文件夹下的`DockerToolbox.exe`安装DockerToolbox。如果系统中已安装Virutal Box和Git，则不需要勾选，否则一定要注意勾选这两项。
![](../master/images/docker_toolbox.jpg)

2. 运行`start.bat`，等待自动安装，直至出现如下的界面（若有文字提示“Deault Boot2Docker ISO is out-of-date, downloading the latest release...”可联系开发或维护人员更新boot2docker.iso）
![](../master/images/shell.jpg)

3. 输入`1`，回车，绿色文字提示输入工作目录。注意这里输入的是所有项目所在的文件夹。路径使用linux规范，如本机工作目录是`e:\Repository`，则应该输入`/e/Repository`。如果路径输入错误或路径不存在，则会提示，并要求重新输入。随后等待直至出现绿色文字提示`Set Sharedfolder Success!`。按回车继续。
![](../master/images/share_folder.jpg)

4. 输入`2`，回车，等待安装开发环境的镜像，直至出现绿色文字`Setup Develop Dockerfile Sucess!`。按回车继续。
![](../master/images/setup.jpg)

5. 输入`3`，回车，绿色文字提示`Start/Restart Docker Sucess!`，按回车继续。

6. 输入`4`，回车，进入Docker容器，绿色文字提示`WelCome to Docker! IP: 192.168.99.100`，即为成功，使用这个IP就可以访问Docker。使用命令`cd /develop`，即可进入第3步中挂载的本地工作目录。

    ![](../master/images/enter.jpg)
    - 初次安装需执行步骤1-4
    - 更换工作目录，或更新、重装整个环境，按需要执行步骤1-4
    - 每次开机或重启后需执行一次步骤5，执行步骤6出现“No such container: heygears”提示时执行步骤5
    - 每次使用只需执行步骤6进入开发环境
    
    **开发环境操作示例**
    - 通过`cd`命令进入所需的项目
    - 使用npm或cnpm install 必要的module
    - 根据实际要求编译或启动整个项目
    - **复制该Docker项目文件夹根目录的`nginx_config.conf`到工作目录的根目录，修改文件名为`项目名称.conf`(如e:\Repository\website.conf)**
    - 编辑该文件，**不要**修改`listen`端口，修改`server_name`为所需的域名，修改`location`为本地nodejs服务路径。
    ![](../master/images/nginx.jpg)
    - 每次修改"项目名称.conf"文件后，在控制台输入命令`nginx -s reload`，重启Docker中的nginx服务器，若无任何消息提示，则表示配置文件无误，重启完成。
    - 随后可在本机修改`hosts`文件，将nginx配置文件中填写的域名指向到Docker的IP。
    ![](../master/images/hosts.jpg)
    - 在本机浏览器输入域名，即可访问。

7. 在控制台菜单输入`5`，即可进入Docker Machine的终端，一般用于维护，查看等进阶操作。

8. 在控制台菜单输入`6`，可重启Docker Machine。某些时候重启以解决奔溃或者虚拟机异常等问题。

9. 在控制台菜单输入`7`，退出控制台。

# 开发者文档 #

**维护建议说明：**
- 建议维护：代表建议开发者定期更新或修改
- 一般维护：代表开发者无需频繁维护或可以对该文件不予理会
- 不建议维护：代表不建议开发者修改该文件

**维护文件：**

1. **[setup\DockerToolbox.exe]**（建议维护）：可在docker官网[下载](https://www.docker.com/products/docker-toolbox)，由于国内网络部分被墙，速度非常慢，需要ss或vpn访问。开发者可定期下载，更新替换项目中的DockerToolbox安装包。国内网络也可在代理网站[下载](https://get.daocloud.io/toolbox/)。

2. **[source\CentOS7-Base-163.repo]**（一般维护）：centos7的163yum源

3. **[source\nginx-1.13.1.tar.gz]**（一般维护）：nginx_1.13.1安装包

4. **[source\node-v6.11.0-linux-x64.tar.xz]**（一般维护）：nodejs_6.11.0安装包

5. **[source\nginx.conf]**（一般维护）：nginx配置，用于替换Docker中安装的nginx_1.13.1的默认配置文件。主要增加一行配置` include /develop/*.conf;`，将/develop文件夹下的所有配置文件加载进来。

    ```nginx
    #user  nobody;
    worker_processes  1;
    error_log  logs/error.log;
    pid        logs/nginx.pid;
    
    events {
        worker_connections  1024;
    }
    
    http {
        include       mime.types;
        default_type  application/octet-stream;
        access_log  logs/access.log;
        sendfile        on;
        keepalive_timeout  65;
    
        server {
            listen       80;
            server_name  localhost;
    
            location / {
                root   html;
                index  index.html index.htm;
            }
    
            #error_page  404              /404.html;
    
            # redirect server error pages to the static page /50x.html
            #
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }
        }
        include /develop/*.conf;
    }
    
    ```
6. **[boot2docker.iso]**（建议维护）：boot2docker发布的用于安装docker的linux最小系统。Docker Toolbox安装后，目录中已经有boot2docker.iso文件，但有可能版本不是最新，启动Docker Machine时会检查对应的boot2docker.iso的版本，如果不是最新，会从github下载，还是国内网速影响，经常会失败。所以开发者可以定期通过ss或vpn下载新版的boot2docker.iso，启动脚本时，会自动将该目录的boot2docker.iso拷贝到Docker Machine中。

7. **[centos.tar]**（不建议维护）：制作的centos:latest 文件的导出包。如果需要更新最新的centos:latest版本，或者使用其他版本如centos:6.5。可以参考“使用者文档”，通过控制台选择`4. Enter Docker Machine`，进入Docker Machine终端：
     - 键入命令`docker images` 查看是否存在centos:latest镜像
     - 如果存在，键入命令`docker rmi -f centos:latest`删除现有的centos:latest
     - 键入命令`docker pull centos:latest`或`docker pull centos:6.5`下载最新的centos或指定版本的centos
     - 若下载非centos:latest，建议使用命令`docker tag centos:6.5 centos:latest`将其命名成latest，因为在[docker_machine_shell.sh]和[Dockerfile]中，很多指令基于centos:latest，以免引起不必要的麻烦。如果你很熟悉docker命令，可以修改[docker_machine_shell.sh]和[Dockerfile]的内容。
     - 键入命令`docker save centos:latest > /e/centos.tar`，就可以将centos:latest导出到E盘根目录，名称为centos.tar

8. **[docker_machine_shell.sh]**（不建议维护）：基于Docker Toolbox安装目录的`start.sh`修改的脚本。代码中凡是添加了`##Custom Addition Begin`标注的都是自定义的内容并配有注释，其他的均是Docker Toolbox的`start.sh`源码。部分自定义源码片段如下：

    ``` sh
    ##Custom Addition Begin
    #check docker toolbox
    if [ -z "${DOCKER_TOOLBOX_INSTALL_PATH}" ]; then
      echo "Docker ToolBox is not installed. Please re-run the Toolbox Installer and try again."
      read -p "Press enter to continue."
      exit
    fi
    cd "${DOCKER_TOOLBOX_INSTALL_PATH}"
    ##Custom Addition End
    ```
    ``` sh
    ##Custom Addition Begin
    #use local boot2docker.iso
    echo -e "${GREEN}Copy local boot2docker.iso... ${NC}"
    currentFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    if [ ! -e "${currentFolder}/boot2docker.iso" ]; then  
    echo -e "${GREEN}Can not find boot2docker.iso in ${currentFolder} ${NC}"
    else
    if [ ! -d "~/.docker/machine/cache" ]; then  
        mkdir -p ~/.docker/machine/cache
    fi
    cp "${currentFolder}"/boot2docker.iso ~/.docker/machine/cache/
    fi
    ##Custom Addition End
    
    ```
    ``` sh
    ##Custom Addition Begin
    #Boot Manager
    STEP="Boot_Manager"
    
    Boot_Manager(){
      clear
      echo -e "${BLUE}-----Docker Machine Manager-----${NC}"
      echo -e "${BLUE}1. Set Sharedfolder ${NC}"
      echo -e "${BLUE}2. Setup Develop Environment ${NC}"
      echo -e "${BLUE}3. Enter Develop Environment ${NC}"
      echo -e "${BLUE}4. Enter Docker-Machine Bash ${NC}"
      echo -e "${BLUE}5. Restart Docker-Machine ${NC}"
      echo -e "${BLUE}6. Exit ${NC}"
      read choose
      case $choose in
            1) #1. Set Sharedfolder
            hasNoDir=true
            while ${hasNoDir}
              do
              echo -e "${GREEN}Input hostPath:${NC}"
              read hostPath
              hostPath=`echo $hostPath | sed "s/\"//g" | sed "s/'//g"`
              if [ -d "$hostPath" ]; then  
                hasNoDir=false
              else
                hasNoDir=true
                echo -e "${GREEN}Can not find dir: ${hostPath} ${NC}"
              fi
            done
            if [ "${VM_STATUS}" == "Running" ]; then
              "${DOCKER_MACHINE}" stop "${VM}"
            fi
            #remove sharedfolder named develop
            "${VBOXMANAGE}" sharedfolder remove "${VM}" --name develop
            #add sharedfolder named develop
            "${VBOXMANAGE}" sharedfolder add "${VM}" --name develop --hostpath "${hostPath}" --automount
            #support symlink
            "${VBOXMANAGE}" setextradata "${VM}" VBoxInternal2/SharedFoldersEnableSymlinksCreate/develop 1
            #start vm
            "${DOCKER_MACHINE}" start "${VM}"
            yes | "${DOCKER_MACHINE}" regenerate-certs "${VM}"
            eval "$(${DOCKER_MACHINE} env --shell=bash --no-proxy ${VM})"
            echo -e "${GREEN}Set Sharedfolder Sucess! ${NC}"
            read -p "Press enter to continue."
            Boot_Manager
            ;;
            2) #2. Setup Develop Environment 
            currentFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
            if [ ! -e "${currentFolder}/Dockerfile" ]; then  
              echo -e "${GREEN}Can not find dockerfile in ${currentFolder} ${NC}"
              read -p "Press enter to continue."
              Boot_Manager
            fi
            if [ ! -e "${currentFolder}/centos.tar" ]; then  
              echo -e "${GREEN}Can not find centos.tar in ${currentFolder} ${NC}"
              read -p "Press enter to continue."
              Boot_Manager
            fi
    
            #rm image named centos:latest
            docker rmi -f centos:latest || true
            #rm image named centos:heygears
            docker rmi -f centos:heygears || true
            #load image
            docker load < "${currentFolder}/centos.tar"
            #build dockerfile to generate centos:heygears
            cd "${currentFolder}"
            docker build --no-cache --rm -t centos:heygears .
            cd -
            echo -e "${GREEN}Setup Develop Dockerfile Sucess! ${NC}"
            read -p "Press enter to continue."
            Boot_Manager
            ;;
            3) #3. Enter Develop Environment
            #rm container named heygears
            docker rm -f `docker ps -a -f name=heygears -q` || true
            #run centos:heygears in docker machine
            #--privileged=true means run docker with the highest privileges
            #-p 80:80 means expose port 80
            #-v /develop:/develop means mount docker machine's path "/develop" to docker "/develop" based on setp 1(Set Sharedfolder)
            docker-machine ssh "${VM}" 'docker run -d --name heygears --privileged=true -p 80:80/tcp -v /develop:/develop centos:heygears'
            #show docker ip
            echo -e "${GREEN}WelCome to Docker! IP: `docker-machine ip` ${NC}"
            #use winpty enter container
            winpty docker exec -it heygears bash
            Boot_Manager
            ;;
            4) #4. Enter Bash
            cat << EOF
    
    
                            ##         .
                      ## ## ##        ==
                   ## ## ## ## ##    ===
               /"""""""""""""""""\___/ ===
          ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
               \______ o           __/
                 \    \         __/
                  \____\_______/
    
    EOF
            echo -e "${BLUE}docker${NC} is configured to use the ${GREEN}${VM}${NC} machine with IP ${GREEN}$(${DOCKER_MACHINE} ip ${VM})${NC}"
            echo "For help getting started, check out the docs at https://docs.docker.com"
            echo
            
    
            docker () {
              MSYS_NO_PATHCONV=1 docker.exe "$@"
            }
            export -f docker
    
            if [ $# -eq 0 ]; then
              echo "Start interactive shell"
              exec "$BASH" --login -i
            else
              echo "Start shell with command"
              exec "$BASH" -c "$*"
            fi
            ;;
            5) #5. Restart Docker-Machine
            if [ "${VM_STATUS}" == "Running" ]; then
              "${DOCKER_MACHINE}" stop "${VM}"
            fi
            "${DOCKER_MACHINE}" start "${VM}"
            yes | "${DOCKER_MACHINE}" regenerate-certs "${VM}"
            eval "$(${DOCKER_MACHINE} env --shell=bash --no-proxy ${VM})"
            ;;
            6) #6. exit
            exit
            ;;
            *) #other operation
            Boot_Manager
            ;;
      esac
    }
    
    Boot_Manager
    ##Custom Addition End
    ```

9. **[Dockerfile]**（建议维护）：默认基于centos:latest，生成前端开发环境系统镜像的指令集。如需安装新版nginx或nodejs，执行其他系统命令，或安装其他软件，可以直接修改Dockerfile。使用者执行“使用者文档”步骤4，重新安装开发环境即可完成更新。
    
    ``` dockerfile
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
        && yum -y install autoconf libjpeg libjpeg-devel libpng libpng-devel \
        && yum -y install freetype freetype-devel curl curl-devel libxml2 libxml2-devel \
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
    ```

10. **[nginx_config.conf]**（一般维护）：使用者基于该配置文件，在工作目录的根目录，为每一个项目配置nginx，通过代理，访问nodejs。

11. **[start.bat]**（不建议维护）：为了解决NTFS磁盘在Virtual Box共享目录以及linux下的种种问题，需使用管理员权限打开Virtual Box。于是在**[docker_machine_shell.sh]**外，再包了一层批处理，自动使用windows管理员权限。
