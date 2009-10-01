/*
 * AppController.j
 * Project OSL
 *
 * Created by Chandler Kent on September 25, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "OLWelcomeScreen.j"


@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	
	var contentView = [theWindow contentView];
	
	var welcomeScreen = [[OLWelcomeScreen alloc] initWithFrame:CPRectMake(0,0,700,200)];
	[welcomeScreen setCenter:[contentView center]];
	
	[welcomeScreen setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin | CPViewMinYMargin]
	
	[contentView addSubview:welcomeScreen];
	[contentView setBackgroundColor: [CPColor colorWithHexString:@"AAAAAA"]];
	
	[theWindow orderFront:self];
}

@end
