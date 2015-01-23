# VERSION 0.1
# DOCKER-VERSION 0.3.4
# To build:
# 1. Install docker (http://docker.io)
# 2. Checkout source: git@github.com:ictatrti/docker-tangerine.git
# 3. Build container: docker build .

FROM    ubuntu:14.04

# Install CouchDB
RUN apt-get update && apt-get install -y couchdb curl

# Configure CouchDB
ADD config/cors.ini /etc/couchdb/local.d/
ADD config/admins.ini /etc/couchdb/local/
ADD config/jsonp.ini /etc/couchdb/local.d/
RUN chown couchdb:couchdb /etc/couchdb/local.d/*

# Install Ruby
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN source . ~/.bash_profile
RUN rvm use 2.1.5 --default