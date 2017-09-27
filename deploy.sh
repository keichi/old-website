#!/bin/bash

stack build
stack exec site build
aws s3 sync _site/ s3://keichi.net --delete --exclude ".DS_Store" --cache-control "max-age=86400"
