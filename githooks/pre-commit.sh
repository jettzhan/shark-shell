#!/bin/bash
# author: noodzhan@163.com
set -e

RELEASE=1.8
JAR_NAME="google-java-format-${RELEASE}-all-deps.jar"
# RELEASES_URL=https://repo1.maven.org/maven2/com/google/googlejavaformat/google-java-format
RELEASES_URL=https://maven.aliyun.com/nexus/content/groups/public/com/google/googlejavaformat/google-java-format
JAR_URL="${RELEASES_URL}/${RELEASE}/${JAR_NAME}"

CACHE_DIR="$HOME/.cache/google-java-format-git-pre-commit-hook"
JAR_FILE="$CACHE_DIR/$JAR_NAME"
JAR_DOWNLOAD_FILE="${JAR_FILE}.tmp"
java11=D:/software/jdk/11/jdk-11.0.17_windows-x64_bin/jdk-11.0.17/bin/java

if [[ ! -f "$JAR_FILE" ]]; then
    mkdir -p "$CACHE_DIR"
    curl -L "$JAR_URL" -o "$JAR_DOWNLOAD_FILE"
    mv "$JAR_DOWNLOAD_FILE" "$JAR_FILE"
fi

changed_java_files=$(git diff --cached --name-only --diff-filter=ACMR | grep ".*java$" || true)
if [[ -n "$changed_java_files" ]]; then
    echo "Reformatting Java files: $changed_java_files"
    if ! $java11 \
        -jar "$JAR_FILE" --replace --set-exit-if-changed $changed_java_files; then
        echo "An error occurred, aborting commit!" >&2
        echo "please commit again ,because code had been format."
        exit 1
    fi
else
    echo "No Java files changes found."
fi
