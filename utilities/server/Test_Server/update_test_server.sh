#!/bin/bash

## About This Script
##
## Functionality:
## This script updates the git repository in the WebServer
## directory on the Test Server.
## It creates log files and can tweet from @projectosl.
##
## Inputs:
## Optional - if you want to tweet, pass "tweet" as the first parameter.
## Optional - if tweet was given as first parameter, you pay pass the
## password for @projectosl as the second parameter. If not provided,
## the script will prompt for the password.
## 
## Environment:
## This script was designed specifically to be run on the Test Server
## environment and is probably not compatible with your local
## development environment.


#
# Set up variables
#

STARTING_DIR=$PWD

GIT_EXEC="/usr/local/git/bin/git"
GIT_REPO="/Library/WebServer/Omni-Software-Localization"
GIT_REPO_SRC="$GIT_REPO/src"
GIT_REPO_SRC_DEV="$GIT_REPO/src-dev"
GIT_INFO="$GIT_REPO/.git"
GIT_TEMP="/tmp/.git"

SCRIPTS_DIR="$GIT_REPO/utilities/server"
MY_DIR="$SCRIPTS_DIR/Test_Server"

LOGS_DIR="$GIT_REPO/utilities/Logs"
# MY_LOG_DIR="$LOGS_DIR/Test_Server_Updates" # Later, I want to log ALL output from script to a file
LOG_FILE="$LOGS_DIR/klondike_github_updates.log"

TWEETOSL_USER="projectosl"
TWEETOSL_EXEC="$SCRIPTS_DIR/tweet_from_projectosl.sh"
TWEETOSL_TEXT="Updated `hostname` to latest git repo"
TWEETOSL_FILE="$LOGS_DIR/last_twitter_response.txt"

SCRIPT_PROMPT="`basename $0`>>"
PROMPT="echo $SCRIPT_PROMPT"


#
# Perform script duties
#

$PROMPT Updating git repository in $GIT_REPO.
cd $GIT_REPO

$PROMPT Discarding local changes...
mv $GIT_INFO $GIT_TEMP
rm -rf *
mv $GIT_TEMP $GIT_INFO
$GIT_EXEC checkout .

$PROMPT Pulling latest repo...
$GIT_EXEC pull

$PROMPT Updating submodules...
$GIT_EXEC submodule init
$GIT_EXEC submodule update

$PROMPT Recreating development directory...
cp -r $GIT_REPO_SRC $GIT_REPO_SRC_DEV

cd $STARTING_DIR
echo


if [[ "$1" == "tweet" ]]
then
	$PROMPT Tweeting...
	if [ $2 ]
	then
		TWEETOSL_PW="$2"
	else
		read -s -p "$SCRIPT_PROMPT Enter the password for @$TWEETOSL_USER:" TWEETOSL_PW
		echo
	fi
	$TWEETOSL_EXEC "$TWEETOSL_PW" "$TWEETOSL_TEXT" > $TWEETOSL_FILE
	$PROMPT The response from Twitter has been logged in $TWEETOSL_FILE.
else
	$PROMPT Not tweeting.
fi
echo


echo `date` >> $LOG_FILE
$PROMPT The date has been logged in $LOG_FILE.
echo


$PROMPT Script complete.


exit 0
