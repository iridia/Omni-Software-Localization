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
@import "Controllers/OLUploadController.j"
@import "Controllers/OLResourceController.j"
@import "Controllers/OLLineItemController.j"

@import "Views/OLMenu.j"
@import "Views/OLResourcesView.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";

@implementation AppController : CPObject
{
    @outlet                 CPWindow                theWindow;
    @outlet                 CPSplitView             mainSplitView;
    @outlet                 CPView                  mainContentView         @accessors(readonly);
    @outlet                 CPScrollView            sidebarScrollView;
    @outlet                 CPButtonBar             sidebarButtonBar;

    @outlet                 OLSidebarController     sidebarController;
    @outlet                 OLContentViewController contentViewController   @accessors(readonly);
	
	OLProjectController		projectController;
	OLUploadController		uploadController;
	OLResourceController    resourceController;
	OLLineItemController    lineItemController;
	
	OLResourcesView         resourcesView;

    // OLToolbarController _toolbarController @accessors(property=toolbarController);
    
    CPView                  currentView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // setupToolbar(self, theWindow);
	uploadController = [[OLUploadController alloc] init];
	
	var welcomeController = [[OLWelcomeController alloc] init];
    [welcomeController setDelegate:self];
	[welcomeController setUploadController:uploadController];
	
	projectController = [[OLProjectController alloc] init];
	[projectController addObserver:contentViewController forKeyPath:@"selectedProject" options:CPKeyValueObservingOptionNew context:nil];
    [projectController addObserver:sidebarController forKeyPath:@"projects" options:CPKeyValueObservingOptionNew context:nil];
	[projectController loadProjects];
	
	resourceController = [[OLResourceController alloc] init];
    [projectController addObserver:resourceController forKeyPath:@"selectedProject" options:CPKeyValueObservingOptionNew context:nil];
	
	lineItemController = [[OLLineItemController alloc] init];
	[lineItemController setResourcesView:[resourceController resourcesView]];
	[resourceController addObserver:lineItemController forKeyPath:@"selectedResource" options:CPKeyValueObservingOptionNew context:nil];
	
	resourcesView = [[OLResourcesView alloc] initWithFrame:[[[CPApp delegate] mainContentView] bounds]];
    [resourcesView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [resourcesView setResourceController:resourceController];
    [resourcesView setLineItemController:lineItemController];
    [[resourcesView editingView] setVoteTarget:resourceController downAction:@selector(voteDown:) upAction:@selector(voteUp:)];
    
    [resourceController setResourcesView:resourcesView];
    [lineItemController setResourcesView:resourcesView];
	[contentViewController setResourcesView:resourcesView];
}

- (void)awakeFromCib
{
    // Configure main SplitView
    [mainSplitView setIsPaneSplitter:YES];
    
    // Setup the menubar. Once Atlas has menu editing, this can probably be scrapped
    var menu = [[OLMenu alloc] init];
    [[CPApplication sharedApplication] setMainMenu:menu];
    [CPMenu setMenuBarVisible:YES];
}

- (void)sidebarSendMessage:(SEL)aMessage
{
	[sidebarController showResourcesView];
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
