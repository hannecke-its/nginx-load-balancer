# NGINX load balancer with sticky sessions and check modul
I used nginx 1.8.0 stable version compiled with:
- sticky module : https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/overview
- check module : https://github.com/yaoweibin/nginx_upstream_check_module

This image is mainly used to test load balancing on a developer machine with 2 servlet engines.
But could be modified to be used in a larger scale.

** At container start without setting anything you get a 'Bad Gateway' error from nginx if the upstreams dont exists ** You can check the status via 'http://container-ip:container-port/status'

## Configure upstreams
Per default the image with balance two upstreams on http://localhost:8080 and http://localhost:8081.
It will use sticky sessions.
You can change those two via enviroment variables:

```
upstream1 'localhost:8080'
upstream2 'localhost:8081'
```
Or you could change the default server config by mapping the volume '/etc/nginx/sites-enabled' and provide your own virtuell server config.

## Configure logging
Access and error logs are mapped to docker by default. If you want those as files locally map the volume '/var/log/nginx'.

## HTTP upstream checks
Nginx will check the upstreams every 2 seconds by doing a head request on '/' if the a upstream fails it will be removed from load balancing. After 3 successfull checks it will be put back.
You can check the status via 'http://container-ip:container-port/status'.

## SSL
Nginx is configured to use Port 443 with a self signed certificate.

## Volumes
- '/etc/nginx/sites-enabled' : place for virtual host configs. nginx will try to load any file here as a config
- '/etc/nginx/certs' : place for providing your own certificates. per default they should be named nginx.crt and nginx.key
- '/etc/nginx/conf.d' : place your own additional configs to add or replace the default settings
- '/var/log/nginx' : nginx will place access.log and error.log here
- '/var/www/html' : default place for static files. The default config will not use it at all since everything will be routed to the upstreams.


Using the supperb tiller for configuration of files: https://github.com/markround/tiller
