/*
 * AppController.j
 * Project OSL
 *
 * Created by Project Omni Software Localization on September 25, 2009.
 * Copyright 2009, OmniGroup and Rose-Hulman Institute of Technology 
 * All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "Controllers/OLMyProjectController.j"
@import "Controllers/OLGlossaryController.j"
@import "Controllers/OLContentViewController.j"
@import "Controllers/OLToolbarController.j"
@import "Controllers/OLSidebarController.j"
@import "Controllers/OLMenuController.j"
@import "Controllers/OLCommunityController.j"
@import "Controllers/OLProfileController.j"
@import "Controllers/OLWelcomeController.j"

@import "Views/OLMenu.j"
@import "Views/OLGlossariesView.j"
@import "Views/OLMailView.j"
@import "Views/OLProjectView.j"
@import "Views/OLProjectSearchView.j"
@import "Views/OLProjectResultView.j"
@import "Views/OLProfileView.j"
@import "Views/OLNotification.j"

@import "Utilities/OLUserSessionManager.j"
@import "Utilities/CPUserDefaults.j"
@import "Utilities/OLUndoManager.j"
@import "Utilities/OLHelpManager.j"

// User Default Keys. These are global so other places can access them, too
OLUserDefaultsShouldShowWelcomeWindowOnStartupKey = @"OLUserDefaultsShouldShowWelcomeWindowOnStartupKey";
OLUserDefaultsLoggedInUserIdentifierKey = @"OLUserDefaultsLoggedInUserIdentifierKey";

@implementation AppController : CPObject
{
    @outlet						CPWindow                theWindow;
    @outlet						CPSplitView             mainSplitView;

    @outlet						OLSidebarController     sidebarController;
    @outlet						OLContentViewController contentViewController;
}

+ (void)initialize
{
    // Setup the user defaults, these are overridden by the user's actual defaults stored in the cookie, if any
    var appDefaults = [CPDictionary dictionary];
    
    [appDefaults setObject:YES forKey:OLUserDefaultsShouldShowWelcomeWindowOnStartupKey];
    
    [[CPUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(userDidChange:)
        name:OLUserSessionManagerUserDidChangeNotification
        object:nil];
	
	var projectController = [[OLMyProjectController alloc] init];
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
	
	var loginController = [[OLLoginController alloc] init];
    var toolbarController = [[OLToolbarController alloc] init];
    
    var notification = [[OLNotification alloc] init];
 
    [theWindow setToolbar:[toolbarController toolbar]];
    
    if ([[CPUserDefaults standardUserDefaults] objectForKey:OLUserDefaultsShouldShowWelcomeWindowOnStartupKey])
    {
        [[OLWelcomeController alloc] init];
    }
    
    if ([[CPUserDefaults standardUserDefaults] objectForKey:OLUserDefaultsLoggedInUserIdentifierKey])
	{
	    var callback = function(user) {
	        if (user)
	        {
                [[OLUserSessionManager defaultSessionManager] setUser:user];
                
                [notification setNotificationText:@"Logged in an as " + [user email]];
                [notification setFrameOrigin:CGPointMake(CGRectGetWidth([[theWindow contentView] bounds])-330, 100)];
                [notification start];
            }
        };
        
	    [OLUser findByRecordID:[[CPUserDefaults standardUserDefaults] objectForKey:OLUserDefaultsLoggedInUserIdentifierKey] withCallback:callback];
	}
	
	[[OLHelpManager alloc] init];
    
    // Access the DB as late as possible
    [glossaryController loadGlossaries];
}

- (void)awakeFromCib
{
    // Configure main SplitView
    [mainSplitView setIsPaneSplitter:YES];
    [theWindow setAcceptsMouseMovedEvents:YES];
}

- (void)userDidChange:(CPNotification)notification
{
    var user = [[OLUserSessionManager defaultSessionManager] userIdentifier];
    
    [[CPUserDefaults standardUserDefaults] setObject:user forKey:OLUserDefaultsLoggedInUserIdentifierKey];
}

- (void)handleException:(OLException)anException
{
    CPLog.debug(@"Error: %s threw the error: %s. In method: %s. Additional info: %s.", [anException classWithError], [anException reason], [anException methodWithError], [anException userInfo]);
    
    alert = [[CPAlert alloc] init];
    [alert setTitle:@"Application Error"];
    var message = [CPString stringWithFormat:@"Error!\n%s.", [anException userMessage]];
    [alert setMessageText:message];
    [alert addButtonWithTitle:@"Close"];
    [alert runModal];
}

@end
