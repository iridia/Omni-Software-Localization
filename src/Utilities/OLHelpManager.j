@import <Foundation/CPObject.j>

var OLSharedHelpManager = nil;

@implementation OLHelpManager : CPObject
{
    CPWindow    helpWindow;
    CPWebView   webView;
}

+ (id)sharedHelpManager
{
    if (!OLSharedHelpManager)
        OLSharedHelpManager = [[OLHelpManager alloc] init];
    
    return OLSharedHelpManager;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        helpWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(100.0, 100.0, 450.0, 450.0) styleMask:CPClosableWindowMask | CPResizableWindowMask];
        [helpWindow setTitle:[self _helpName]];
        
        [self _setupHelpWindow];
        [self _setupMenuBar];
    }
    return self;
}

- (void)showHelp:(id)sender
{
    [helpWindow orderFront:self];
}

- (void)hideHelp:(id)sender
{
    [helpWindow orderOut:self];
}

- (void)navigate:(id)sender
{
    var selected = [sender selectedSegment];
    
    if (selected === 0)
    {
        [webView goBack:self];
    }
    else if (selected === 1)
    {
        [webView goForward:self];
    }
}

- (void)goHome:(id)sender
{
    [webView setMainFrameURL:[self _homeURL]];
}

- (void)_setupHelpWindow
{
    webView = [[CPWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 500.0)];
    [webView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    [webView setMainFrameURL:[self _homeURL]];
    
    [helpWindow setContentView:webView];
    
    [self _setupToolbar];
}

- (void)_setupToolbar
{
    var toolbar = [[CPToolbar alloc] initWithIdentifier:@"OLHelpManagerToolbar"];
    [toolbar setDelegate:self];
    
    [helpWindow setToolbar:toolbar];
}

- (void)_setupMenuBar
{
    // Should check if the menu already has a help item and remove it.
    var mainMenu = [[CPApplication sharedApplication] mainMenu];
    
    var helpMenuItem = [[CPMenuItem alloc] initWithTitle:@"Help" action:nil keyEquivalent:nil];
    var helpSubmenu = [[CPMenu alloc] initWithTitle:@"HelpSubmenu"];

    var applicationHelpMenuItem = [[CPMenuItem alloc] initWithTitle:[self _helpName] action:@selector(showHelp:) keyEquivalent:nil];
    [applicationHelpMenuItem setTarget:self];
    
    [helpSubmenu addItem:applicationHelpMenuItem];
    [helpMenuItem setSubmenu:helpSubmenu];
    [mainMenu addItem:helpMenuItem];
}

- (CPString)_helpName
{
    return [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleHelpBookName"];
}

- (CPString)_homeURL
{
    var helpFolder = [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleHelpBookFolder"];
    return [CPString stringWithFormat:@"Resources/%s/", helpFolder];
}

@end

var OLHelpManagerHomeItemIdentifier = @"OLHelpManagerHomeItemIdentifier";
var OLHelpManagerNavigationItemIdentifier = @"OLHelpManagerNavigationItemIdentifier";

@implementation OLHelpManager (CPToolbarDelegate)

- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)toolbar
{
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)toolbar
{
    return [OLHelpManagerNavigationItemIdentifier, CPToolbarFlexibleSpaceItemIdentifier, OLHelpManagerHomeItemIdentifier];
}

- (CPToolbarItem)toolbar:(CPToolbar)toolbar itemForItemIdentifier:(CPString)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    var menuItem = [[CPToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if (itemIdentifier === OLHelpManagerNavigationItemIdentifier)
    {
        var navControl = [[CPSegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 24.0)];
        [navControl setSegmentCount:2];
        [navControl setLabel:@"Back" forSegment:0];
        [navControl setLabel:@"Forward" forSegment:1];
        [navControl setTarget:self];
        [navControl setAction:@selector(navigate:)];
        [navControl setTrackingMode:CPSegmentSwitchTrackingMomentary];

        var width = CGRectGetWidth([navControl bounds]);
        [menuItem setMinSize:CGSizeMake(width, 24.0)];
        [menuItem setMaxSize:CGSizeMake(width, 24.0)];
        [menuItem setLabel:"Navigation"];
        [menuItem setView:navControl];
    }
    else if(itemIdentifier === OLHelpManagerHomeItemIdentifier)
    {
        var homeButton = [CPButton buttonWithTitle:@"Home"];
        [homeButton setTarget:self];
        [homeButton setAction:@selector(goHome:)];
        
        var width = CGRectGetWidth([homeButton bounds]);
        [menuItem setMinSize:CGSizeMake(width, 24.0)];
        [menuItem setMaxSize:CGSizeMake(width, 24.0)];
        [menuItem setLabel:"Home"];
        [menuItem setView:homeButton];
    }
    
    return menuItem;
}

@end
