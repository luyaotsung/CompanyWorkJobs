## Latest Version : 3.0

## Release History
#### 2018/11/11 : 1.0
#### 2019/01/10 : 3.0 : Upgrade Nodejs from 10.12.0 to 10.15.0

---
### Dockerfile
```console
FROM centos:7

## Add REPO for Google Chrome
RUN echo "[google64]" >> /etc/yum.repos.d/google.repo \
	&& echo "name=Google-x86_64" >> /etc/yum.repos.d/google.repo \
	&& echo "baseurl=http://dl.google.com/linux/rpm/stable/x86_64" >> /etc/yum.repos.d/google.repo \
	&& echo "enabled=1" >> /etc/yum.repos.d/google.repo \
	&& echo "gpgcheck=1" >> /etc/yum.repos.d/google.repo \
	&& echo "gpgkey=https://dl.google.com/linux/linux_signing_key.pub" >> /etc/yum.repos.d/google.repo

## Install Node 10 Install ENV
RUN curl --silent --location https://rpm.nodesource.com/setup_10.x | bash -

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
	nodejs-10.15.0

WORKDIR /home

## Install Golang 1.11.2
RUN wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz
RUN tar -zxvf go1.11.2.linux-amd64.tar.gz \
	&& rm -rf go1.11.2.linux-amd64.tar.gz \
	&& mkdir -p path/bin path/src path/pkg

ENV GOROOT="/home/go"
ENV GOPATH="/home/path"
ENV GOBIN="${GOPATH}/bin"
ENV GOPKG="${GOPATH}/pkg"
ENV PATH="${PATH}:${GOBIN}:${GOROOT}/bin"

CMD ["/bin/bash"]
