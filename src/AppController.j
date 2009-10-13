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
	OLRepository _repository;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	
	_repository = [[OLRepository alloc] init];
	
	[_repository registerSingleton:[[OLWelcomeView alloc] initWithFrame:CPRectMake(0,0,700,200) withController:self]];

	[[OLWelcomeController alloc] initWithContentView:[theWindow contentView]];
	
	[theWindow orderFront:self];
}

@end
