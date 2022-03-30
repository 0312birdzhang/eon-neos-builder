#!/usr/bin/env bash
set -e
# jdk
# /usr/lib/jvm/java-8-openjdk-amd64/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

LIMIT_CORES=1 ./build_android.sh
./build_kernel_leeco.sh
./build_kernel_oneplus.sh
./make_boot.sh leeco
./make_boot.sh oneplus
./make_recovery.sh leeco
./make_recovery.sh oneplus
./make_system.sh
