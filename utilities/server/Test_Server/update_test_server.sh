#!/bin/bash

## About This Script
##
## Functionality:
## This script updates the git repository in the WebServer
## directory on the Test Server.
## It also creates log files and tweets from @projectosl.
##
## Inputs:
## This script accepts the password for @projectosl as the first parameter
## but will prompt for the password if it is not passed as a parameter.
## 
## Environment:
## This script was designed specifically to be run on the Test Server
## environment and is probably not compatible with your local
## development environment.


# Set up variables

STARTING_DIR=$PWD

GIT_REPO="/Library/WebServer/Omni-Software-Localization"
GIT_EXEC="/usr/local/git/bin/git"

SCRIPTS_DIR="$GIT_REPO/utilities/server"
MY_DIR="$SCRIPTS_DIR/Test_Server"

LOGS_DIR="$GIT_REPO/utilities/Logs"
# MY_LOG_DIR="$LOGS_DIR/Test_Server_Updates" # Later, I want to log ALL output from script to a file
LOG_FILE="$LOGS_DIR/klondike_github_updates.log"

TWEETOSL_USER="projectosl"
TWEETOSL_EXEC="$SCRIPTS_DIR/tweet_from_projectosl.sh"
TWEETOSL_TEXT="Updated Klondike to latest git repo"

SCRIPT_PROMPT="`basename $0`>>"

# Perform script duties

echo $SCRIPT_PROMPT Updating git repository in $GIT_REPO...
cd $GIT_REPO
$GIT_EXEC pull
cd $STARTING_DIR
echo


echo $SCRIPT_PROMPT Tweeting...
if [ $1 ]
then
	TWEETOSL_PW="$1"
else
	echo -n $SCRIPT_PROMPT Enter the password for @$TWEETOSL_USER: 
	read -e TWEETOSL_PW
fi
$TWEETOSL_EXEC "$TWEETOSL_PW" "$TWEETOSL_TEXT"
echo


echo `date` >> $LOG_FILE
echo $SCRIPT_PROMPT The date has been logged in $LOG_FILE.
echo


echo $SCRIPT_PROMPT Script complete.


exit 0
