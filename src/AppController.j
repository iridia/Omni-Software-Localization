/*
 * AppController.j
 * Project OSL
 *
 * Created by Chandler Kent on September 25, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "OLWelcomeView.j"
@import "OLResourceView.j"


@implementation AppController : CPObject
{
	CPView _contentView;
	OLWelcomeView _welcomeView;
	OLResourceView _resourceView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	
	_contentView = [theWindow contentView];
	
	_welcomeView = [[OLWelcomeView alloc] initWithFrame:CPRectMake(0,0,700,200) withController:self];
	[_welcomeView setCenter:[_contentView center]];
	
	[_welcomeView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin | CPViewMinYMargin]
	
	[_contentView addSubview:_welcomeView];
	[_contentView setBackgroundColor: [CPColor colorWithHexString:@"AAAAAA"]];
	
	[theWindow orderFront:self];
}

- (void)transitionToResourceView:(id)sender
{
	[_welcomeView removeFromSuperview];
	
	_resourceView = [[OLResourceView alloc] initWithFrame:[_contentView bounds]];
	
	[_contentView addSubview:_resourceView];
}

@end