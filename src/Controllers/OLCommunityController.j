@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "OLMessageController.j"
@import "OLProfileController.j"
@import "OLProjectSearchController.j"

var OLCommunityInboxItem = @"Inbox";
var OLCommunitySearchItem = @"Search";
var OLCommunityProfileItem = @"Profile";

// Manages the community items in the sidebar and their respective controllers
@implementation OLCommunityController : CPObject
{
    CPString    selectedItem    @accessors;
	
	OLProjectSearchController   searchController;
	OLMessageController         messageController;
    OLProfileController         profileController;
}

- (id)init
    {
        if(self = [super init])
        {   
        	searchController = [[OLProjectSearchController alloc] init];
        	[searchController loadProjects];
        	
        	messageController = [[OLMessageController alloc] init];
            profileController = [[OLProfileController alloc] init];
                    	
        	[[CPNotificationCenter defaultCenter]
    			addObserver:self
    			selector:@selector(didReceiveOutlineViewSelectionDidChangeNotification:)
    			name:CPOutlineViewSelectionDidChangeNotification
    			object:nil];
    			
		    [[CPNotificationCenter defaultCenter]
    			addObserver:self
    			selector:@selector(didReceiveReselectProfileView:)
    			name:OLProfileNeedsToBeLoaded
    			object:nil];
    			
        }
        return self;
}

- (void)didReceiveReselectProfileView:(CPNotification)aNotification
{
    [profileController didReceiveLoadNewProfile:aNotification]
    [[CPNotificationCenter defaultCenter]
        postNotificationName:CPOutlineViewSelectionDidChangeThroughProfileNotification
        object:self
        userInfo:[CPDictionary dictionaryWithObject:[profileController profileView] forKey:@"view"]];
}

@end

@implementation OLCommunityController (SidebarItem)

- (CPString)sidebarName
{
    return @"Community";
}

- (CPArray)sidebarItems
{
    return [OLCommunityInboxItem, OLCommunitySearchItem, OLCommunityProfileItem];
}

- (BOOL)shouldExpandSidebarItemOnReload
{
    return YES;
}

- (CPView)contentView
{
    var view;
    switch(selectedItem)
    {
        case OLCommunityInboxItem:
            view = [messageController mailView];
            break;
        case OLCommunitySearchItem:
            view = [searchController contentView];
            [searchController loadProjects];
            break;
        case OLCommunityProfileItem:
            var userEmail = [[[OLUserSessionManager defaultSessionManager] user] email];
            [profileController setProfileView:[profileController profileView]];
            view = [profileController contentView];
            break;
        default:
            CPLog.warn(@"Unhandled case in %s, %s", [self className], _cmd);
            break;
    }
    
    return view;
}

- (void)didReceiveOutlineViewSelectionDidChangeNotification:(CPNotification)notification
{
	var outlineView = [notification object];

	var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
	var item = [outlineView itemAtRow:selectedRow];

	var parent = [outlineView parentForItem:item];

	if (parent === self)
	{	    
        [[CPNotificationCenter defaultCenter] postNotificationName:@"OLMenuShouldDisableItemsNotification" 
            object:[OLMenuItemNewLanguage, OLMenuItemDeleteLanguage, OLMenuItemDownload, OLMenuItemImport]];

	    [self setSelectedItem:item];

	    // tell content view controller to update view
		[[CPNotificationCenter defaultCenter]
		  postNotificationName:OLContentViewControllerShouldUpdateContentView
		  object:self];
	}
	else
	{
	    [self setSelectedItem:nil];
	}
}

@end