#!/bin/sh

# Create image thumbnails.
for i in *; do convert -resize 100 "$i" $(echo "$i"|cut -f1 -d'.')s.png; done
# for i in *; do nm="$(echo "$i"|cut -f1 -d'.')"; ext=$(echo "$i"|cut -f2 -d'.'); convert -resize 100 "$i" ${nm}s.${ext}; done
