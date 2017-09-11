# Docker file for CentOS with RVM
FROM centos:centos7

MAINTAINER Scott Coulton "https://github.com/scotty-c/docker-rvm"

RUN useradd -ms /bin/bash dev_user
RUN echo "dev_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR "/home/dev_user"

RUN yum -y install curl which tar sudo wget freetype fontconfig git vim epel-release mysql-devel

USER dev_user

## Install RVM + ruby 2.1.2
RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable

ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install ruby-2.1.2"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Copy tyrion
USER dev_user

WORKDIR /tmp

ADD Gemfile Gemfile
RUN /bin/bash -l -c "bundle"

WORKDIR "/home/dev_user"

RUN mkdir -p tyrion/current/ && mkdir -p tyrion/shared/config/ && mkdir -p tyrion/shared/logs/
COPY . /home/dev_user/tyrion/current/
RUN rm /home/dev_user/tyrion/current/Dockerfile

USER root
RUN chown -R dev_user.dev_user tyrion/
RUN rm -rf /home/dev_user/tyrion/current/logs/

USER dev_user

WORKDIR /home/dev_user/tyrion/current/
RUN chmod +x ./bin/runner

EXPOSE 9092
