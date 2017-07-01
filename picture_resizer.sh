#!/bin/sh

# ==============================================================================
#
# Picturename
#
# Description: Resize pictures
#
#
# @author Artiom N. <artiomsoft@yandex.ru>
# @date Сбт 26 Окт 2013 21:04:00
#
# ==============================================================================

#!/bin/sh
counter=1
root=mypict
resolution=400x300
for i in `ls -1 $1/*.jpg`; do
        echo "Now working on $i"
        convert -resize $resolution $i ${root}_${counter}.jpg
        counter=`expr $counter + 1`
done


# vim:set ft=sh ts=3 sw=3 et

