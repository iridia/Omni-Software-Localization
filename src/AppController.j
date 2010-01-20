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

@import "Controllers/OLProjectController.j"
@import "Controllers/OLLineItemController.j"
@import "Controllers/OLResourceController.j"
@import "Controllers/OLGlossaryController.j"
@import "Controllers/OLResourceBundleController.j"

@import "Controllers/OLContentViewController.j"
@import "Controllers/OLToolbarController.j"
@import "Controllers/OLSidebarController.j"
@import "Controllers/OLMenuController.j"
@import "Controllers/OLCommunityController.j"

@import "Views/OLMenu.j"
@import "Views/OLGlossariesView.j"
@import "Views/OLMailView.j"
@import "Views/OLMessageWindow.j"
@import "Views/OLProjectView.j"
@import "Views/OLProjectSearchView.j"

@implementation AppController : CPObject
{
    @outlet						CPWindow                theWindow;
    @outlet						CPSplitView             mainSplitView;
    @outlet						CPView                  mainContentView;
    @outlet						CPScrollView            sidebarScrollView;
    @outlet						CPButtonBar             sidebarButtonBar;

    @outlet						OLSidebarController     sidebarController;
    @outlet						OLContentViewController contentViewController;
	
	OLProjectController			projectController;
	OLResourceController		resourceController;
	OLLineItemController		lineItemController;
	OLGlossaryController		glossaryController;
	OLMenuController            menuController;
	OLMessageController         messageController;
	OLCommunityController       communityController;

    OLToolbarController         toolbarController       @accessors;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var uploadWindowController = [[OLUploadWindowController alloc] init];
	
	projectController = [[OLProjectController alloc] init];
    [projectController addObserver:sidebarController forKeyPath:@"projects" options:CPKeyValueObservingOptionNew context:nil];
    [sidebarController addSidebarItem:projectController];
    
    var projectView = [[OLProjectView alloc] initWithFrame:[mainContentView bounds]];
    [projectView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [projectController setProjectView:projectView];
    
    
 	glossaryController = [[OLGlossaryController alloc] init];
	[glossaryController addObserver:sidebarController forKeyPath:@"glossaries" options:CPKeyValueObservingOptionNew context:nil];
    [sidebarController addSidebarItem:glossaryController];
	
	var glossariesView = [[OLGlossariesView alloc] initWithFrame:[mainContentView bounds]];
	[glossariesView setGlossaryController:glossaryController];
	[glossaryController setGlossariesView:glossariesView];
    
    communityController = [[OLCommunityController alloc] init];
    [communityController addObserver:sidebarController forKeyPath:@"community" options:CPKeyValueObservingOptionNew context:nil];
    [communityController setContentViewController:contentViewController];
    [sidebarController addSidebarItem:communityController];
    
    var mailView = [[OLMailView alloc] initWithFrame:[mainContentView bounds]];
    [mailView setCommunityController:communityController];
    [communityController setMailView:mailView];
    
    var searchView = [[OLProjectSearchView alloc] initWithFrame:[mainContentView bounds]];
    [communityController setSearchView:searchView];
 
	menuController = [[OLMenuController alloc] init];
    [CPMenu setMenuBarVisible:YES];
	
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
