/*
 * AppController.j
 * Project OSL
 *
 * Created by Project Omni Software Localization on September 25, 2009.
 * Copyright 2009, OmniGroup and Rose-Hulman Institute of Technology 
 * All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "Controllers/OLProjectController.j"
@import "Controllers/OLGlossaryController.j"
@import "Controllers/OLContentViewController.j"
@import "Controllers/OLToolbarController.j"
@import "Controllers/OLSidebarController.j"
@import "Controllers/OLMenuController.j"
@import "Controllers/OLCommunityController.j"

@import "Views/OLMenu.j"
@import "Views/OLGlossariesView.j"
@import "Views/OLMailView.j"
@import "Views/OLProjectView.j"
@import "Views/OLProjectSearchView.j"
@import "Views/OLProjectResultView.j"

// This is a hack to get table views to show at a reasonable default size. When table
// views can resize properly, this can go away.
OSL_MAIN_VIEW_FRAME = nil;

@implementation AppController : CPObject
{
    @outlet						CPWindow                theWindow;
    @outlet						CPSplitView             mainSplitView;
    @outlet						CPView                  mainContentView;
    @outlet						CPScrollView            sidebarScrollView;
    @outlet						CPButtonBar             sidebarButtonBar;

    @outlet						OLSidebarController     sidebarController;
    @outlet						OLContentViewController contentViewController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This MUST come first!!
    OSL_MAIN_VIEW_FRAME = [mainContentView bounds];
    // DO NOT MOVE
    
    var uploadWindowController = [[OLUploadWindowController alloc] init];
	
	var projectController = [[OLProjectController alloc] init];
    [projectController addObserver:sidebarController forKeyPath:@"projects" options:CPKeyValueObservingOptionNew context:nil];
    [sidebarController addSidebarItem:projectController];
    
 	var glossaryController = [[OLGlossaryController alloc] init];
	[glossaryController addObserver:sidebarController forKeyPath:@"glossaries" options:CPKeyValueObservingOptionNew context:nil];
    [sidebarController addSidebarItem:glossaryController];
    
    var communityController = [[OLCommunityController alloc] init];
    [communityController addObserver:sidebarController forKeyPath:@"items" options:CPKeyValueObservingOptionNew context:nil];
    [communityController setContentViewController:contentViewController];
    [sidebarController addSidebarItem:communityController];
 
	var menuController = [[OLMenuController alloc] init];
    [CPMenu setMenuBarVisible:YES];
    
    [glossaryController loadGlossaries];
	
	var loginController = [[OLLoginController alloc] init];
    var toolbarController = [[OLToolbarController alloc] init];
 
    [theWindow setToolbar:[toolbarController toolbar]];
}

- (void)awakeFromCib
{
    // Configure main SplitView
    [mainSplitView setIsPaneSplitter:YES];
}

- (void)handleException:(OLException)anException
{
    CPLog.error(@"Error: %s threw the error: %s. In method: %s. Additional info: %s.", [anException classWithError], [anException reason], [anException methodWithError], [anException userInfo]);
    
    alert = [[CPAlert alloc] init];
    [alert setTitle:@"Application Error"];
    var message = [CPString stringWithFormat:@"Error!\n%s.", [anException userMessage]];
    [alert setMessageText:message];
    [alert addButtonWithTitle:@"Close"];
    [alert runModal];
}

@end

@implementation AppController (CPSplitViewDelegate)

- (CGFloat)splitView:(CPSplitView)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(int)dividerIndex
{    
    return proposedMin + 100.0;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(int)dividerIndex
{
    return 300.0;
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
