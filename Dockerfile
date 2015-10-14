# nginx load balancer
FROM ubuntu:14.04
MAINTAINER HITS "riad.shalaby@hannecke-its.de"
WORKDIR /etc/nginx
ADD . /root
RUN apt-get -y install libgd3 && \
	apt-get -y install libgeoip1 && \
	apt-get -y install libxml2 && \
	apt-get -y install libxslt1.1 && \
	apt-get -y install python 
RUN dpkg -i /root/nginx-common_1.8.0-1+trusty1_all.deb && \
	dpkg -i /root/nginx-full_1.8.0-1+trusty1_amd64.deb 
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
EXPOSE 80 443
# starts nginx as non daemon so docker wont close the container right away
CMD ["nginx", "-g", "daemon off;"]