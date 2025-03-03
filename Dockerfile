FROM jenkins/inbound-agent 

# run updates as root
USER root

# Create docker group
#RUN addgroup docker

# Update & Upgrade OS
RUN apt-get update
#RUN apt-get -y upgrade
RUN apt-get -y install maven \
&& unlink /usr/bin/mvn \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV JAVA_HOME /opt/java/openjdk
# close root access
USER jenkins
