#!/bin/bash

git checkout master
stack build
stack exec site rebuild
git checkout publish
cp -a _site/ .
git add -A
git commit -m "Update on `date '+%Y/%m/%d %H:%M:%S'`"
git push dokku publish:master
git checkout master
