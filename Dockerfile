FROM ubuntu:14.04
MAINTAINER Fabio Rehm "mike@barchart.com"

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /usr/local/bin

# Install libgtk as a separate step so that we can share the layer above with
# the netbeans image
RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module

RUN apt-get install -y zip unzip

# Eclipse 4.2 - last version to support "CarrotGarden OSGi plugins"
RUN wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/juno/SR2/eclipse-java-juno-SR2-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing eclipse' && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

ADD run /usr/local/bin/eclipse

# fetch and extract Eclipse plugins
RUN mkdir -p /home/developer/.eclipse/org.eclipse.platform_4.2.0_1473617060 && \
   wget http://barchart-jwrapper-jvm.s3.amazonaws.com/plugins.zip -O plugins.zip && \
   unzip plugins.zip -d /home/developer/.eclipse/org.eclipse.platform_4.2.0_1473617060

RUN chmod +x /usr/local/bin/eclipse && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

RUN chmod -R 777 /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/local/bin/eclipse
