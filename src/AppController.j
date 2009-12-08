/*
 * AppController.j
 * Project OSL
 *
 * Created by Project Omni Software Localization on September 25, 2009.
 * Copyright 2009, OmniGroup and Rose-Hulman Institute of Technology 
 * All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "Categories/CPColor+OLColors.j"
@import "Controllers/OLContentViewController.j"
// @import "Controllers/OLToolbarController.j"
@import "Controllers/OLSidebarController.j"
@import "Controllers/OLWelcomeController.j"
@import "Controllers/OLWelcomeWindowController.j"
@import "Managers/OLTransitionManager.j"
@import "Views/OLMainView.j"
@import "Views/OLMenu.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";

@implementation AppController : CPObject
{
    @outlet CPWindow        theWindow;
    @outlet CPSplitView     mainSplitView;
    @outlet CPScrollView    sidebarScrollView;
    @outlet CPView          mainContentView;
	OLMainView _mainView;
	OLToolbarController _toolbarController @accessors(property=toolbarController);
	OLSidebarController _sidebarController @accessors(property=sidebarController);
	OLContentViewController _contentViewController @accessors(property=contentViewController);
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // _mainView = [[OLMainView alloc] initWithFrame:[contentView bounds]];
    // [_mainView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    // [_mainView setDelegate:self];

    // setupToolbar(self, theWindow);
    // setupSidebar(self, _mainView, [contentView bounds]);
    // setupContentView(self, _mainView, [contentView bounds]);
    
    // [contentView addSubview:_mainView];
    
    // var welcomeController = [[OLWelcomeController alloc] init];
    // [welcomeController setDelegate:self];

    // Show the welcome window
    // var welcomeWindowController = [[OLWelcomeWindowController alloc] init];
    // [welcomeWindowController showWindow:self];
}

- (void)awakeFromCib
{
    // Configure main SplitView
    [mainSplitView setIsPaneSplitter:YES];

    // Autohide the scrollers here and not in the Cib because it is impossible to
    // select the scrollView in Atlas again otherwise.
    [sidebarScrollView setAutohidesScrollers:YES];
    _sidebarController = [[OLSidebarController alloc] initWithFrame:[[sidebarScrollView contentView] bounds]];
    [sidebarScrollView setDocumentView:[_sidebarController sidebarOutlineView]];

    // Setup the menubar. Once Atlas has menu editing, this can probably be scrapped
    var menu = [[OLMenu alloc] init];
    [[CPApplication sharedApplication] setMainMenu:menu];
    [CPMenu setMenuBarVisible:YES];
}

- (void)sidebarSendMessage:(SEL)aMessage
{
	[_sidebarController handleMessage:aMessage];
}

- (void)contentViewSendMessage:(SEL)aMessage
{
	[_contentViewController handleMessage:aMessage];
}

- (void)setContentView:(CPView)aView
{
	[_mainView setCurrentView:aView];
}

- (void)handleException:(OLException)anException
{
	alert("Error!\n"+[anException name]+" threw error "+[anException reason]);
}

@end

// function setupToolbar(self, theWindow)
// {
//     var toolbarController = [[OLToolbarController alloc] initWithFeedbackController:feedbackController];
//     [toolbarController setDelegate:self];
// 
//  var toolbar = [[CPToolbar alloc] initWithIdentifier:OLMainToolbarIdentifier];
//  [toolbar setDelegate:toolbarController];
//  
//     [theWindow setToolbar:toolbar];
//  [self setToolbarController:toolbarController];
// }

function setupSidebar(self, mainView, frame)
{
	var sidebarController = [[OLSidebarViewController alloc] initWithCibName:@"SidebarView" bundle:[CPBundle mainBundle]]; 
	[sidebarController setDelegate:self];
	
	[mainView setSourceView:[sidebarController view]];
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
