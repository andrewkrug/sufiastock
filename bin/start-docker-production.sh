#!/bin/bash

#Spin up the maria database
docker run -d --name hydraproductiondb andrewkrug/mariadb

#Spin up fedora4
docker run -d -p 8080:8080 --name hydraproductionfedora andrewkrug/fedora4

#Spin up solr-latest
docker run -d --name hydraproductionsolr andrewkrug/solr

#Spin up redis server
docker run -d --name hydraproductionredis joelferrier/redis

#Spin up osfsufia
docker run -d -p 80:80 -P --name osfsufiaproduction \
    --link hydraproductiondb:hydraproductiondb \
    --link hydraproductionfedora:hydraproductionfedora \
    --link hydraproductionsolr:hydraproductionsolr \
    --link hydraproductionredis:hydraproductionredis \
    andrewkrug/sufia
