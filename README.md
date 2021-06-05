# Docker SuperTuxKart Server

This is a docker image for deploying a [SuperTuxKart](https://supertuxkart.net) server.

## What is SuperTuxKart?

SuperTuxKart (STK) is a free and open-source kart racing game, distributed under the terms of the GNU General Public License, version 3. It features mascots of various open-source projects. SuperTuxKart is cross-platform, running on Linux, macOS, Windows, and Android systems. Version 1.0 was officially released on April 20, 2019.

SuperTuxKart started as a fork of TuxKart, originally developed by Steve and Oliver Baker in 2000. When TuxKart's development ended around March 2004, a fork as SuperTuxKart was conducted by other developers in 2006. SuperTuxKart is under active development by the game's community.

> [wikipedia.org/wiki/SuperTuxKart](https://en.wikipedia.org/wiki/SuperTuxKart)

![logo](https://raw.githubusercontent.com/jwestp/docker-supertuxkart/master/supertuxkart-logo.png)

## How to use this image

The image exposes ports 2759 (server) and 2757 (server discovery). The server should be configured using your own server config file. The config file template can be found [here](https://github.com/dobernoeder/docker-supertuxkart/blob/master/server_config.xml). Mount it at `/stk/server_config.xml`:

```
$ docker run --name my-stk-server \
             -d \
             -p 2757:2757 \
             -p 2759:2759 \
             -v $(pwd)/server_config.xml:/stk/server_config.xml \
             dobernoeder/supertuxkart:1.1.3
```

For hosting a public internet server (by setting `wan-server` to `true` in the config file) it is required to log in with your STK account. You can register a free account [here](https://online.supertuxkart.net/register.php). Pass your username and password to the container via environment variables.

```
$ docker run --name my-stk-server \
             -d \
             -p 2757:2757 \
             -p 2759:2759 \
             -v $(pwd)/server_config.xml:/stk/server_config.xml \
             -e USERNAME=myusername \
             -e PASSWORD=mypassword \
             dobernoeder/supertuxkart:1.1.3
```

For setting a Server Password you can use the environment variable *SERVER_PASSWORD*:

```
$ docker run --name my-stk-server \
             -d \
             -p 2757:2757 \
             -p 2759:2759 \
             -v $(pwd)/server_config.xml:/stk/server_config.xml \
             -e SERVER_PASSWORD=mypassword \
             dobernoeder/supertuxkart:1.1.3
```

The Docker-Container is able to act as Bot-Server that provides an number of bots for an existing game. You just need to specifiy an environment variable to enable the KI-Server. Additional information of game server and number of KI Karts is neccessary. (If not specified, default values are: KI_COUNT=3 and SERVER_ADDRESS=127.0.0.1:2759)

```
$ docker run --name my-stk-server \
             -d \
             -p 2757:2757 \
             -p 2759:2759 \
             -e IS_KI_SERVER="true" \
             -e KI_COUNT=3 \
             -e SERVER_ADDRESS="127.0.0.1:2759"
             -e SERVER_PASSWORD=mypassword \
             dobernoeder/supertuxkart:1.1.3
```


### Known Issues
- Server crashes after the race when bots are connected. You need to restart the container for a new race and KI-Server needs to get restarted, too.
- When connecting with SuperTuxKart Client in Version 1.2, you may have trouble to connect when using a server password. There won't be a dialog to enter password when using "Serveradresse eingeben". This bug has been solved in March 2021 (https://github.com/supertuxkart/stk-code/issues/4507)


### Using docker-compose

Clone this repository and have a look into the `docker-compose.yml` to edit your credentials (username & password). If you want to run a public server without needing a password, you can remove the `environment` section with its corresponding entries.
After editing, you can get the server up and running by doing a `docker-compose up -d`. Have a look at the logs by using `docker-compose logs` This can be especially useful when searching for bugs.
