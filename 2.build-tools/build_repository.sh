#!/bin/bash

pattern_list="
*.lastUpdated
\$\{*
"
for item in ${pattern_list}; do
    find ~/Destiny/Share/maven-repository -name "${item}" -type f -print -exec rm {} \;
done
docker build -f Dockerfile_repository -t youken9980/build-tools-temurin8:repository ~/Destiny/Share
