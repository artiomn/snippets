#!/bin/bash

# Filenames recoder from utf->koi8r incorrect-encoded (like: "п▒п╣п╥п╬я┌п╨п╟я┌п╫я▀п╣\ п╬я─я┐п╢п╦я▐/").
# Depends: recode.

if [ -z "$1" ]; then
	echo "Syntax: $0 <directory>"
	exit 1
fi

FILE_MASK=${2:-[^0-9A-Za-zА-Яа-я]*}
find "$1" -iname "$FILE_MASK" -print | while IFS=  read i; do
	if [ -e "$i" ]; then
		new_name="$(echo "$i"|recode koi8r)"
		echo "$i -> $new_name"
		mv "$i" "$new_name"
	fi
done

