#!/bin/bash -e

# jdk
# /usr/lib/jvm/java-8-openjdk-amd64/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PWD/bin:$PATH

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
ROOT=$DIR/../..
TOOLS=$ROOT/tools

cd $DIR
source build_env.sh
export LC_ALL=C
# install build tools
#if [[ ! -z "${INSTALL_DEPS}" ]]; then
source $DIR/install_deps.sh
#fi

if [[ -z "${LIMIT_CORES}" ]]; then
  JOBS=$(nproc --all)
else
  JOBS=8
fi

# build mindroid
mkdir -p $DIR/mindroid/system
cd $DIR/mindroid/system

# By default, check out the "repeatable-build-mindroid" manifest with locked
# hashes for each Comma-forked component. If doing active development, check
# out "mindroid" instead, update the repeatable-build-mindroid manifest hashes
# when finished, and update the commit hash here.
$TOOLS/repo init -u https://github.com/commaai/android.git -b "repeatable-build-mindroid"
$TOOLS/repo sync -c -j$JOBS


(source build/envsetup.sh && breakfast oneplus3 && make -j$JOBS)
