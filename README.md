# Running Cascade with Docker on Linux

### Download the Cascade Docker toolkit

#### Using git
```shell
git clone https://github.com/Cascade-Lab/cascade-docker.git
cd cascade-docker/
```

#### Or using wget

```shell
wget https://github.com/Cascade-Lab/cascade-docker/archive/refs/heads/master.zip
unzip master.zip
cd cascade-docker/
```
### Install docker and docker compose if now yet installed

Courtesy scripts for Ubuntu and Debian are provided in the support folder. Please refer to the official Docker documentation for installation instructions for your platform.
https://docs.docker.com/engine/install/

```shell
cd support/
chmod +x docker-install-ubuntu.sh
./docker-install-ubuntu.sh
```

### Log in to Cascade Container Registry

```shell
docker login -u USER -p PASSWORD cascadelab.azurecr.io
```

Note: USER and PASSWORD are provided by Cascade client care.

https://docs.docker.com/engine/reference/commandline/login/#credentials-store

### Customize Password

Open the 'db_password.txt' file and update the password to your desired one

### Secure Password

Make sure you are in the cascade-docker folder.

```shell
chmod 600 db_password.txt
```
After running this command, the file will have permissions set to 600, granting read and write access only to the file owner while denying access to other users.

### Set Backup Folder

```shell
sudo mkdir -m 600 -p /etc/backups
```
After running this command, the backup folder will have permissions set to 600, granting read and write access only to the file owner while denying access to other users.

### Start Cascade

Make sure your are in the cascade-docker folder.

```shell
sudo docker compose up
```

### Stop Cascade

```shell
sudo docker compose stop
```





# How the Backups Folder Works?

First, there is an automatic daily backup of the database, a new backup is created in the `last` folder with the full time.

Once this backup finishes successfully, then it is hard linked (instead of copying to avoid using more space) to the rest of the folders (`daily`, `weekly`, and `monthly`). This step replaces the old backups for that category, storing always only the latest for each category (so the monthly backup for a month always stores the latest for that month and not the first).

So, the backup folders are structured as follows:

- `/backups/last/cascade-YYYYMMDD-HHmmss.sql.gz`: All the backups are stored separately in this folder.
  : all the backups are stored separately in this folder.

- `/backups/daily/cascade-YYYYMMDD.sql.gz`: Always store (hard link) the latest backup of that day.
  : always store (hard link) the latest backup of that day.

- `/backups/weekly/cascade-YYYYww.sql.gz`: Always store (hard link) the latest backup of that week (the last day of the week will be Sunday as it uses ISO week numbers).
  : always store (hard link) the latest backup of that week (the last day of the week will be Sunday as it uses ISO week numbers).

- `/backups/monthly/cascade-YYYYMM.sql.gz`: Always store (hard link) the latest backup of that month (normally the ~31st).
  : always store (hard link) the latest backup of that month (normally the ~31st).

The following symlinks are also updated after each successful backup for simplicity:

```plaintext
/backups/last/cascade-latest.sql.gz -> /backups/last/cascade-YYYYMMDD-HHmmss.sql.gz
/backups/daily/cascade-latest.sql.gz -> /backups/daily/cascade-YYYYMMDD.sql.gz
/backups/weekly/cascade-latest.sql.gz -> /backups/weekly/cascade-YYYYww.sql.gz
/backups/monthly/cascade-latest.sql.gz -> /backups/monthly/cascade-YYYYMM.sql.gz
```

### Cleaning Process

For cleaning, the script removes the files for each category only if the new backup has been successful. To do so, it is using the following independent variables:

- **BACKUP_KEEP_MINS:** Will remove files from the `last` folder that are older than its value in minutes after a new successful backup without affecting the rest of the backups (because they are hard links). (Defaults set to 1440 (1 day))

- **BACKUP_KEEP_DAYS:** Will remove files from the `daily` folder that are older than its value in days after a new successful backup. (set to 7)

- **BACKUP_KEEP_WEEKS:** Will remove files from the `weekly` folder that are older than its value in weeks after a new successful backup (remember that it starts counting from the end of each week, not the beginning). (set to 4)

- **BACKUP_KEEP_MONTHS:** Will remove files from the `monthly` folder that are older than its value in months (of 31 days) after a new successful backup (remember that it starts counting from the end of each month, not the beginning). (set to 6)





# Restore your Backup on Linux

### Step 1: Check Running Containers

Ensure the necessary containers are running:
```shell
docker ps
```
Expected running containers: cascade-docker-pgbackups-1, cascade-docker-app-1, and cascade-docker-db-1.

### Step 2: View Available Backups

Check available backups in the specified directory (monthly, weekly, daily, or last):
```shell
ls /etc/backups/<directory>
```
Select the desired backup for restoration and save the backup name, you will need it in further steps.

### Step 3: Stop Containers

Stop relevant containers:
```shell
docker stop cascade-docker-pgbackups-1 cascade-docker-app-1 cascade-docker-db-1
```

### Step 4: Remove Container and Volume

Remove the database container and associated volume:
```shell
docker rm cascade-docker-db-1
docker volume rm cascade-docker_db-data
```

### Step 5: Start Database Service

Restart the database service only:
```shell
docker compose up -d db
```

### Step 6: Restore Backup

Restore the chosen backup into the new database:
```shell
docker exec --tty --interactive cascade-docker-db-1 /bin/sh -c "zcat /backups/last/<your backup name> | psql --username=cascade --dbname=cascade -W"
```
Enter the database password, can be found in db_password.txt file.

### Step 7: Restart Application and Backup

Restart the application and backup services:
```shell
docker compose up -d
```





# Running Cascade with Docker on Windows

### Download the Cascade Docker toolkit

```shell
git clone https://github.com/Cascade-Lab/cascade-docker.git
cd cascade-docker/
```

### Remove from docker-compose

Remove this part from the docker-compose.yaml file
```yaml
    driver_opts:
      type: none
      o: bind
      device: /etc/backups
```

### Install docker and docker compose if now yet installed

Courtesy scripts for Ubuntu and Debian are provided in the support folder. Please refer to the official Docker documentation for installation instructions for your platform.
https://docs.docker.com/engine/install/

### Log in to Cascade Container Registry

```shell
docker login -u USER -p PASSWORD cascadelab.azurecr.io
```

Note: USER and PASSWORD are provided by Cascade client care.

https://docs.docker.com/engine/reference/commandline/login/#credentials-store

### Customize Password

Open the 'db_password.txt' file and update the password to your desired one

### Secure Password

Make sure you are in the cascade-docker folder.

```shell
icacls "db_password.txt" /inheritance:r /grant:r "%username%:F"
```
After running this command, the file will have permissions set, granting read and write access only to the file owner while denying access to other users.

### Set Backup Folder

```shell
docker exec -it cascade-docker-pgbackups-1 /bin/bash -c "sudo mkdir -m 600 -p backups"
```
After running this command, the backup folder will have permissions set to 600, granting read and write access only to the file owner while denying access to other users.

### Start Cascade

Make sure your are in the cascade-docker folder.

```shell
sudo docker compose up
```

### Stop Cascade

```shell
sudo docker compose stop
```





# Restore your Backup on Windows

### Step 1: Check Running Containers

Ensure the necessary containers are running:
```shell
docker ps
```
Expected running containers: cascade-docker-pgbackups-1, cascade-docker-app-1, and cascade-docker-db-1.

### Step 2: View Available Backups

Check available backups in the specified directory (monthly, weekly, daily, or last):
```shell
docker exec -it cascade-docker-pgbackups-1 /bin/bash -c "ls backups/<directory>"
```
Select the desired backup for restoration and save the backup name, you will need it in further steps.

### Step 3: Stop Containers

Stop relevant containers:
```shell
docker stop cascade-docker-pgbackups-1 cascade-docker-app-1 cascade-docker-db-1
```

### Step 4: Remove Container and Volume

Remove the database container and associated volume:
```shell
docker rm cascade-docker-db-1
docker volume rm cascade-docker_db-data
```

### Step 5: Start Database Service

Restart the database service only:
```shell
docker compose up -d db
```

### Step 6: Restore Backup

Restore the chosen backup into the new database:
```shell
docker exec --tty --interactive cascade-docker-db-1 /bin/sh -c "zcat /backups/last/<your backup name> | psql --username=cascade --dbname=cascade -W"
```
Enter the database password, can be found in db_password.txt file.

### Step 7: Restart Application and Backup

Restart the application and backup services:
```shell
docker compose up -d
```
