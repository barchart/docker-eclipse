@echo off

IF "%ip%"=="" goto ERR

goto RUN

:ERR
echo Please set "ip" enviorment variable to your local IP address
exit /B

:RUN
echo Local IP for X11 display: %ip%
docker run -ti --rm -e DISPLAY=%ip%:0 ^
    -v /tmp/.X11-unix:/tmp/.X11-unix ^
    -v %HOME%/.eclipse-docker:/home/developer ^
    -v %HOME%/git:/home/developer/git ^
    -v %HOME%/.ssh:/home/developer/.ssh ^
    -v %HOME%/.m2:/home/developer/.m2 ^
    barchart/eclipse:v4.2.2
