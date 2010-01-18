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
@import "Controllers/OLWelcomeController.j"
@import "Controllers/OLUploadController.j"

@import "Views/OLMenu.j"
@import "Views/OLResourcesView.j"
@import "Views/OLGlossariesView.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";

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
	
	OLResourcesView				resourcesView;
	OLGlossariesView			glossariesView;

    OLToolbarController         toolbarController @accessors(property=toolbarController);
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // var welcomeController = [[OLWelcomeController alloc] init];
    //     [welcomeController setDelegate:self];
    // [welcomeController setUploadController:uploadController];
    
    var uploadWindowController = [[OLUploadWindowController alloc] init];
	
	projectController = [[OLProjectController alloc] init];
	[projectController addObserver:contentViewController forKeyPath:@"selectedProject" options:CPKeyValueObservingOptionNew context:nil];
    [projectController addObserver:sidebarController forKeyPath:@"projects" options:CPKeyValueObservingOptionNew context:nil];
    [projectController setProjects:[]];
    
    resourceBundleController = [[OLResourceBundleController alloc] init];
    [projectController addObserver:resourceBundleController forKeyPath:@"selectedProject" options:CPKeyValueObservingOptionNew context:nil];
	
	resourceController = [[OLResourceController alloc] init];
    [resourceBundleController addObserver:resourceController forKeyPath:@"selectedResourceBundle" options:CPKeyValueObservingOptionNew context:nil];
	
	lineItemController = [[OLLineItemController alloc] init];
	[lineItemController setResourcesView:[resourceController resourcesView]];
	[resourceController addObserver:lineItemController forKeyPath:@"selectedResource" options:CPKeyValueObservingOptionNew context:nil];
	
    resourcesView = [[OLResourcesView alloc] initWithFrame:[mainContentView bounds]];
    [resourcesView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [resourcesView setResourceController:resourceController];
    [resourcesView setLineItemController:lineItemController];
    [resourcesView setResourceBundleController:resourceBundleController];
    [[resourcesView editingView] setVoteTarget:resourceController downAction:@selector(voteDown:) upAction:@selector(voteUp:)];
    
    [resourceController setResourcesView:resourcesView];
    [resourceBundleController setResourcesView:resourcesView];
    [lineItemController setResourcesView:resourcesView];
	[contentViewController setResourcesView:resourcesView];
	
	glossaryController = [[OLGlossaryController alloc] init];
	[glossaryController addObserver:sidebarController forKeyPath:@"glossaries" options:CPKeyValueObservingOptionNew context:nil];
	[glossaryController addObserver:contentViewController forKeyPath:@"selectedGlossary" options:CPKeyValueObservingOptionNew context:nil];
	[glossaryController setGlossaries:[]];
	
	glossariesView = [[OLGlossariesView alloc] initWithFrame:[mainContentView bounds]];
	[glossariesView setGlossaryController:glossaryController];
	[contentViewController setGlossariesView:glossariesView];
	[glossaryController setGlossariesView:glossariesView];
	
    [projectController loadProjects];
	[glossaryController loadGlossaries];
	
	var loginController = [[OLLoginController alloc] init];
	
    setupToolbar(self, theWindow, loginController, projectController, nil);
}

- (void)awakeFromCib
{
    // Configure main SplitView
    [mainSplitView setIsPaneSplitter:YES];
    
    var menu = [[OLMenu alloc] init];
    [[CPApplication sharedApplication] setMainMenu:menu];
    [CPMenu setMenuBarVisible:YES];
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

function setupToolbar(self, theWindow, loginController, projectController, glossaryController)
{
    var feedbackController = [[OLFeedbackController alloc] init];
    var toolbarController = [[OLToolbarController alloc] initWithFeedbackController:feedbackController loginController:loginController
            projectController:projectController glossaryController:glossaryController];

    var toolbar = [[CPToolbar alloc] initWithIdentifier:OLMainToolbarIdentifier];
    [toolbar setDelegate:toolbarController];
    [toolbarController setToolbar:toolbar];
 
    [theWindow setToolbar:toolbar];
    [self setToolbarController:toolbarController];
}
