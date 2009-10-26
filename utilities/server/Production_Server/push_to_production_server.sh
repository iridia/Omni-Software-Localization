#!/bin/bash

## This script updates the git repository on the Production Server
## and updates the WebServer with those newest files.
## 
## It also creates log files and even tweets from @projectosl.
## 
## This script was designed specifically to be run on the Test Server
## environment (push from Test to Production) and is therefore
## probably not compatible with your local development environment.


# Set up variables

STARTING_DIR=$PWD

GIT_REPO="/Library/WebServer/Documents/Omni-Software-Localization"
SRC_DIR="$GIT_REPO/src"

SCRIPTS_DIR="$GIT_REPO/utilities/server"
MY_DIR="$SCRIPTS_DIR/Production_Server"

LOGS_DIR="$GIT_REPO/utilities/Logs"
# MY_LOG_DIR="$LOGS_DIR/Test_Server_Updates" # Later, I want to log ALL output from script to a file
LOG_FILE="$LOGS_DIR/production_pushes.log"

TWEETOSL_EXEC="$SCRIPTS_DIR/tweet_from_projectosl.sh"
TWEETOSL_USER="projectosl"

CONFIG_FILES_DIR="$MY_DIR/Configuration_Files"
CONFIG_SCRIPT="$CONFIG_FILES_DIR/configure_production_server.sh"

DEST_DIR="/Users/projectosl/Documents/Project_OSL"

SERVER_USER="projectosl"
SERVER_NAME="shellder.omnigroup.com"

PASSWD_PRMPT="Enter the password for $SERVER_USER@$SERVER_NAME."


# Perform script duties

echo
echo Sending files from `hostname` to $SERVER_NAME:$DEST_DIR.
echo

echo Sending $SRC_DIR...
echo $PASSWD_PRMPT 
scp -r $SRC_DIR $SERVER_USER@$SERVER_NAME:$DEST_DIR
echo

echo Sending $CONFIG_FILES_DIR...
echo $PASSWD_PRMPT
scp -r $CONFIG_FILES_DIR $SERVER_USER@$SERVER_NAME:$DEST_DIR
echo


echo Running setup script on $SERVER...
echo PASSWD_PRMPT
ssh $SERVER_USER@$SERVER_NAME "$CONFIG_SCRIPT"
echo

echo Tweeting...
echo -n Enter the password for @$TWEETOSL_USER: 
read -e TWEETOSL_PW
$TWEETOSL_EXEC "Latest Releace Cycle pushed to $SERVER_NAME" "$TWEETOSL_PW"
echo


echo `date` >> $LOG_FILE
echo The date has been logged in $LOG_FILE.
echo


echo Script complete.


exit 0
