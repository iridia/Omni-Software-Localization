@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "OLMessageController.j"
@import "OLProjectSearchController.j"

var OLCommunityInboxItem = @"Inbox";
var OLCommunitySearchItem = @"Search";

// Manages the community items in the sidebar and their respective controllers
@implementation OLCommunityController : CPObject
{
    CPString    selectedItem    @accessors;
	
	OLProjectSearchController   searchController;
	OLMessageController         messageController;
}

- (id)init
    {
        if(self = [super init])
        {        		
        	searchController = [[OLProjectSearchController alloc] init];
        	[searchController loadProjects];
        	
        	messageController = [[OLMessageController alloc] init];
        	
        	[[CPNotificationCenter defaultCenter]
    			addObserver:self
    			selector:@selector(didReceiveOutlineViewSelectionDidChangeNotification:)
    			name:CPOutlineViewSelectionDidChangeNotification
    			object:nil];
        }
        return self;
}

- (void)setMailView:(CPView)aMailView
{
    [messageController setMailView:aMailView];
}

- (void)setSearchView:(CPView)aSearchView
{
    [searchController setSearchView:aSearchView];
}

- (void)setProjectView:(CPView)aProjectView
{
    [searchController setProjectView:aProjectView];
}

- (void)setContentViewController:(id)contentViewController
{
    [searchController setContentViewController:contentViewController];
}

@end

@implementation OLCommunityController (SidebarItem)

- (CPString)sidebarName
{
    return @"Community";
}

- (CPArray)sidebarItems
{
    return [OLCommunityInboxItem, OLCommunitySearchItem];
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
            view = [messageController contentView];
            break;
        case OLCommunitySearchItem:
            view = [searchController contentView];
            [searchController reloadData];
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
            object:[OLMenuItemNewLanguage, OLMenuItemDeleteLanguage, OLMenuItemDownload]];
	    [self setSelectedItem:item];
	}
	else
	{
	    [self setSelectedItem:nil];
	}
}

@end