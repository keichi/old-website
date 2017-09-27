#!/bin/bash

stack build
aws s3 sync _site/ s3://keichi.net --delete --exclude ".DS_Store"
stack exec site build
