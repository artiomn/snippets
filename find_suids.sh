#!/bin/sh

# Find all suids.
find "/" -perm -6000 -type f -exec ls -ld {} \; > setuid.txt &
