@import <Foundation/CPObject.j>
@import "../Models/OLUser.j"
@import "../Utilities/OLUserSessionManager.j"
@import "../Views/OLProfileView.j"
@import "../Views/OLFormEditableTextField.j"
@import "../Views/OLLinkTextField.j"
@import "OLProjectController.j"

OLProfileNeedsToBeLoaded = @"OLProfileNeedsToBeLoaded";

@implementation OLProfileController : CPObject
{
    OLProfileView   profileView     @accessors;
    CPString        userEmail       @accessors;
     
    CPArray         projects        @accessors;
    CPArray         languages       @accessors;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        projects = [CPArray array];
        languages = [CPArray array];
        [self setProfileView:[[OLProfileView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1222.0, 500.0)]];
        
        [[CPNotificationCenter defaultCenter]
    	    addObserver:self
    		selector:@selector(didReceiveUserDidChangeNotification:)
    		name:OLUserSessionManagerUserDidChangeNotification
    		object:nil];
    		
    	[[CPNotificationCenter defaultCenter]
    	    addObserver:self
    	    selector:@selector(didReceiveUserNeedsToSaveNotification:)
    	    name:editingTextFieldDidChangeNotification
    	    object:nil];
    	    
	    [[CPNotificationCenter defaultCenter]
    	    addObserver:self
    	    selector:@selector(didReceiveAddLanguageToUserNotification:)
    	    name:OLAddLanguageToUserNotification
    	    object:nil];

	    [[CPNotificationCenter defaultCenter]
    	    addObserver:self
    	    selector:@selector(didReceiveLoadNewProfile:)
    	    name:OLProfileNeedsToBeLoaded
    	    object:nil];
    	    
    	[[CPNotificationCenter defaultCenter]
    	    addObserver:self
    	    selector:@selector(didReceiveUpdateProjectsNotification:)
    	    name:OLProjectShouldReloadMyProjectsNotification
    	    object:nil];
    }
    
    return self;
}

- (void)didReceiveUpdateProjectsNotification:(CPNotification)aNotification
{
    [self loadProjects];
}

- (void)didReceiveLoadNewProfile:(CPNotification)aNotification
{
    userEmail = [aNotification object];
    [profileView setTitle:userEmail];
    [self setProfileView:profileView];
}

- (void)didReceiveAddLanguageToUserNotification:(CPNotification)aNotification
{
    if ([[[OLUserSessionManager defaultSessionManager] user] email] === userEmail)
    {
        [OLUser findByEmail:userEmail withCallback:
            function(user, isFinalUser)
            {
                if([[user languages] containsObject:[aNotification object]] || [aNotification object] === nil)
                {
                    return;
                }
                else
                {
                    [[user languages] addObject:[aNotification object]];
                    [user saveWithCallback:function(user, isFinal)
                    {
                        [self loadLanguages];
                }];
            }
        }];
    }
}

- (void)setProfileView:(OLProfileView)aProfileView
{
    profileView = aProfileView;
    [profileView setTitle:userEmail];
    [profileView setProjectsTableViewDataSource:self];
    [profileView setLanguagesTableViewDataSource:self];
    [profileView setDelegate:self];
    [profileView resetTextFields:userEmail];
    [self loadProjects];
    [self loadLanguages];
    if (userEmail === [[[OLUserSessionManager defaultSessionManager] user] email])
    {
        [profileView setTextFieldsEditable];
    }
    else
    {
        [profileView setTextFieldsNonEditable];
    }
}

- (void)didReceiveUserDidChangeNotification:(CPNotification)aNotification
{
    [self loadProjects];
    [self loadLanguages];
    var userLoggedIn = [[[OLUserSessionManager defaultSessionManager] user] email];
    if(userEmail === nil)
    {
        userEmail = userLoggedIn;
        [profileView setTitle:userEmail];
        [profileView resetTextFields:userEmail];
    }
    else if (userEmail === userLoggedIn)
    {
        [profileView setTextFieldsEditable];
    }
    else
    {
        [profileView setTextFieldsNonEditable];
    };
}

- (void)didReceiveUserNeedsToSaveNotification:(CPNotifcation)aNotifcation
{
    var aNickname = [[profileView nicknameText] objectValue];
    var someComments = [[profileView commentsText] objectValue];
    var aLocation = [[profileView locationText] objectValue];
    var aDescription = [[profileView descriptionText] objectValue];
    var emailToFind = [[profileView titleView] objectValue]; 
    [OLUser findByEmail:emailToFind withCallback:function(user, isFinal)
    {
        if (user && [[user email] isEqualToString:emailToFind])
        {
            [user setNickname:aNickname];
            [user setUserLocation:aLocation];
            [user setBio:aDescription];
            [user setLanguages:languages];
            [user save];
            return;
        }
    }];
}

- (void)loadProjects
{
    console.log("loading.");
    [self willChangeValueForKey:@"projects"];
    projects = [CPArray array];
    [self didChangeValueForKey:@"projects"];
    [OLUser findByEmail:userEmail withCallback:
        function(user,isFinalUser)
        {
            [OLProject findByUserIdentifier:[user recordID] withCallback:
                function(project, isFinalProject)
                {
                    [self addProject:project];
                    
                    if(isFinalProject)
                    {
                        [profileView reloadData];
                    }
                }];
        }];
}

- (void)loadLanguages
{
    [self willChangeValueForKey:@"languages"];
    languages = [CPArray array];
    [self didChangeValueForKey:@"languages"];
    [OLUser findByEmail:userEmail withCallback:
        function(user, isFinalUser)
        {
            for(var i=0; i<[[user languages] count];i++)
            {
                    [self addLanguage:[[user languages] objectAtIndex:i]];
            }
            [profileView reloadData];
        }];
}

- (void)addProject:(OLProject)project
{
    [self insertObject:project inProjectsAtIndex:[projects count]];
}

- (void)insertObject:(OLProject)project inProjectsAtIndex:(int)index
{
    [projects insertObject:project atIndex:index];
}

- (void)addLanguage:(CPString)language
{
    [self insertObject:language inLanguagesAtIndex:[languages count]];
}

- (void)insertObject:(CPString)language inLanguagesAtIndex:(int)index
{
    [languages insertObject:language atIndex:index];
}

@end

@implementation OLProfileController (SidebarItem)

- (CPView)contentView
{
    return profileView;
}

@end

@implementation OLProfileController (OLProfileTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)tableView
{
    if(tableView === [profileView projectsView])
    {
        return [projects count];
    }
    else if(tableView === [profileView languagesView])
    {
        return [languages count];        
    }

}

- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    var projectsTableView = [profileView projectsView];
    var languagesTableView = [profileView languagesView];

    if(tableView === projectsTableView)
    {
        if([tableColumn identifier] === OLProfileViewProjectNameColumnHeader)
        {
            return [[projects objectAtIndex:row] name];
        }
    }
    else if(tableView === languagesTableView)
    {
        if([tableColumn identifier] === OLProfileViewLanguageNameColumnHeader)
        {
            return [languages objectAtIndex:row];
        }
    }
    
    return nil;
}
@end