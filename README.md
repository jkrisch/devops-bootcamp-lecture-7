# devops-bootcamp-lecture-7

Note: all docker commands need to run as root user

## Exercise 1 - Start Mysql Container
Run the following command.
```
#create network so the containers can find each other
docker network create mysql_network

#start mysql container
docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=my_data -e MYSQL_USER=testuser -e MYSQL_PASSWORD=testpassword -d --network mysql_network mysql:8.0.32-debian

#set env vars
export DB_USER=testuser
export DB_PWD=testpassword
export DB_SERVER=<ip of container>
export DB_NAME=my_data

#within repo folder of java app build the jarfile
./gradlew build

#run the java app locally
java -jar app/bootcamp-java-mysql-project-1.0-SNAPSHOT.jar
```

## Exercise 2 - Start mysql GUI container
```
docker run --name phpmyadmin -e --link some-mysql:db -p 8081:80 --network mysql_network -d phpmyadmin:5.2.1

#login via testuser
```

## Exercise 3 - docker compose file
see [compose file](exercise3/docker-compose.yml) file
```
#create Volume
docker volume create mysql_data

#in the folder where the compose file is located run the following command
docker-compose up -d
```

## Exercise 4 - build docker image for java app
see [Dockerfile](Dockerfile)

```
docker build -t my-java-app:1.0.0
```

## Exercise 5 - push image to (insecure) nexus on droplet
given a nexus running within a container on a digital ocean droplet.
add the nexus to the /etc/docker/daemon.json file:

```
{
  "insecure-registries" : ["http://<droplet-ip>:<nexus-port>"]
}
```

Then login to nexus and push the image:

```
docker login http://<droplet-ip>:<nexus-port>
docker tag my-java-app:1.0.0 <droplet-ip>:<nexus-port>/my-java-app:1.0.0
docker push <droplet-ip>:<nexus-port>/my-java-app:1.0.0
```

## Exercise 6 - add java app to docker compose file
see [compose file](exercise6/docker-compose.yml)

Start all three containers:
```
cd exercise6
docker-compose up -d
```

## Exercise 7 - docker-compose on server
Create droplet with: [script](create_droplet.sh). This creates a droplet starts the [entrypoint.sh](entrypoint.sh) script to while creation and includes it to the respective firewall (for external access).
add the nexus repo as insecure registry to docker daemon.
Adjust the index.html file (const HOST = <droplet-ip>), build the new jar file and push it to nexus.
Adjust the new image version within the docker-compose file as well as the imagename (using the new nexus repo).
Copy the [](exercise6/docker-compose.yml) file to the host
```
scp exercise6/docker-compose.yml root@<droplet-ip>:/var
```
On the remote host export the respective env variables (MYSQL_USER, etc.).
login to docker host.
Then run
```
docker-compose -f /var/docker-compose.yml up -d
```

## Exercise 8 - Open ports
has already been done via api creation (and adding the droplet to the respective firewall)
