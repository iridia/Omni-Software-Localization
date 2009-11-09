/*
 * AppController.j
 * Project OSL
 *
 * Created by Project Omni Software Localization on September 25, 2009.
 * Copyright 2009, OmniGroup and Rose-Hulman Institute of Technology All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "Categories/OLColors+CPColor.j"
@import "Controllers/OLContentViewController.j"
@import "Controllers/OLFeedbackController.j"
@import "Controllers/OLToolbarController.j"
@import "Controllers/OLSidebarController.j"
@import "Managers/OLTransitionManager.j"
@import "Views/OLSidebarView.j"
@import "Views/OLMainView.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";

@implementation AppController : CPObject
{
	OLMainView _mainView;
	OLToolbarController _toolbarController @accessors(property=toolbarController);
	OLSidebarController _sidebarController @accessors(property=sidebarController);
	OLContentViewController _contentViewController @accessors(property=contentViewController);
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
	var contentView = [theWindow contentView];
	
    _mainView = [[OLMainView alloc] initWithFrame:[contentView bounds]];
    [_mainView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[_mainView setDelegate:self];
	
	setupToolbar(self, theWindow);
	setupSidebar(self, _mainView, [contentView bounds]);
	setupContentView(self, _mainView, [contentView bounds]);
	
	[contentView addSubview:_mainView];
	[theWindow orderFront:self];
	[CPMenu setMenuBarVisible:YES];
}

- (void)contentViewSendMessage:(SEL)aMessage
{
	[_contentViewController handleMessage:aMessage];
}

- (void)setContentView:(CPView)aView
{
	[_mainView setCurrentView:aView];
}

@end

function setupToolbar(self, theWindow)
{
	var feedbackController = [[OLFeedbackController alloc] init];
    var toolbarController = [[OLToolbarController alloc] initWithFeedbackController:feedbackController];
    [toolbarController setDelegate:self];

	var toolbar = [[CPToolbar alloc] initWithIdentifier:OLMainToolbarIdentifier];
	[toolbar setDelegate:toolbarController];
	
    [theWindow setToolbar:toolbar];
	[self setToolbarController:toolbarController];
}

function setupSidebar(self, mainView, frame)
{
	var sidebarController = [[OLSidebarController alloc] init];
	[sidebarController setDelegate:self];
	
	var sidebar = [[OLSidebarView alloc] initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight(frame))];
    [sidebar setBackgroundColor:[CPColor sourceViewColor]];
    [sidebar setAutoresizingMask:CPViewHeightSizable | CPViewMaxXMargin];
	[sidebar setDelegate:sidebarController];
	
	[mainView setSourceView:sidebar];
	[self setSidebarController:sidebarController];
}

function setupContentView(self, mainView, frame)
{
	var contentViewSize = CGRectMake(200, 0, CGRectGetWidth(frame) - 200, CGRectGetHeight(frame));
	
	var contentViewController = [[OLContentViewController alloc] init];
	[contentViewController setDelegate:self];
	
	var transitionManager = [[OLTransitionManager alloc] initWithFrame:contentViewSize];
	[contentViewController setTransitionManager:transitionManager];
	[transitionManager setDelegate:contentViewController];
	
    var currentView = [[CPView alloc] initWithFrame:contentViewSize];
	
	[mainView setCurrentView:currentView];
	[self setContentViewController:contentViewController];
}
