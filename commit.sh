#!/bin/sh

cd ${AUTOGIT_DIR:-.}

git commit -am "commit $(date "+%Y-%m-%d %H:%M:%S")"
