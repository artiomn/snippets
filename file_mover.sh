#!/bin/bash

# Move files with specific extension, saving full paths.

TARGET_DIR="$1"
PATTERN="${2:-"*.mp4"}"

[ -z "$TARGET_DIR" ] && {
    echo "$(basename $0) <target_dir> [file_pattern]";
    exit 1;
}

find -type f -iname "$PATTERN" | while IFS= read i; do
    new_dir="$TARGET_DIR/`echo "${i#./}"|xargs -0 dirname`"
    if [ ! -e "$new_dir" ]; then
        mkdir -p "$new_dir" || {
            echo "Error: can't create directory $new_dir!"
            exit 1;
        }
    fi
    echo "\"$i\" -> \"$new_dir/`basename "$i"`\"";
    mv "$i" "$new_dir/`basename "$i"`";
done

