## Latest Version : 3.0

## Release History
#### 2018/11/11 : 1.0
#### 2019/01/10 : 3.0 : Upgrade Nodejs from 10.12.0 to 10.15.0
#### 2020/12/24 : CWTB :
###### 1) Upgrade Nodejs from 10.15.0 to 14.15.1
###### 2) Upgrade golang from 1.11.2 to 1.15.6
###### 3) Add angualr cli --> npm install -g @angular/cli@v10-lts

### Dockerfile
FROM centos:7

## Add REPO for Google Chrome
RUN echo "[google64]" >> /etc/yum.repos.d/google.repo \
	&& echo "name=Google-x86_64" >> /etc/yum.repos.d/google.repo \
	&& echo "baseurl=http://dl.google.com/linux/rpm/stable/x86_64" >> /etc/yum.repos.d/google.repo \
	&& echo "enabled=1" >> /etc/yum.repos.d/google.repo \
	&& echo "gpgcheck=1" >> /etc/yum.repos.d/google.repo \
	&& echo "gpgkey=https://dl.google.com/linux/linux_signing_key.pub" >> /etc/yum.repos.d/google.repo

## Install Node 10 Install ENV
RUN curl --silent --location https://rpm.nodesource.com/setup_14.x | bash -

# Install Build Package from yum
RUN yum install -y which \
	wget \
	tar \
	make \
	gcc \
	gcc-c++ \
	bzip2-devel  \
        git \
	google-chrome-stable \
	nodejs-14.15.1

WORKDIR /home

## Install Golang
RUN wget https://dl.google.com/go/go1.15.6.linux-amd64.tar.gz
RUN tar -zxvf go1.15.6.linux-amd64.tar.gz \
	&& rm -rf go1.15.6.linux-amd64.tar.gz \
	&& mkdir -p path/bin path/src path/pkg
RUN npm install -g @angular/cli@v10-lts

ENV GOROOT="/home/go"
ENV GOPATH="/home/path"
ENV GOBIN="${GOPATH}/bin"
ENV GOPKG="${GOPATH}/pkg"
ENV PATH="${PATH}:${GOBIN}:${GOROOT}/bin"

CMD ["/bin/bash"]
