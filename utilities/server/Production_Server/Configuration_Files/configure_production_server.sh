#!/bin/bash

## About this Script
##
## Functionality:
## This script configures the Production Server with the newest release files
## which were sent directly from the Test Server before this script was sent
## to the Production Server.
##
## Inputs:
## None.
## 
## Environment:
## This script was designed specifically to be run on the Production Server
## environment and is probably not compatible with your local
## development environment.


#
# Set up variables
#

STARTING_DIR=$PWD

CONFIG_FILES_DIR="/Users/projectosl/Documents/Project_OSL/Configuration_Files"
STARTUP_SCRIPT="$CONFIG_FILES_DIR/startup"
TEARDOWN_SCRIPT="$CONFIG_FILES_DIR/teardown"

SCRIPT_PROMPT="`basename $0`>>"
PROMPT="echo $SCRIPT_PROMPT"


#
# Perform script duties
#

$PROMPT Fixing permissions on $TEARDOWN_SCRIPT...
chmod +x $TEARDOWN_SCRIPT
echo

$PROMPT Running $TEARDOWN_SCRIPT...
$TEARDOWN_SCRIPT
echo

$PROMPT Fixing permissions on $STARTUP_SCRIPT...
chmod +x $STARTUP_SCRIPT
echo

$PROMPT Running $STARTUP_SCRIPT...
$STARTUP_SCRIPT
echo


$PROMPT Script complete.

exit 0
