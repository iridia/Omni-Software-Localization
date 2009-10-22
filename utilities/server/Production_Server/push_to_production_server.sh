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
GIT_EXEC="/usr/local/git/bin/git"

PROJECT_DIR="/Users/projectosl/Documents/Project_OSL"
SCRIPTS_DIR="$PROJECT_DIR/Scripts"
MY_DIR="$SCRIPTS_DIR/Production_Server"

LOGS_DIR="$PROJECT_DIR/Logs"
# MY_LOG_DIR="$LOGS_DIR/Test_Server_Updates" # Later, I want to log ALL output from script to a file
LOG_FILE="$LOGS_DIR/github_updates.log"

TWEETOSL_EXEC="$SCRIPTS_DIR/tweet_from_projectosl.sh"

CONFIG_FILES_DIR="$MY_DIR/Configuration_Files"
CONFIG_SCRIPT="$MY_DIR/configure_production_server.sh"

USER="projectosl"
SERVER="shellder.omnigroup.com"

############ THIS FILE HAS NOT BEEN UPDATED BELOW THIS LINE #########

# Perform script duties

echo Sending configuration files to 
cd $GIT_REPO
$GIT_EXEC pull
cd $STARTING_DIR
echo


echo Tweeting...
$TWEETOSL_EXEC "Updated $HOSTNAME to latest git repo"
echo


echo `date` >> $LOG_FILE
echo The date has been logged in $LOG_FILE.
echo


echo Script complete.


exit 0
