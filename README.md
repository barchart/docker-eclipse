# docker-eclipse

Eclipse v4.2.2 in a Docker container

## Requirements

* Docker 1.2+ (should work fine on 1.0+ but I haven't tried)
* An X11 socket

## Quickstart

Assuming `$HOME/bin` is on your `PATH` and that you are able to run `docker`
commands [without `sudo`](http://docs.docker.io/installation/ubuntulinux/#giving-non-root-access),
you can use the [provided `eclipse` script](eclipse) to start a disposable
Eclipse Docker container with your project sources mounted at `/home/developer/workspace`
within the container:

```sh
# The image size is currently 1.131 GB, so go grab a coffee while Docker downloads it
docker pull mvberg/eclipse:v4.2.2
L=$HOME/bin/eclipse && curl -sL https://github.com/mvberg/docker-eclipse/raw/master/eclipse > $L && chmod +x $L
cd /path/to/java/project
eclipse
```

Once you close Eclipse the container will be removed and no traces of it will be
kept on your machine (apart from the Docker image of course).

## Making plugins persist between sessions

Eclipse plugins are kept on `$HOME/.eclipse` inside the container, so if you
want to keep them around after you close it, you'll need to share it with your
host.

## Windows

Install xming for X11
configure xming: https://github.com/moby/moby/issues/8710#issuecomment-135109677

### Set local ip address and run batch

```sh
SET ip=your_local_ip
docker-windows.bat
```

## OSX

install XQuartz (https://www.xquartz.org/)
use socat to forward X11

```sh
brew install socat
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

```sh
./eclipse-osx
```

Example:

```sh
mkdir -p .eclipse-docker # location for persistent storage
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
docker run -ti --rm \
           -e DISPLAY=$ip:0 \ # use IP if this fails, eg 10.222.4.184:0
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ~/.eclipse-docker/workspace:/home/developer/workspace \ # eclipse workspaces
           -v ~/git:/home/developer/git \ # git repos
           -v ~/.m2:/home/developer/.m2 \ # maven repo and user settings
           mvberg/eclipse:v4.2.2
```

## Linux

Tested on Ubuntu Desktop 16.04



## Help! I started the container but I don't see the Eclipse screen

https://github.com/fgrehm/docker-eclipse/issues/5
