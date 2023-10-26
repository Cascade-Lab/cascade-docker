# Running Cascade with Docker

## Download the Cascade Docker toolkit

### Using git
```shell
git clone https://github.com/Cascade-Lab/cascade-docker.git
cd cascade-docker/
```

### Or using wget

```shell
wget https://github.com/Cascade-Lab/cascade-docker/archive/refs/heads/master.zip
unzip master.zip
cd cascade-docker/
```
## Install docker and docker compose if now yet installed

Courtesy scripts for Ubuntu and Debian are provided in the support folder. Please refer to the official Docker documentation for installation instructions for your platform.
https://docs.docker.com/engine/install/


```shell
cd support/
chmod +x docker-install-ubuntu.sh
./docker-install-ubuntu.sh
```

## Log in to Cascade Container Registry

```shell
docker login -u USER -p PASSWORD cascadelab.azurecr.io
```

Note: USER and PASSWORD are provided by Cascade client care.

https://docs.docker.com/engine/reference/commandline/login/#credentials-store

## Start Cascade

Make sure your are in the cascade-docker folder.

```shell
sudo docker compose up
```

## Stop Cascade

```shell
sudo docker compose down
```