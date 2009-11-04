/*
 * AppController.j
 * Project OSL
 *
 * Created by Chandler Kent on September 25, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "Categories/OLColors+CPColor.j"
@import "controllers/OLWelcomeController.j"
@import "controllers/OLToolbarController.j"
@import "controllers/OLFeedbackController.j"
@import "views/OLMainView.j"
@import "views/OLResourceBundleView.j"
@import "views/OLResourceEditorView.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";

@implementation AppController : CPObject
{
	OLWelcomeController _welcomeController;
	OLResourceBundleController _resourceBundleController;
	OLFeedbackController _feedbackController;
	OLRepository _repository;
	CPToolbar _toolbar;
	OLMainView _mainView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	var contentView = [theWindow contentView];
	
    _toolbar = [[CPToolbar alloc] initWithIdentifier:OLMainToolbarIdentifier];
    [theWindow setToolbar:_toolbar];
	
	_welcomeController = [[OLWelcomeController alloc] initWithContentView:contentView];
	[_welcomeController setDelegate:self];
	
	_feedbackController = [[OLFeedbackController alloc] init];
	[_toolbar setDelegate:[[OLToolbarController alloc] initWithFeedbackController:_feedbackController]];
	// What if we eventually want the toolbar to send messages to multiple places? How are we going to handle this? Observers that only respond to certain messages?
	
	_resourceBundleController = [[OLResourceBundleController alloc] init];
	
    _mainView = [[OLMainView alloc] initWithFrame:[contentView bounds]];
    [_mainView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[_mainView setDelegate:self];
	
	[contentView addSubview:_mainView];
	
	[theWindow orderFront:self];
	
	[CPMenu setMenuBarVisible:YES];
}

// - (void)finishedReadingResourceBundle:(id)sender
// {
//     var resourceBundleView = [[OLResourceBundleView alloc] initWithFrame:[_mainView currentViewFrame]];// withController:_resourceBundleController];
//     [_resourceBundleController addObserver:resourceBundleView forKeyPath:@"bundle" options:CPKeyValueObservingOptionNew context:nil];
//  
//     [_resourceBundleController setBundle:[sender bundle]];
//     [_mainView setCurrentView:resourceBundleView];
// }

- (void)editBundle:(id)sender
{
    var resourceEditorView = [[OLResourceEditorView alloc] initWithFrame:[_mainView currentViewFrame]];
	[_resourceBundleController addObserver:resourceEditorView forKeyPath:@"editingBundle" options:CPKeyValueObservingOptionNew context:nil];
    [_resourceBundleController addObserver:resourceEditorView forKeyPath:@"editingBundle.resources" options:CPKeyValueObservingOptionNew context:nil];
	[resourceEditorView setDelegate:_resourceBundleController];
	
	[_mainView setCurrentView:resourceEditorView];
}

- (void)selectedResourcesList:(id)sender
{
	var resourceView = [[OLResourcesView alloc] initWithFrame:[_mainView currentViewFrame]];
	[resourceView setAutoresizingMask:CPViewHeightSizable | CPViewMaxXMargin];
	[resourceView setDelegate:_resourceBundleController];
	
	[_resourceBundleController addObserver:resourceView forKeyPath:@"bundles" options:CPKeyValueObservingOptionNew context:nil];
	[_resourceBundleController setDelegate:self];
	
	[_resourceBundleController loadBundles];
	[_mainView setCurrentView:resourceView];
	[_welcomeController poof];
}

- (void)selectResourcesList:(id)sender
{
	[[[_mainView sourceView] applicationsView] setSelectionIndexes:[[CPIndexSet alloc] initWithIndex:0]];
}

@end
