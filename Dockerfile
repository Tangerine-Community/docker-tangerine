# VERSION 0.1
# DOCKER-VERSION 0.3.4
# To build:
# 1. Install docker (http://docker.io)
# 2. Checkout source: git@github.com:Tangerine-Community/docker-tangerine.git
# 3. Build container: docker build .

FROM    ubuntu:14.04
MAINTAINER Adam Preston "apreston@rti.org"


# Install CouchDB
RUN apt-get update && apt-get install -y couchdb curl apt-transport-https vim


# Configure CouchDB
RUN mkdir -p /var/run/couchdb/
ADD config/cors.ini /etc/couchdb/local.d/
ADD config/admins.ini /etc/couchdb/local/
ADD config/jsonp.ini /etc/couchdb/local.d/
RUN chown couchdb:couchdb /etc/couchdb/local.d/*


# Install Ruby
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash -l -c rvm requirements
#RUN /bin/bash --login
RUN rvm all do gem install bundler
RUN rvm install 2.1.5 --default


# Install Nginx.
#RUN \
 # apt-get update && \
  #apt-get install -y nginx-extras && \
  #rm -rf /var/lib/apt/lists/* && \
  #echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  #chown -R www-data:www-data /var/lib/nginx


#Install NGinx & åPassenger
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' >> /etc/apt/sources.list.d/passenger.list
RUN apt-get update
RUN apt-get install -y nginx-extras && \
  	rm -rf /var/lib/apt/lists/* && \
  	echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  	chown -R www-data:www-data /var/lib/nginx
RUN apt-get install -y passenger

# Configure NGinX
ADD config/tangerine /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/tangerine /etc/nginx/sites-enabled 
RUN rm /etc/nginx/sites-enabled/default

# Configure Passenger
RUN sed  --in-place s/'# passenger_root'/'passenger_root'/g /etc/nginx/nginx.conf
RUN sed  --in-place s/'# passenger_ruby'/'passenger_ruby'/g /etc/nginx/nginx.conf

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80

