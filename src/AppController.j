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
@import "Controllers/LineItemEditWindowController.j"

@import "Managers/OLTransitionManager.j"

@import "Views/OLMenu.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";

@implementation AppController : CPObject
{
    @outlet                 CPWindow                theWindow;
    @outlet                 CPSplitView             mainSplitView;
    @outlet                 CPView                  mainContentView;
    @outlet                 OLSidebarController     sidebarController;
    @outlet                 CPScrollView            sidebarScrollView;
    @outlet                 CPButtonBar             sidebarButtonBar;

    // OLToolbarController _toolbarController @accessors(property=toolbarController);
    OLContentViewController _contentViewController  @accessors(property=contentViewController);
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // setupToolbar(self, theWindow);
    // setupContentView(self, _mainView, [contentView bounds]);
    
    var welcomeController = [[OLWelcomeController alloc] init];
    [welcomeController setDelegate:self];

    // Show the welcome window
    // var welcomeWindowController = [[OLWelcomeWindowController alloc] init];
    // [welcomeWindowController showWindow:self];
}

- (void)awakeFromCib
{
    // Configure main SplitView
    [mainSplitView setIsPaneSplitter:YES];

    [sidebarController setDelegate:self];

    // Setup the menubar. Once Atlas has menu editing, this can probably be scrapped
    var menu = [[OLMenu alloc] init];
    [[CPApplication sharedApplication] setMainMenu:menu];
    [CPMenu setMenuBarVisible:YES];
}

- (void)sidebarSendMessage:(SEL)aMessage
{
    console.log(aMessage, sidebarController, self);
	[sidebarController showResourcesView];
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

@implementation AppController (CPSplitViewDelegate)

- (CGFloat)splitView:(CPSplitView)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(int)dividerIndex
{
    if (splitView === mainSplitView)
    {
        return 100.0;
    }
    
    return proposedMin;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(int)dividerIndex
{
    if (splitView === mainSplitView)
    {
        return 300.0;
    }
    
    return proposedMax;
}

// Additional rect for CPButtonBar's handles
- (CGRect)splitView:(CPSplitView)splitView additionalEffectiveRectOfDividerAtIndex:(int)dividerIndex
{
    if (splitView === mainSplitView)
    {
        var rect = [sidebarButtonBar frame];
        var additionalWidth = 20.0;
        var additionalRect = CGRectMake(rect.origin.x + rect.size.width - additionalWidth, rect.origin.y, additionalWidth, rect.size.height);
        return additionalRect;
    }

    return CGRectMakeZero();
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
