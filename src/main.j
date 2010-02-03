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
    (DEBUG) ? CPLogRegister(CPLogConsole) : CPLogRegisterSingle(CPLogAlert, "error");
    
    CPApplicationMain(args, namedArgs);
}