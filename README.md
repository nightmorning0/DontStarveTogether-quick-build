# DontStarveTogether-quick-build

This repo aims to build Don't Starve Together dedicate server on Linux system quickly and simply. To achieve this, you need five steps:

1. Install docker on your Linux server
2. Build/pull image
3. Start a container from the image
4. Copy the config files from your PC game to the server
5. Start the game

Each step shouldn't take more than 5 minutes! Let's start :)

## Install docker

Since your are viewing this repo, I suppose you already know docker enough. But just in case, I put the simple instruction here to show how to install it on your server.

Take Unbuntu as the example:

```shell
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

If you need more help, please follow the [official instruction](https://docs.docker.com/engine/install/).

## Build/pull image

To build the image, you can execute:

```shell
docker build . -t dstserver:latest
```

This step will build and use steamcmd to download the server. Thus, the time will be used really depend on your bandwidth.

Alternatively, you can also choose to pull the images I've built and uploaded to DockerHub:

```shell
docker pull nightmorning/donotstarvetogether:latest
```

However, I really don't recommand this method because I CANNOT ensure the image I built will always catch up the update. (Can't believe such an old game is still updating).

## Start a container

Here we need to do is to use the image and a create an instance, aka container.

```
docker run -itd -p 10999:10999/udp -name dst-server dstserver:latest bash
```

This command will start and a container and keep it run in the backend. To attach(enter) the container, you can use:

```
docker exec -it dst-server bash
```

## Configure the game

You must know that creating a new world in Don't Starve Together is sometimes complicated. There are so many options to select. Things can be worse if you config the file in JSON/YAML files on server. That would be a disaster!

Thus, a smart way is to open your game on your PC, create a new world you want to deploy on the server, and upload the config files in to the server.

Firstly, once you enter the game, press `~` on your keyboard to call the console and input:

```
TheNet:GenerateClusterToken()
```

This operation will generate a token for you. The game company need it to identify you.

Next, go to create a new world, or you can even use an existing world. Then, click on `Manage World` and you will see the interface like bellow:

<img src="https://raw.githubusercontent.com/nightmorning0/DontStarveTogether-quick-build/master/pics/p1.png" alt="img" style="zoom: 67%;" />

Click on `Open World Folder` and you will see a window bump out, that is the location of your configure files, named like `Cluster_*`. And at its parent folder, there will be a token file named `cluster_token.txt`. Move `cluster_token.txt` to your `Cluster_*` folder, copy the folder to this project, and rename it as `Cluster_1`. The project tree should be like:

```
.
|_ pics
|_ scripts
|_ Cluster_1
|_ Dockerfile
|_ LICENSE
|_ README.md
```

Then you can you the command below to upload your config to the server:

```shell
sudo docker cp Cluster_1 dst-server:/root/.klei/DoNotStarveTogether
```

## Start the game

What you need here is to attach your container:

```shell
docker exec -it dst-server bash
```

and start the server:

```shell
screen -dmS dst "start"
exit
```

Then you can open the game on your PC, push `~` to call the console, and use `c_connect` to connect to your server:

```shell
c_connect("<IP or Hostname>", <port>, "<password>")
```

You're all done. Congratulations and enjoy the game!
