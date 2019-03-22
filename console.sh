#!/bin/bash
trap '[ "$?" -eq 0 ] || read -p "Looks like something went wrong in step ´$STEP´... Press any key to continue..."' EXIT

BLUE='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m'

#Boot Manager
STEP="Boot_Manager"

Boot_Manager(){
  clear
  echo -e "${BLUE}-----FrontEnd In Docker v5.0-----${NC}"
  echo -e "${BLUE}1. Build And Run Image ${NC}"
  echo -e "${BLUE}2. Start Container ${NC}"
  echo -e "${BLUE}3. Enter Container ${NC}"
  echo -e "${BLUE}4. Enter Docker Console ${NC}"
  echo -e "${BLUE}9. Clean All [warning!!!] ${NC}"
  echo -e "${BLUE}0. Exit ${NC}"
  read choose
  case $choose in
        1) #1. Build And Run Image
        echo -e "${GREEN}Start Building... ${NC}"

        currentFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        if [ ! -e "${currentFolder}/source/Dockerfile" ]; then  
          echo -e "${GREEN}Can not find dockerfile in ${currentFolder} ${NC}"
          read -p "Press Enter to Continue."
          Boot_Manager
        fi
        #rm image and container
        docker rm -f `docker ps -a -f name=myfrontend -q` || true
        docker rmi -f node:mynode || true

        #build dockerfile to generate node:mynode
        cd "${currentFolder}/source"
        docker build --no-cache --rm -t node:mynode .
        cd -

        echo -e "${GREEN}Input hostPath (Eg. e:/workspace):${NC}"
        read hostPath
        hostPath=`echo $hostPath | sed "s/\"//g" | sed "s/'//g"`

        #run node:myfrontend
        #--privileged=true means run docker with the highest privileges
        #-p 80:80 means expose port 80 for nginx
        # expose 9080 for web-dev-server HMR
        docker run -d --name myfrontend --privileged=true -p 80:80 -p 9080:9080 -v ${hostPath}:/app node:mynode

        echo -e "${GREEN}Running Sucess! ${NC}"
        read -p "Press Enter to Continue."

        Boot_Manager
        ;;
        2) #2. Start Container
        docker start myfrontend
        echo -e "${GREEN}Start Container Sucess! ${NC}"
        read -p "Press Enter to Continue."
        Boot_Manager
        ;;
        3) #3. Enter Container
        #use winpty enter container
        winpty docker exec -it myfrontend bash
        Boot_Manager
        ;;
        4) #4. Enter docker console
        bash
        Boot_Manager
        ;;
        9) #9. Clean All
        read -p "Warning!!!  Press Ctrl+C to Quit. Press Enter to Continue."
        read -p "Are You Sure to Clean All?  Press Ctrl+C to Quit. Press Enter to Continue."

        docker rm -f `docker ps -a -f name=myfrontend -q` || true
        docker rmi -f node:mynode || true

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
