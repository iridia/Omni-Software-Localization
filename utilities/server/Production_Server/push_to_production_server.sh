#!/bin/bash

## About This Script
##
## Functionality:
## This script updates the git repository in the WebServer
## directory on the Production Server.
## It also creates log files and tweets from @projectosl.
##
## Inputs:
## This script accepts the password for @projectosl as the first parameter
## but will prompt for the password if it is not passed as a parameter.
## 
## Environment:
## This script was designed specifically to be run on the Test Server
## environment (pushing from Test to Production) and is probably
## not compatible with your local development environment.


#
# Set up variables
#

STARTING_DIR=$PWD

GIT_REPO="/Library/WebServer/Omni-Software-Localization"
SRC_DIR="$GIT_REPO/src"

SCRIPTS_DIR="$GIT_REPO/utilities/server"
MY_DIR="$SCRIPTS_DIR/Production_Server"

LOGS_DIR="$GIT_REPO/utilities/Logs"
# MY_LOG_DIR="$LOGS_DIR/Test_Server_Updates" # Later, I want to log ALL output from script to a file
LOG_FILE="$LOGS_DIR/production_pushes.log"

DEST_DIR="/Users/projectosl/Documents/Project_OSL"

CONFIG_FILES_DIR="$MY_DIR/Configuration_Files"
CONFIG_SCRIPT="$CONFIG_FILES_DIR/configure_production_server.sh"
SERVER_PATH_TO_CONFIG_SCRIPT="$DEST_DIR/Configuration_Files/configure_production_server.sh"

SERVER_USER="projectosl"
SERVER_NAME="shellder.omnigroup.com"

TWEETOSL_EXEC="$SCRIPTS_DIR/tweet_from_projectosl.sh"
TWEETOSL_USER="projectosl"
TWEETOSL_TEXT="Latest Release Cycle pushed to $SERVER_NAME"
TWEETOSL_FILE="$LOGS_DIR/last_twitter_response.txt"

PASSWD_PRMPT="Enter the password for $SERVER_USER@$SERVER_NAME."

SCRIPT_PROMPT="`basename $0`>>"
PROMPT="echo $SCRIPT_PROMPT"

#
# Perform script duties
#

echo
$PROMPT Sending files from `hostname` to $SERVER_NAME:$DEST_DIR.
echo

$PROMPT Sending $SRC_DIR...
$PROMPT $PASSWD_PRMPT 
scp -r $SRC_DIR $SERVER_USER@$SERVER_NAME:$DEST_DIR
echo

$PROMPT Sending $CONFIG_FILES_DIR...
$PROMPT $PASSWD_PRMPT
scp -r $CONFIG_FILES_DIR $SERVER_USER@$SERVER_NAME:$DEST_DIR
echo


$PROMPT Running setup script on $SERVER_NAME...
$PROMPT $PASSWD_PRMPT
ssh $SERVER_USER@$SERVER_NAME "$SERVER_PATH_TO_CONFIG_SCRIPT"
echo


$PROMPT Tweeting...
if [ $1 ]
then
	TWEETOSL_PW="$1"
else
	read -s -p "$SCRIPT_PROMPT Enter the password for @$TWEETOSL_USER:" TWEETOSL_PW
	echo
fi
$TWEETOSL_EXEC "$TWEETOSL_PW" "$TWEETOSL_TEXT" > $TWEETOSL_FILE
$PROMPT The response from Twitter has been logged in $TWEETOSL_FILE.
echo


echo `date` >> $LOG_FILE
$PROMPT The date has been logged in $LOG_FILE.
echo


$PROMPT Script complete.


exit 0
