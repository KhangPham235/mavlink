#!/usr/bin/env bash

# c_library repository update script
# Author: Thomas Gubler <thomasgubler@gmail.com>
#
# This script can be used together with a github webhook to automatically
# generate new c header files and push to the c_library repository whenever
# the message specifications are updated.
# The script assumes that the git repositories in MAVLINK_GIT_PATH and
# CLIBRARY_GIT_PATH are set up prior to invoking the script.

function generate_headers() {
python pymavlink/tools/mavgen.py \
    --output $CLIBRARY_PATH \
    --lang C \
    --wire-protocol $2.0 \
    message_definitions/v1.0/$1.xml
}

# settings
MAVLINK_PATH=$PWD
CLIBRARY_PATH=$MAVLINK_PATH/include/mavlink/v$1.0/c_library_v$1
LIB_MAVLINK_PROJECT_PATH=$MAVLINK_PATH/../../libraries/KR_Mavlink

# delete old c headers
rm -rf $CLIBRARY_PATH/*

# generate new c headers
generate_headers protocol $1

# delete old c headers 
rm -rf $LIB_MAVLINK_PROJECT_PATH/*

cp -rf $CLIBRARY_PATH/* $LIB_MAVLINK_PROJECT_PATH/