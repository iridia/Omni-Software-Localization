@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Models/OLProject.j"
@import "../Views/OLProjectView.j"

@import "OLLoginController.j"
@import "OLResourceBundleController.j"
@import "OLImportProjectController.j"
@import "OLMenuController.j"

OLProjectShouldReloadMyProjectsNotification = @"OLProjectShouldReloadMyProjectsNotification";
OLProjectShouldCreateCommentNotification = @"OLProjectShouldCreateCommentNotification";
OLProjectDidChangeNotification = @"OLProjectDidChangeNotification";

// Manages an array of projects
@implementation OLProjectController : CPObject
{
    CPArray         projects       	    @accessors;
	OLProject	    selectedProject		@accessors;
	OLProjectView   projectView;
	
	OLResourceBundleController  resourceBundleController;
}

- (void)init
{
    self = [super init];
    if(self)
    {
		projects = [CPArray array];
		
		resourceBundleController = [[OLResourceBundleController alloc] init];
        [self addObserver:resourceBundleController forKeyPath:@"selectedProject" options:CPKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)registerForNotifications
{
    [[CPNotificationCenter defaultCenter]
	    addObserver:self
	    selector:@selector(didReceiveProjectDidChangeNotification:)
	    name:OLProjectDidChangeNotification
	    object:nil];
	    
    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(didReceiveLineItemSelectedIndexDidChangeNotification:)
        name:OLLineItemSelectedLineItemIndexDidChangeNotification
        object:[[resourceBundleController resourceController] lineItemController]];
}

- (void)loadProjects
{
}

- (void)insertObject:(OLProject)project inProjectsAtIndex:(int)index
{
    [projects insertObject:project atIndex:index];
}

- (void)addProject:(OLProject)project
{
    [self insertObject:project inProjectsAtIndex:[projects count]];
}

- (void)downloadSelectedProject:(CPNotification)notification
{
    var request = [CPURLRequest requestWithURL:@"Download/Download.php"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[selectedProject recordID]];
    [OLURLConnectionFactory createConnectionWithRequest:request delegate:self];
    
    var notification = [[OLNotification alloc] init];
    [notification setNotificationText:@"Download of " + [selectedProject name] + " started."];
    [notification setFrameOrigin:CGPointMake(CGRectGetWidth([[[CPApp mainWindow] contentView] bounds])-330, 100)];
    [notification start];
}

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    // This downloads the application without opening a window. This is pretty jank, but works.
    var webView = [[CPWebView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [webView setMainFrameURL:@"Download/" + [selectedProject name] + ".zip"];
    [projectView addSubview:webView];
    [CPTimer scheduledTimerWithTimeInterval:1 callback:function(){[webView removeFromSuperview];} repeats:NO];
}

- (void)didReceiveProjectDidChangeNotification:(CPNotification)notification
{
    [selectedProject save];
    [projectView reloadAllData];
}

- (void)didReceiveLineItemSelectedIndexDidChangeNotification:(CPNotification)notification
{
    var index = [[notification userInfo] objectForKey:@"SelectedIndex"];
    
    [projectView selectLineItemsTableViewRowIndexes:[CPIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
}

@end

@implementation OLProjectController (ProjectViewDelegate)


- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var tableView = [aNotification object];
    
    var selectedRow = [[tableView selectedRowIndexes] firstIndex];
    
    if (tableView === [projectView resourcesTableView])
    {
        [resourceBundleController selectResourceAtIndex:selectedRow];
        [projectView reloadLineItemsTableView];
        [projectView reloadVoting];
        [projectView selectLineItemsTableViewRowIndexes:[CPIndexSet indexSet] byExtendingSelection:NO];
        [projectView setIsEditing:(selectedRow !== CPNotFound)];
    }
    
    if (tableView === [projectView lineItemsTableView])
    {
        [resourceBundleController selectLineItemAtIndex:selectedRow];
    }
}

- (void)lineItemsTableViewDoubleClick:(CPTableView)tableView
{
    var userSessionManager = [OLUserSessionManager defaultSessionManager];
    if(![userSessionManager isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to edit this item!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(lineItemsTableViewDoubleClick:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];
        
        [[CPNotificationCenter defaultCenter]
            postNotificationName:OLLoginControllerShouldLoginNotification
            object:nil
            userInfo:userInfo];
        return;
    }
    else if(![userSessionManager isUserTheLoggedInUser:[selectedProject userIdentifier]])
    {
        [self branchSelectedProject];
          
        return;
    }
    
    [resourceBundleController editSelectedLineItem];
}

// HACK FOR CPTableView BUG (_doubleAction is a global var)
- (SEL)doubleAction
{
    return CPSelectorFromString(@"lineItemsTableViewDoubleClick:");
}

@end

@implementation OLProjectController (ProjectViewDataSource)

- (CPArray)titlesOfResourceBundlesForProjectView:(OLProjectView)projectView
{
    return [resourceBundleController titlesOfResourceBundles];
}

- (int)indexOfSelectedResourceBundleForProjectView:(OLProjectView)projectView
{
    return [resourceBundleController indexOfSelectedResourceBundle];
}

- (void)selectedResourceBundleDidChange:(int)selectedIndex
{
    [projectView selectResourcesTableViewRowIndexes:[CPIndexSet indexSet] byExtendingSelection:NO];
    [resourceBundleController selectResourceBundleAtIndex:selectedIndex];
    [projectView reloadAllData];
}

- (void)startDeleteBundle:(id)sender
{
    if(![[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to add a new language!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(startDeleteBundle:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];

        [[CPNotificationCenter defaultCenter]
            postNotificationName:OLLoginControllerShouldLoginNotification
            object:nil
            userInfo:userInfo];

        return;
    }
    else if(![[OLUserSessionManager defaultSessionManager] isUserTheLoggedInUser:[selectedProject userIdentifier]])
    {
        [self branchSelectedProject];
        return;
    }
    
    [resourceBundleController startDeleteBundle:sender];
}

@end

@implementation OLProjectController (VotingDelegateAndDataSource)

- (void)voteUp:(id)sender
{
    var user = [[OLUserSessionManager defaultSessionManager] user];
    if(user)
    {
        var oldVoteValue = [self usersCurrentVoteValue:user];
        if(oldVoteValue !== 1)
        {
            [resourceBundleController voteUp];
            [projectView reloadVoting];
            if(oldVoteValue === -1)
            {
                [selectedProject voteUp];
                [selectedProject voteUp];
            }
            else
            {
                [selectedProject voteUp];
            }
            [selectedProject save];
        }
    }
    else
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:OLLoginControllerShouldLoginNotification object:self];
    }
}

- (void)voteDown:(id)sender
{
    var user = [[OLUserSessionManager defaultSessionManager] user];
    if(user)
    {
        var oldVoteValue = [self usersCurrentVoteValue:user];
        if(oldVoteValue !== -1)
        {
            [resourceBundleController voteDown];
            [projectView reloadVoting];
            if(oldVoteValue === 1)
            {
                [selectedProject voteDown];
                [selectedProject voteDown];
            }
            else
            {
                [selectedProject voteDown];
            }
            [selectedProject save];
        }
    }
    else
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:OLLoginControllerShouldLoginNotification object:self];
    }
}

- (int)numberOfVotesForSelectedResource
{
    return [resourceBundleController numberOfVotesForSelectedResource];
}

- (int)usersCurrentVoteValue:(OLUser)user
{
    return [[[[resourceBundleController resourceController] selectedResource] votes] objectForKey:[user recordID]];
}

@end

@implementation OLProjectController (OwnerDataSource)

- (CPString)owner
{
    if([selectedProject userIdentifier] === [[OLUserSessionManager defaultSessionManager] userIdentifier])
    {
        return "yours";
    }
    
    return "not yours";
}

@end

@implementation OLProjectController (TitleDataSource)

- (CPString)title
{
    return [selectedProject name];
}

@end
