FROM ubuntu:13.10

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy main' | tee /etc/apt/sources.list
RUN echo 'deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy main' | tee -a /etc/apt/sources.list
RUN echo 'deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy-updates main' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy-updates main' | tee -a /etc/apt/sources.list
RUN echo 'deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy universe' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy universe' | tee -a /etc/apt/sources.list
RUN echo 'deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy-updates universe' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy-updates universe' | tee -a /etc/apt/sources.list
RUN echo 'deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy multiverse' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy multiverse' | tee -a /etc/apt/sources.list
RUN echo 'deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy-updates multiverse' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy-updates multiverse' | tee -a /etc/apt/sources.list
RUN echo 'deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy-backports main restricted universe multiverse' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ saucy-backports main restricted universe multiverse' | tee -a /etc/apt/sources.list
RUN echo 'deb http://security.ubuntu.com/ubuntu saucy-security main' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://security.ubuntu.com/ubuntu saucy-security main' | tee -a /etc/apt/sources.list
RUN echo 'deb http://security.ubuntu.com/ubuntu saucy-security universe' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://security.ubuntu.com/ubuntu saucy-security universe' | tee -a /etc/apt/sources.list
RUN echo 'deb http://security.ubuntu.com/ubuntu saucy-security multiverse' | tee -a /etc/apt/sources.list
RUN echo 'deb-src http://security.ubuntu.com/ubuntu saucy-security multiverse' | tee -a /etc/apt/sources.list

RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

RUN apt-get update

RUN apt-get -y -q autoclean
RUN apt-get -y -q autoremove
RUN apt-get clean

ADD ./domains /domains
ADD ./aliases /aliases
ADD ./passwords /passwords
