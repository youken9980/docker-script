#!/bin/bash

docker pull alpine:3

docker pull centos:7
docker pull centos:8

docker pull debian:bullseye
docker pull debian:bullseye-slim
docker pull debian:bookworm
docker pull debian:bookworm-slim

docker pull ubuntu:jammy

docker pull eclipse-temurin:8-jdk-alpine
docker pull eclipse-temurin:8-jre-alpine
docker pull eclipse-temurin:8-jdk-centos7
docker pull eclipse-temurin:8-jre-centos7
docker pull eclipse-temurin:8-jdk-jammy
docker pull eclipse-temurin:8-jre-jammy
docker pull eclipse-temurin:17-jre-jammy

docker pull golang:1.12-alpine

docker pull jenkins/jenkins:lts-alpine
docker pull jenkins/inbound-agent:alpine

docker pull mysql:5.7-debian

docker pull nginx:1.24-alpine-slim

docker pull tomcat:9-jdk8-temurin-jammy
docker pull tomcat:9-jre8-temurin-jammy
