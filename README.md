# docker-eclipse

Eclipse v4.2.2 with Java 7 and "carrot garden" OSGi plugins in a Docker container

# Requirements

* Docker 1.2+ (should work fine on 1.0+ but I haven't tried)
* An X11 socket
* Maven settings.xml located at ~/.m2/settings.xml

# Quickstart

## Windows

* Install Xming for X11 (https://sourceforge.net/projects/xming/)
* Launch by double clicking [config.xlaunch](config.xlaunch) or [see here for manual XLaunch setup](https://github.com/moby/moby/issues/8710#issuecomment-135109677)

### Set local ip address and run batch

```sh
SET ip=your_local_ip
docker-windows.bat
```

### Using docker-machine on Windows

Open "Docker Quickstart Terminal"

```sh
DISPLAY=your_local_ip:0 #IP and display number of Xming server
./eclipse-linux
```

## OSX

* Install XQuartz (https://www.xquartz.org/)
* Use socat to forward X11

```sh
brew install socat
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

in a second terminal

```sh
./eclipse-osx
```

What's actually happening:

```sh
mkdir -p .eclipse-docker # location for persistent storage
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
docker run -ti --rm \
           -e DISPLAY=$ip:0 \ # eg 10.222.4.184:0
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ~/.eclipse-docker/workspace:/home/developer/workspace \ # eclipse workspaces
           -v ~/git:/home/developer/git \ # git repos
           -v ~/.m2:/home/developer/.m2 \ # maven repo and user settings
           mvberg/eclipse:v4.2.2
```

## Linux

Tested on Ubuntu Desktop 16.04 and Fedora Workstation 25

```sh
./eclipse-linux
```

# Java 2d and performance

You must run with `-Dsun.java2d.pmoffscreen=false` to get usable UI performance when launching AWT/Java2d apps from Eclipse.

## Help! I started the container but I don't see the Eclipse screen

`xhost +` allow connections from all hosts

https://github.com/fgrehm/docker-eclipse/issues/5

## Notes

* Forked from: https://github.com/fgrehm/docker-eclipse
* More X11 and Docker from: https://blog.jessfraz.com/post/docker-containers-on-the-desktop/
