#!/bin/bash

trap '[ "$?" -eq 0 ] || read -p "Looks like something went wrong in step ´$STEP´... Press any key to continue..."' EXIT

# TODO: I'm sure this is not very robust.  But, it is needed for now to ensure
# that binaries provided by Docker Toolbox over-ride binaries provided by
# Docker for Windows when launching using the Quickstart.
export PATH="/c/Program Files/Docker Toolbox:$PATH"
VM=${DOCKER_MACHINE_NAME-default}

##Custom Addition Begin
#check docker toolbox
if [ -z "${DOCKER_TOOLBOX_INSTALL_PATH}" ]; then
  echo "Docker ToolBox is not installed. Please re-run the Toolbox Installer and try again."
  read -p "Press enter to continue."
  exit
fi
cd "${DOCKER_TOOLBOX_INSTALL_PATH}"
##Custom Addition End

DOCKER_MACHINE=./docker-machine.exe

STEP="Looking for vboxmanage.exe"
if [ ! -z "$VBOX_MSI_INSTALL_PATH" ]; then
  VBOXMANAGE="${VBOX_MSI_INSTALL_PATH}VBoxManage.exe"
else
  VBOXMANAGE="${VBOX_INSTALL_PATH}VBoxManage.exe"
fi

BLUE='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m'

#clear all_proxy if not socks address
if  [[ $ALL_PROXY != socks* ]]; then
  unset ALL_PROXY
fi
if  [[ $all_proxy != socks* ]]; then
  unset all_proxy
fi

if [ ! -f "${DOCKER_MACHINE}" ]; then
  echo "Docker Machine is not installed. Please re-run the Toolbox Installer and try again."
  read -p "Press enter to continue."
  exit
fi

if [ ! -f "${VBOXMANAGE}" ]; then
  echo "VirtualBox is not installed. Please re-run the Toolbox Installer and try again."
  read -p "Press enter to continue."
  exit
fi

"${VBOXMANAGE}" list vms | grep \""${VM}"\" &> /dev/null
VM_EXISTS_CODE=$?

set -e

STEP="Checking if machine $VM exists"
if [ $VM_EXISTS_CODE -eq 1 ]; then
  "${DOCKER_MACHINE}" rm -f "${VM}" &> /dev/null || :
  rm -rf ~/.docker/machine/machines/"${VM}"
  #set proxy variables if they exists
  if [ "${HTTP_PROXY}" ]; then
    PROXY_ENV="$PROXY_ENV --engine-env HTTP_PROXY=$HTTP_PROXY"
  fi
  if [ "${HTTPS_PROXY}" ]; then
    PROXY_ENV="$PROXY_ENV --engine-env HTTPS_PROXY=$HTTPS_PROXY"
  fi
  if [ "${NO_PROXY}" ]; then
    PROXY_ENV="$PROXY_ENV --engine-env NO_PROXY=$NO_PROXY"
  fi

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

  "${DOCKER_MACHINE}" create -d virtualbox $PROXY_ENV "${VM}"
fi

STEP="Checking status on $VM"
VM_STATUS="$(${DOCKER_MACHINE} status ${VM} 2>&1)"
if [ "${VM_STATUS}" != "Running" ]; then
  "${DOCKER_MACHINE}" start "${VM}"
  yes | "${DOCKER_MACHINE}" regenerate-certs "${VM}"
fi

STEP="Setting env"
eval "$(${DOCKER_MACHINE} env --shell=bash --no-proxy ${VM})"


##Custom Addition Begin
#Boot Manager
STEP="Boot_Manager"

Boot_Manager(){
  clear
  echo -e "${BLUE}-----Docker Machine Manager v4.0-----${NC}"
  echo -e "${BLUE}1. Creat Volume (will delete volume if exist) [warning!!!] ${NC}"
  echo -e "${BLUE}2. Build Image ${NC}"
  echo -e "${BLUE}3. Start/Restart Container ${NC}"
  echo -e "${BLUE}4. Enter Container ${NC}"
  echo -e "${BLUE}5. Enter Docker-Machine Bash ${NC}"
  echo -e "${BLUE}6. Restart Docker-Machine ${NC}"
  echo -e "${BLUE}9. Clean All (Volume Image Container) [warning!!!] ${NC}"
  echo -e "${BLUE}0. Exit ${NC}"
  read choose
  case $choose in
        1) #1. Creat Volume 
        read -p "Warning!!!  Press Ctrl+C to Quit. Press Enter to Continue."
        read -p "It will delete volume if exist!!! Press Ctrl+C to Quit. Press Enter to Continue."
        docker-machine ssh "${VM}" 'sudo rm -rf /data && sudo mkdir /data && sudo chmod 777 /data'
        echo -e "${GREEN}Creat Volume Sucess! ${NC}"
        read -p "Press Enter to Continue."
        Boot_Manager
        ;;
        2) #2. Build Image 
        currentFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        if [ ! -e "${currentFolder}/source/Dockerfile" ]; then  
          echo -e "${GREEN}Can not find dockerfile in ${currentFolder} ${NC}"
          read -p "Press Enter to Continue."
          Boot_Manager
        fi

        #rm image named node:mynode
        docker rmi -f node:mynode || true
        #build dockerfile to generate node:mynode
        cd "${currentFolder}/source"
        docker build --no-cache --rm -t node:mynode .
        cd -
        echo -e "${GREEN}Build Image Sucess! ${NC}"
        read -p "Press Enter to Continue."
        Boot_Manager
        ;;
        3) #3. Start/Restart Container
        #rm container named myfrontend
        docker rm -f `docker ps -a -f name=myfrontend -q` || true
        #run node:myfrontend in docker machine
        #--privileged=true means run docker with the highest privileges
        #-p 80:80 means expose port 80
        # expose 445 for samba
        docker-machine ssh "${VM}" 'docker run -d --name myfrontend --privileged=true -p 80:80 -p 445:445 -v /data:/app node:mynode'
        echo -e "${GREEN}Start/Restart Container Sucess! ${NC}"
        read -p "Press Enter to Continue."
        Boot_Manager
        ;;
        4) #4. Enter Container
        #show docker ip
        echo -e "${GREEN}Welcome to Docker! IP: `docker-machine ip` ${NC}"
        #use winpty enter container
        winpty docker exec -it myfrontend bash
        Boot_Manager
        ;;
        5) #5. Enter Bash
        docker-machine ssh "${VM}"
        ;;
        6) #6. Restart Docker-Machine
        if [ "${VM_STATUS}" == "Running" ]; then
          "${DOCKER_MACHINE}" stop "${VM}"
        fi
        "${DOCKER_MACHINE}" start "${VM}"
        yes | "${DOCKER_MACHINE}" regenerate-certs "${VM}"
        eval "$(${DOCKER_MACHINE} env --shell=bash --no-proxy ${VM})"
        ;;
        9) #9. Clean All
        read -p "Warning!!!  Press Ctrl+C to Quit. Press Enter to Continue."
        read -p "Are You Sure to Clean All?  Press Ctrl+C to Quit. Press Enter to Continue."
        rm -rf /data
        docker rm -f $(docker ps -aq) || true
        docker rmi -f $(docker images -q) || true
        echo -e "${GREEN}Clean All Sucess! ${NC}"
        read -p "Press Enter to Continue."
        Boot_Manager
        ;;
        0) #0. exit
        exit
        ;;
        *) #other operation
        Boot_Manager
        ;;
  esac
}

Boot_Manager
##Custom Addition End
