#!/bin/bash
#############################
# Depends:
# 	 media-sound/shntool
#   app-cdr/cuetools
#   media-libs/flac
#   media-sound/wavpack
#
# Origin: https://www.linux.org.ru/forum/multimedia/8744513?cid=8744536
#
#############################

ERR_SPLIT_MSG="Error: can't split"

while read cuefile
do
  cue="${cuefile##*/}"
  obj=${cue%.cue}
  objdir="${cuefile%/*}"
  pushd "$objdir"

  # < /dev/tty need to ask on overwrite.
  if [ -f "$obj".flac ]; then
    shntool split -i "flac" -o "flac" -f "$cue" -t %n "$obj".flac < /dev/tty \
      || { echo "$ERR_SPLIT_MSG $obj.flac"; exit 1; }
  elif [ -f "$obj".ape ]; then
    shntool split -i "ape" -o "flac" -f "$cue" -t %n "$obj".ape < /dev/tty \
      || { echo "$ERR_SPLIT_MSG $obj.ape"; exit 1; }
  elif [ -f "$obj".tta ]; then
    shntool split -i "tta" -o "flac" -f "$cue" -t %n "$obj".tta < /dev/tty \
      || { echo "$ERR_SPLIT_MSG $obj.tta"; exit 1; }
  elif [ -f "$obj".wv ]; then
    shntool split -i "wv" -o "flac" -f "$cue" -t %n "$obj".wv < /dev/tty\
      || { echo "$ERR_SPLT_MSG $obj.wv"; exit 1; }
  else
    echo "File $obj was not found, exiting..."
    exit 1
  fi

  ln -s "$cue" tmp.cue
  for (( i=1 ; i <= $(cueprint -d '%N' tmp.cue) ; ++i ))
  do
    NN=$(printf '%02d' $i)
    [ -s "$NN.flac" ] && {
      cueprint -n $i -t \
        'ARRANGER=%A\nCOMPOSER=%C\nGENRE=%G\nMESSAGE=%M\nTRACKNUMBER=%n\nARTIST=%p\nTITLE=%t\nALBUM=%T\n' \
        tmp.cue | egrep -v '=$' | metaflac --import-tags-from=- $NN.flac
      mv $NN.flac "$NN - $(cueprint -n $i -t %t tmp.cue | sed -e "s,/,,g").flac"
    }
  done

  echo "SUCCESS!"
  echo "Removing original FLAC..."
  rm -f tmp.cue "$cue" "$obj".{flac,ape,tta} tags.tmp
  popd
done < <(find . -type f -iname "*.cue")

