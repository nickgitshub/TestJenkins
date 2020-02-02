FROM centos:latest
MAINTAINER nickgitshub

RUN yum -y install HTTPD

#Going to need to add some code here
RUN git clone https://github.com/nickgitshub/TestJenkins && cd TestJenkins
COPY index.html /var/www/html

CMD["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80