#!/bin/bash

docker pull mysql:5-debian
docker build -f Dockerfile -t youken9980/mysql:5-debian .
