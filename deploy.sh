#!/bin/bash

stack build
stack exec site rebuild
aws s3 sync _site/ s3://keichi.net --delete --exclude ".DS_Store"
