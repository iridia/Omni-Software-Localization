/*
 * AppController.j
 * Project OSL
 *
 * Created by Chandler Kent on September 25, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "controllers/OLWelcomeController.j"


@implementation AppController : CPObject
{
	OLWelcomeController _welcomeController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];

	[[OLWelcomeController alloc] initWithContentView:[theWindow contentView]];
	
	[theWindow orderFront:self];
}

@end
