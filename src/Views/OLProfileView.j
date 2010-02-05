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

-(id) initWithFrame:aFrame
{
    if (self === [super initWithFrame:aFrame])
    {
        titleView = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), 40.0)];
        [titleView setFont:[CPFont boldSystemFontOfSize:20.0]];
        [titleView setTextShadowColor:[CPColor colorWithCalibratedWhite:240.0 / 255.0 alpha:1.0]];
        [titleView setTextShadowOffset:CGSizeMake(0.0, 1.5)];
        [titleView setTextColor:[CPColor colorWithCalibratedWhite:79.0 / 255.0 alpha:1.0]];
        [titleView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];
        [titleView setBackgroundColor:[CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/_CPToolbarViewBackground.png"]]]];
        [self addSubview:titleView positioned:CPViewTopAligned relativeTo:self withPadding:0.0];
        
        languageButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 24.0)];
        [languageButton setTarget:self];
        [languageButton setAction:@selector(addLanguageToUser:)];
        [languageButton addItemsWithTitles:[self titlesOfLanguages]];
        [self addSubview:languageButton positioned:CPViewRightAligned | CPViewHeightSame relativeTo:titleView withPadding:0.0];
        
        var locationLabel = [CPTextField labelWithTitle:@"Location:"];
        [self addSubview:locationLabel positioned:CPViewBelow relativeTo:titleView withPadding:0.0];
        
        locationText = [[OLFormEditableTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 30.0)];
        [locationText setStringValue:@"Test!!!"];
        [self addSubview:locationText positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:locationLabel withPadding:5.0];
        
        var commentsLabel = [CPTextField labelWithTitle:@"Comments Made:"];
        [self addSubview:commentsLabel positioned:CPViewBelow relativeTo:locationText withPadding:0.0];
        
        commentsText = [[OLFormEditableTextField alloc] initWithFrame:CGRectMake(0.0,0.0,200.0,30.0)];
        [commentsText setStringValue:@"some algorithm for comments."];
        [self addSubview:commentsText positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:commentsLabel withPadding:5.0];
        
        var descriptionLabel = [CPTextField labelWithTitle:@"Bio:"];
        [self addSubview:descriptionLabel positioned:CPViewBelow relativeTo:commentsText withPadding:0.0];
        
        descriptionText = [[OLFormEditableTextField alloc] initWithFrame:CGRectMake(0.0,0.0,200.0,30.0)];
        [descriptionText setStringValue:@"My little bio.  I work hard \n  I am observant. \n I use comments."];
        [self addSubview:descriptionText positioned:CPViewHeightSame | CPViewOnTheRight relativeTo:descriptionLabel withPadding:5.0];
        
        var nicknameLabel = [CPTextField labelWithTitle:@"Nickname:"];
        [self addSubview:nicknameLabel positioned:CPViewBelow relativeTo:descriptionText withPadding:0.0];
        
        nicknameText = [[OLFormEditableTextField alloc] initWithFrame:CGRectMake(0.0,0.0,200.0,30.0)];
        [nicknameText setStringValue:@"somenamehere"];
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
    [titleView setStringValue:aTitle];
    [self centerTitleView];
}

- (void)centerTitleView
{
    [titleView setAlignment:CPCenterTextAlignment];
}

- (void)setTextFieldsEditable
{
    if ([[[OLUserSessionManager defaultSessionManager] user] email] ===[titleView objectValue])
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