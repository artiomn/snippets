#!/bin/bash

# doc: https://docs.gitlab.com/ee/topics/git/lfs/migrate_to_git_lfs.html
# 1. Need to enable LFS in the repository settings.
# 2. Need to unprotect default branch before push.

REPO="$1"

[ -z "$REPO" ] && { echo "$(basename "$0") <git url>"; exit 1; }

BARE_REPO_DIR="$(basename ${REPO})"
REPO_DIR="$(basename ${BARE_REPO_DIR%%.git})"
CLEAN_EXTS=(mp4 flv wav mp3 gif jpeg jpg png bmp iso 7z xz tar zip x32 rar tgz tbz tjz ttf psd odp pdf pcap pptx docx xlsx ppt doc xls db sqlite dat MP4 FLV WAV MP3 GIF JPEG JPG PNG BMP ISO 7Z XZ TAR ZIP X32 RAR TGZ TBZ TJZ TTF PSD ODP PDF PCAP PPTX DOCX XLSX PPT DOC XLS DB SQLITE DAT)

git clone --mirror "${REPO}" "${BARE_REPO_DIR}" && \
bfg --convert-to-git-lfs "*.{$(printf "%s," ${CLEAN_EXTS[@]})}" --no-blob-protection "${BARE_REPO_DIR}" && \
cd "${BARE_REPO_DIR}" && \
git reflog expire --expire=now --all && git gc --prune=now --aggressive && \
git lfs install && \
git push --force && \
cd - && \
git clone "${REPO}" "${REPO_DIR}" && \
cd "${REPO_DIR}" && \
git reset --hard origin/master && \
git lfs track $(printf "*.%s " ${EXTS_ARRAY[@]})

