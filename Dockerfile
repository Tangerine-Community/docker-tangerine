# VERSION 0.1
# DOCKER-VERSION 0.3.4
# To build:
# 1. Install docker (http://docker.io)
# 2. Checkout source: git@github.com:Tangerine-Community/docker-tangerine.git
# 3. Build container: docker build .

FROM    ubuntu:14.04
MAINTAINER Adam Preston "apreston@rti.org"


# Install CouchDB
RUN apt-get update && apt-get install -y couchdb curl


# Configure CouchDB
ADD config/cors.ini /etc/couchdb/local.d/
ADD config/admins.ini /etc/couchdb/local/
ADD config/jsonp.ini /etc/couchdb/local.d/
RUN chown couchdb:couchdb /etc/couchdb/local.d/*


# Install Ruby
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash -l -c rvm requirements
RUN /bin/bash --login
RUN rvm all do gem install bundler
RUN rvm install 2.1.5 --default


# Install Passenger & NGinX
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN apt-get install apt-transport-https ca-certificates
RUN echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' >> /etc/apt/sources.list.d/passenger.list
RUN apt-get update && apt-get install -y nginx-extras passenger


# Configure Passenger
RUN sed  --in-place s/'# passenger_root'/'passenger_root'/g /etc/nginx/nginx.conf
RUN sed  --in-place s/'# passenger_ruby'/'passenger_ruby'/g /etc/nginx/nginx.conf


# Configure NGinX
ADD config/tangerine /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/tangerine /etc/nginx/sites-enabled 
RUN rm /etc/nginx/sites-enabled/default
RUN service nginx restart

EXPOSE  80


