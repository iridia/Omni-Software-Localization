/*
 * AppController.j
 * Project OSL
 *
 * Created by Chandler Kent on September 25, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@import "AppController.j"

function main(args, namedArgs)
{
    CPLogRegister(CPLogConsole);
    CPApplicationMain(args, namedArgs);
}

// This overrides CPLog.debug to only print to the console if you are in index-debug.html
// so that we don't have to worry about removing debug statements from shipping code
var debug = CPLog.error;
CPLog.debug = function() { if (DEBUG) {debug.apply(this, arguments)} };