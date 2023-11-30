FROM jsmigel/centos-epel
RUN yum -y install wget
RUN yum install -y nodejs npm  --enablerepo=epel
ADD . /srv/hello
WORKDIR /srv/hello
RUN npm install
EXPOSE 3001
CMD ["node","/srv/hello/index"]
