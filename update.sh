#!/bin/sh

git submodule init
git submodule update

cd ./libs/

for libs in `ls`
do cd $libs;
    if [ -e .git ]; then
        git checkout master; git pull; 
    fi;
    cd -
done

