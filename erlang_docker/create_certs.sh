#!/bin/sh

set -e

if [ ! -d ssl ]; then
    mkdir ssl
fi

# Create the root CA (Certificate Authority)
openssl genrsa -out ssl/foa-ca.key 4096

## Certificate signing request for root CA
openssl req -x509 -new -nodes -key ssl/foa-ca.key -sha256 -days 1024 -subj "/C=SE/" -out ssl/foa-ca.pem

# Create the server certificate
openssl genrsa -out ssl/foa-server.key 4096

## Certificate signing request for server certificate
openssl req -new -key ssl/foa-server.key -subj "/C=SE/CN=localhost/" -out ssl/foa-server.csr

## Sign the server certificate using the root CA
openssl x509 -req -in ssl/foa-server.csr -CA ssl/foa-ca.pem -CAkey ssl/foa-ca.key -CAcreateserial -out ssl/foa-server.pem -days 500 -sha256
