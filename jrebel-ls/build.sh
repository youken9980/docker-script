#!/bin/bash

jrebelSrc="jrebel-ls-src"
mavenRepository="~/maven-repository"
mavenSettings="/usr/share/maven/conf/settings.xml"

jrebelHome="$(pwd)/${jrebelSrc}"
mavenRepository="$(eval readlink -f ${mavenRepository})"

# 已存在同名子目录或文件，则删除
if [ -e "${jrebelHome}" ]; then
    rm -rf "${jrebelHome}"
fi

# 克隆项目，并使用Maven打包
git clone --depth=1 https://gitee.com/gsls200808/JrebelLicenseServerforJava.git "${jrebelHome}"
docker run -it --rm \
    -v ${mavenRepository}:/root/.m2 \
    -v ${jrebelHome}:/${jrebelSrc} \
    -w /${jrebelSrc} \
    maven:3-openjdk-8-slim bash -c \
    "sed -i '/    <!-- mirror/i\    <mirror>' ${mavenSettings} &&
    sed -i '/    <!-- mirror/i\        <id>aliyunmaven</id>' ${mavenSettings} &&
    sed -i '/    <!-- mirror/i\        <mirrorOf>*</mirrorOf>' ${mavenSettings} &&
    sed -i '/    <!-- mirror/i\        <name>阿里云公共仓库</name>' ${mavenSettings} &&
    sed -i '/    <!-- mirror/i\        <url>https://maven.aliyun.com/repository/public</url>' ${mavenSettings} &&
    sed -i '/    <!-- mirror/i\    </mirror>' ${mavenSettings} &&
    mvn clean package -Dmaven.test.skip=true"

# 移动jar包到当前目录，删除项目
mv "${jrebelHome}/target/JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT.jar" ./.
if [ -e "${jrebelHome}" ]; then
    rm -rf "${jrebelHome}"
fi

# 构建镜像，删除jar包
docker build -t youken9980/jrebel-ls:latest .
rm JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT.jar
