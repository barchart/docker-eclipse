@echo off

echo Local IP for X11 display: %ip%

docker run -ti --rm -e DISPLAY=%ip%:0 ^
    -v /tmp/.X11-unix:/tmp/.X11-unix ^
    -v %HOME%/.eclipse-docker:/home/developer ^
    -v %HOME%/git:/home/developer/git ^
    -v %HOME%/.ssh:/home/developer/.ssh ^
    mvberg/eclipse:v4.2.2