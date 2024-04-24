![image](https://github.com/Cascade-Lab/cascade-docker/assets/146708464/82930c60-b645-427b-b7ae-821d88adbd66)

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
chmod +x support/docker-install-ubuntu.sh
./support/docker-install-ubuntu.sh
```

## Log into the Cascade Container Registry

```shell
docker login -u User -p Docker-Password cascadelab.azurecr.io
```

Note: Docker-User and Docker-Password are provided by Cascade client care.

https://docs.docker.com/engine/reference/commandline/login/#credentials-store

## Customize Password

Open the 'db_password.txt' file and update the password to your desired one

## Creating Database and Attachment Folders

Step 1: Create Necessary Folders for the data at your desired location .

Go to the desired location and execute the following command in your terminal: 

```shell
mkdir -p data/db data/documents
```
After running this command: 

The data/db and data/documents directories will be created within your desired location. 


Step 2: Update Docker Compose Configuration 

In your “docker-compose.yaml” file, update the volume paths with the path where you created data/db and data/documents directories: 

```docker-compose.yaml
volumes:
  db-data:
    driver_opts:
      type: none
      o: bind
      device: /<pathToDataDirectory>/data/db
  app-data:
    driver_opts:
      type: none
      o: bind
      device: /<pathToDataDirectory>/data/documents
```

## Start Cascade

Make sure you are in the cascade-docker folder.

```shell
docker compose up
```
Wait 1-2 minutes then go to http://localhost:8080/ , this screen should appear: 

![image](https://github.com/Cascade-Lab/cascade-docker/assets/146708464/71e9fd9a-045a-451e-b1b7-d758899e77f6)

Then, enter and activate the license. 

Note: License is provided by Cascade client care. 
 
Once License has been activated, a login screen like this should display: 

![image](https://github.com/Cascade-Lab/cascade-docker/assets/146708464/737a42ae-6e42-46e0-b066-8ba95464deff)

You will have to connect with the following credentials: 

Username: admin@example.com 

Password: secret 

## Opening external access

The application can be connected to two domains and their subdomains, which should be available 
from your infrastructure in case of usage:
* neterium.cloud (Name screening API - Neterium)
* sentry.io (Error tracking - Sentry. Optional)

To be sure that the application can connect, go to Health Dashboard: 

![image](https://github.com/Cascade-Lab/cascade-docker/assets/146708464/aa942dee-a518-4868-92c4-5eeb433ca121)

And check if the Screening API field is working: 

![image](https://github.com/Cascade-Lab/cascade-docker/assets/146708464/6e9018c2-3870-4ce8-8959-976237288aa8)

## Secure Password

Make sure you are in the cascade-docker folder.

```shell
chmod 600 db_password.txt
```
After running this command, the file will have permissions set to 600, granting read and write access only to the file owner while denying access to other users.

## Stop Cascade
 
It is possible to stop Cascade, first make sure you are in the cascade-docker folder, then execute the following command line. 
```
docker compose stop
```

## Backup Cascade

The **data** folder is what you need to backup.

## Update Cascade 

To update Cascade using Docker, you'll need to utilize the latest image released by Cascade. For example: 
```
cascadelab.azurecr.io/cascade-lab/cascade/prod:v4.5.0
```
The latest Docker image is provided by Cascade Client Care. Once you have the Docker image, replace the old image with the new one provided in the docker-compose.yaml file.  
```
app: 

    restart: always 

    image: cascadelab.azurecr.io/cascade-lab/cascade/prod:v4.3.0 

    depends_on: 
```
---

Congratulations! You've successfully completed the Docker setup for Cascade. Should you have any further questions or encounter any issues, don't hesitate to reach out to our support team. 
