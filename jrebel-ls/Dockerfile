FROM openjdk:8-jre-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV PORT 8080

ADD *.jar /service.jar
CMD java -jar /service.jar -p $PORT
