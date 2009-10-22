/*
 * AppController.j
 * Project OSL
 *
 * Created by Chandler Kent on September 25, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "controllers/OLWelcomeController.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";

@implementation AppController : CPObject
{
	OLWelcomeController _welcomeController;
	OLRepository _repository;
	CPToolbar _toolbar;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	
    _toolbar = [[CPToolbar alloc] initWithIdentifier:OLMainToolbarIdentifier];
    // [_toolbar setDelegate:something];
    [theWindow setToolbar:_toolbar];
	
	[[OLWelcomeController alloc] initWithContentView:[theWindow contentView]];
	
	[theWindow orderFront:self];
	
	[CPMenu setMenuBarVisible:YES];
}

@end
