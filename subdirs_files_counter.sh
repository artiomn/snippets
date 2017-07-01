#!/bin/bash

# Files count in subdirectories of current directory.

# One-liner: while read -r i ; do [ $i == '.' ] && continue ; echo "$i: $(find "$i" -type f | wc -l)" ; done  <<< $(find -maxdepth 1 -type d)|sort -t: -k +2n

# Reader-friendly.
find -maxdepth 1 -type d|sort -t: -k +2n | while IFS= read -r i ; do
   [ "$i" == "." ] && continue
   echo "$i: $(find "$i" -type f | wc -l)"
done

