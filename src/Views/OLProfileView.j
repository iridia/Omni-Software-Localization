@import <Foundation/CPObject.j>
@import "../Models/OLUser.j"
@import "../Models/OLLanguage.j"
@import "../Views/OLFormEditableTextField.j"
@import "../Controllers/OLProfileController.j"

OLProfileViewProjectNameColumnHeader = @"OLProfileViewProjectNameColumnHeader";
OLProfileViewLanguageNameColumnHeader = @"OLProfileViewLanguageNameColumnHeader";
OLAddLanguageToUserNotification = @"OLAddLanguageToUserNotification";

@implementation OLProfileView : CPView
{
    OLTableView             projectsView    @accessors;
    OLTableView             languagesView   @accessors;
    CPView                  titleView       @accessors;
    
    OLFormEditableTextField nicknameText    @accessors;
    OLFormEditableTextField locationText    @accessors;
    OLFormEditableTextField descriptionText @accessors;
    OLFormEditableTextField commentsText    @accessors;
    
    CPPopUpButton           languageButton  @accessors;
}

- (CPArray)titlesOfLanguages
{
    var result = [CPArray array];
    
    for(var i = 0; i < [[OLLanguage allLanguages] count]; i++)
    {
        [result addObject:[[[OLLanguage allLanguages] objectAtIndex:i] name]];
    }
    
    return [result sortedArrayUsingFunction:
               function(lhs,rhs,context)
               {
                   return [lhs compare: rhs];
               }];
}

- (id)initWithFrame:aFrame
{
    if (self === [super initWithFrame:aFrame])
    {
        var titleViewBorder = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), 41.0)];
        [titleViewBorder setBackgroundColor:[CPColor colorWithHexString:@"7F7F7F"]];
        [titleViewBorder setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:titleViewBorder];
        
        titleView = [[OLNavigationBarView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), 40.0)];
        [titleView setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:titleView positioned:CPViewTopAligned relativeTo:self withPadding:0.0];
        
        languageButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 24.0)];
        [languageButton setTarget:self];
        [languageButton setAction:@selector(addLanguageToUser:)];
        [languageButton addItemsWithTitles:[self titlesOfLanguages]];
        [titleView setAccessoryView:languageButton];
        
        var locationLabel = [CPTextField labelWithTitle:@"Location:"];
        [self addSubview:locationLabel];
        [locationLabel setFrameOrigin:CGPointMake(50.0, 50.0)];
        
        locationText = [[OLFormEditableTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 30.0)];
        [self addSubview:locationText positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:locationLabel withPadding:5.0];
        
        var commentsLabel = [CPTextField labelWithTitle:@"Comments Made:"];
        [self addSubview:commentsLabel positioned:CPViewBelow | CPViewRightSame relativeTo:locationLabel withPadding:15.0];
        
        commentsText = [[OLFormEditableTextField alloc] initWithFrame:CGRectMake(0.0,0.0,200.0,30.0)];
        [self addSubview:commentsText positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:commentsLabel withPadding:5.0];
        
        var descriptionLabel = [CPTextField labelWithTitle:@"Bio:"];
        [self addSubview:descriptionLabel positioned:CPViewBelow | CPViewRightSame relativeTo:commentsLabel withPadding:15.0];
        
        descriptionText = [[OLFormEditableTextField alloc] initWithFrame:CGRectMake(0.0,0.0,200.0,30.0)];
        [self addSubview:descriptionText positioned:CPViewHeightSame | CPViewOnTheRight relativeTo:descriptionLabel withPadding:5.0];
        
        var nicknameLabel = [CPTextField labelWithTitle:@"Nickname:"];
        [self addSubview:nicknameLabel positioned:CPViewBelow | CPViewRightSame relativeTo:descriptionLabel withPadding:15.0];
        
        nicknameText = [[OLFormEditableTextField alloc] initWithFrame:CGRectMake(0.0,0.0,200.0,30.0)];
        [self addSubview:nicknameText positioned:CPViewHeightSame | CPViewOnTheRight relativeTo:nicknameLabel withPadding:5.0];
        
        var projectColumn = [[CPTableColumn alloc] initWithIdentifier:OLProfileViewProjectNameColumnHeader];
        [[projectColumn headerView] setStringValue:@"Projects User Has Worked On"];
        [projectColumn setWidth:CGRectGetWidth(aFrame)];
        
        projectsView = [[OLTableView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(aFrame)/2,CGRectGetHeight(aFrame)) columns:[projectColumn]];
        [projectsView setUsesAlternatingRowBackgroundColors:YES];
        [projectsView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        var languageColumn = [[CPTableColumn alloc] initWithIdentifier:OLProfileViewLanguageNameColumnHeader];
        [[languageColumn headerView] setStringValue:@"Languages User Knows"];
        [languageColumn setWidth:CGRectGetWidth(aFrame)];
        
        languagesView = [[OLTableView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(aFrame)/2,CGRectGetHeight(aFrame)) columns:[languageColumn]];
        [languagesView setUsesAlternatingRowBackgroundColors:YES];
        [languagesView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        [self addSubview:projectsView positioned:CPViewBelow relativeTo:nicknameText withPadding:0.0];
        [self addSubview:languagesView positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:projectsView withPadding:0.0];
        
        var tableBorder = [[CPView alloc] initWithFrame:CGRectMake(0.0, [languagesView frame].origin.y, CGRectGetWidth(aFrame), 1.0)];
        [tableBorder setBackgroundColor:[CPColor colorWithHexString:@"7F7F7F"]];
        [tableBorder setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:tableBorder];

    }
    return self;
}

- (void)addLanguageToUser:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:OLAddLanguageToUserNotification object:[sender titleOfSelectedItem]];
}
- (void)resetTextFields:(CPString)aUserEmail
{
    [OLUser findByEmail:aUserEmail withCallback:function(user,isFinal)
        {
            if([user email] ===aUserEmail)
            {
                [locationText setStringValue:[user userLocation]];
                [descriptionText setStringValue:[user bio]];
                [nicknameText setStringValue:[user nickname]];
                return;
            }
        }];
}

- (CPTableView)projectsView
{
    return [projectsView tableView];
}

- (CPTableView)languagesView
{
    return [languagesView tableView];
}

- (void)setLanguagesTableViewDataSource:(id)aDataSource
{
    [languagesView setDataSource:aDataSource];
}

- (void)setProjectsTableViewDataSource:(id)aDataSource
{
    [projectsView setDataSource:aDataSource];
}

- (void)setProjectsTableViewDelegate:(id)aDelegate
{
    [projectsView setTarget:aDelegate];
    [projectsView setDelegate:aDelegate];
}

- (void)setLanguagesTableViewDelegate:(id)aDelegate
{
    [languagesView setTarget:aDelegate]
    [languagesView setDelegate:aDelegate];
}

- (void)reloadProjectsTableView
{
    [projectsTableView reloadData];
}

- (void)reloadLanguagesTableView
{
    [languagesTableView reloadData];
}

- (void)setDelegate:(id)aDelegate
{
    [projectsView setTarget:aDelegate];
    [projectsView setDelegate:aDelegate];
    [languagesView setTarget:aDelegate];
    [languagesView setDelegate:aDelegate];
}

- (void)reloadData
{
    [projectsView reloadData];
    [languagesView reloadData];
}

- (void)setTitle:(CPString)aTitle
{
    [titleView setTitle:aTitle];
}

- (void)setTextFieldsEditable
{
    if ([[[OLUserSessionManager defaultSessionManager] user] email] === [[titleView titleView] objectValue])
    {
        [nicknameText setCurrentlyEditable:YES];
        [locationText setCurrentlyEditable:YES];
        [descriptionText setCurrentlyEditable:YES];
        [commentsText setCurrentlyEditable:YES];
    }
}

- (void)setTextFieldsNonEditable
{
    [nicknameText setCurrentlyEditable:NO];
    [locationText setCurrentlyEditable:NO];
    [descriptionText setCurrentlyEditable:NO];
    [commentsText setCurrentlyEditable:NO];
}

@end