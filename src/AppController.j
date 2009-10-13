/*
 * AppController.j
 * Project OSL
 *
 * Created by Chandler Kent on September 25, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "views/OLWelcomeView.j"
@import "views/OLResourceView.j"
@import "controllers/OLResourceController.j"


@implementation AppController : CPObject
{
	CPView _contentView;
	OLWelcomeView _welcomeView;
	OLResourceView _resourceView;
	OLUploadingView _uploadingView;
	OLUploadedView _uploadedView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	
	_contentView = [theWindow contentView];
	
	_welcomeView = [[OLWelcomeView alloc] initWithFrame:CPRectMake(0,0,700,200) withController:self];
	[_welcomeView setCenter:[_contentView center]];
	
	[_welcomeView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin | CPViewMinYMargin];
	
	[_contentView addSubview:_welcomeView];
	[_contentView setBackgroundColor: [CPColor colorWithHexString:@"AAAAAA"]];
	
	[theWindow orderFront:self];
}

- (void)transitionToResourceView:(id)sender
{
	[_welcomeView removeFromSuperview];
	
	_resourceView = [[OLResourceView alloc] initWithFrame:[_contentView bounds] withController:[[OLResourceController alloc] init]];
	
	[_contentView addSubview:_resourceView];
}

- (void)showUploading
{
	_uploadingView = [[OLUploadingView alloc] initWithFrame:CPRectMake(0,0,400,200) withController:self];
	
	[_contentView addSubview:_uploadingView];
}

- (void)finishedUploadingWithResponse:(CPString)response
{
	[_uploadingView removeFromSuperview];
	
	_uploadedView = [[OLUploadedView alloc] initWithFrame:CPRectMake(0,0,400,200) withFilename:response withController:self];
	
	[_contentView addSubview:_uploadedView];
}

@end
