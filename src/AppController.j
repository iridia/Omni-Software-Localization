/*
 * AppController.j
 * Project OSL
 *
 * Created by Chandler Kent on September 25, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "controllers/OLWelcomeController.j"
@import "Categories/OLColors+CPColor.j"
@import "views/OLMainView.j"
@import "views/OLResourceBundleView.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";

@implementation AppController : CPObject
{
	OLWelcomeController _welcomeController;
	OLResourceBundleController _resourceBundleController;
	OLRepository _repository;
	CPToolbar _toolbar;
	OLMainView _mainView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	var contentView = [theWindow contentView];
	
    _toolbar = [[CPToolbar alloc] initWithIdentifier:OLMainToolbarIdentifier];
    // [_toolbar setDelegate:something];
    [theWindow setToolbar:_toolbar];
	
	_welcomeController = [[OLWelcomeController alloc] initWithContentView:contentView];
	[_welcomeController setDelegate:self];
	
	_resourceBundleController = [[OLResourceBundleController alloc] init];
	
    _mainView = [[OLMainView alloc] initWithFrame:[contentView bounds]];
    [_mainView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	
	[contentView addSubview:_mainView];
	
	[theWindow orderFront:self];
	
	[CPMenu setMenuBarVisible:YES];
}

- (void)finishedReadingResourceBundle:(id)sender
{
    var resourceBundleView = [[OLResourceBundleView alloc] initWithFrame:[_mainView currentViewFrame]];// withController:_resourceBundleController];
    [_resourceBundleController addObserver:resourceBundleView forKeyPath:@"bundle" options:CPKeyValueObservingOptionNew context:nil];
    
    [_resourceBundleController setBundle:[sender bundle]];
    [_mainView setCurrentView:resourceBundleView];
}

@end
