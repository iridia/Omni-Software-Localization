@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "../Models/OLMessage.j"
@import "OLProjectSearchController.j"

var OLMailViewFromUserIDColumnHeader = @"OLMailViewFromUserIDColumnHeader";
var OLMailViewSubjectColumnHeader = @"OLMailViewSubjectColumnHeader";
var OLMailViewDateSentColumnHeader = @"OLMailViewDateSentColumnHeader";

var OLCommunityInboxItem = @"Inbox";
var OLCommunitySearchItem = @"Search";

// Manages an array of community items (Mailbox)
@implementation OLCommunityController : CPObject
{
    CPArray                     messages    	    @accessors;
	OLMessage	                selectedItem    	@accessors;
	OLMailView                  mailView            @accessors;
	OLProjectSearchView         searchView          @accessors(readonly);
	OLProjectSearchController   searchController;
	OLResourcesView             resourcesView       @accessors;
	id                          contentViewController   @accessors;
}

- (id)init
    {
        if(self = [super init])
        {        
    		messages = [CPArray array];

    		[[CPNotificationCenter defaultCenter]
    			addObserver:self
    			selector:@selector(didReceiveOutlineViewSelectionDidChangeNotification:)
    			name:CPOutlineViewSelectionDidChangeNotification
    			object:nil];
    			
    	    [[CPNotificationCenter defaultCenter]
        		addObserver:self
        		selector:@selector(newMessageCreated:)
        		name:@"OLMessageCreatedNotification"
        		object:nil];
        		
        	searchController = [[OLProjectSearchController alloc] init];
        	[searchController loadProjects];
        }
        return self;
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
            object:[OLMenuItemNewLanguage, OLMenuItemDeleteLanguage]];
	    [self setSelectedItem:item];
	}
	else
	{
	    [self setSelectedItem:nil];
	}
}

- (void)setSearchView:(CPView)aSearchView
{
    if (searchView === aSearchView)
        return;
    
    searchView = aSearchView;
    [searchView setDataSource:searchController];
    [searchView setDelegate:self];
}

- (void)newMessageCreated:(CPNotification)notification
{
    [self addMessage: [notification object]];
    [[[mailView mailView] messageTableView] reloadData];
}

- (void)loadMessages
{
    [OLMessage listWithCallback:function(message){[self addMessage:message];}];
}

- (void)addMessage:(OLMessage)message
{
    [self insertObject:message inMessagesAtIndex:[messages count]];
}

- (void)insertObject:(OLMessage)message inMessagesAtIndex:(int)index
{
    [messages insertObject:message atIndex:index];
}

@end

@implementation OLCommunityController (OLCommunityTableViewDelegate)

- (void)tableViewSelectionDidChange:(CPTableView)aTableView
{
    var tableView = [[mailView mailView] messageTableView];
    if (aTableView === tableView)
    {
        var selectedRow = [[tableView selectedRowIndexes] firstIndex];
        var textToDisplay = @"";
    
        if (selectedRow >= 0 )
        {
           textToDisplay = [[messages objectAtIndex:selectedRow] content];
        }
   
        [[[[mailView mailView] messageDetailView] content] setStringValue:textToDisplay];
        [[mailView mailView] showMessageDetailView];
    }
}

@end

@implementation OLCommunityController (OLCommunityTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)mailTableView
{
    return [messages count];//Needs to be the number of mail items in the DB for the user.
}

- (id)tableView:(CPTableView)mailTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    var message = [messages objectAtIndex:row];
    
    if ([tableColumn identifier] === OLMailViewFromUserIDColumnHeader)
    {
       return [message fromUserID];
    }
    else if ([tableColumn identifier] === OLMailViewSubjectColumnHeader)
    {
        return [message subject];
    }
    else if ([tableColumn identifier] === OLMailViewDateSentColumnHeader)
    {
        return [message dateSent];
    }
}

- (void)tableViewDidDoubleClickItem:(CPTableView)aTableView
{
    var selectedRow = [[aTableView selectedRowIndexes] firstIndex];

    if (selectedRow < 0)
    {
        return;
    }
    
    var projectName = [[searchController projectAtIndex:selectedRow] name];

    var resourceBundleController = [[OLResourceBundleController alloc] init];
    
	var resourceController = [[OLResourceController alloc] init];
    [resourceBundleController addObserver:resourceController forKeyPath:@"selectedResourceBundle" options:CPKeyValueObservingOptionNew context:nil];
	
	var lineItemController = [[OLLineItemController alloc] init];
	[resourceController addObserver:lineItemController forKeyPath:@"selectedResource" options:CPKeyValueObservingOptionNew context:nil];

    [resourcesView setResourceController:resourceController];
    [resourcesView setLineItemController:lineItemController];
    [resourcesView setResourceBundleController:resourceBundleController];
    [[resourcesView editingView] setVoteTarget:resourceController downAction:@selector(voteDown:) upAction:@selector(voteUp:)];
    [resourcesView showBackButton];
    [resourcesView setBackButtonTitle:@"Back"];
    [resourcesView setBackButtonTarget:self];
    [resourcesView setBackButtonAction:@selector(back:)]
    
    [resourceController setResourcesView:resourcesView];
    [resourceBundleController setResourcesView:resourcesView];
    [lineItemController setResourcesView:resourcesView];
    
    var project = [OLProject findByName:projectName callback:function(project){
        [resourceBundleController observeValueForKeyPath:@"selectedProject" ofObject:[[StupidClassWeWillDeleteRightAwayThatMimicsOLProjectController alloc] initWithSelectedProject:project] change:nil context:nil];
        [contentViewController setCurrentView:resourcesView];
    }];
}

- (void)back:(id)sender
{
    [contentViewController setCurrentView:searchView];
    [searchView setDelegate:self];
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

- (CPView)contentView
{
    var view;
    switch(selectedItem)
    {
        case OLCommunityInboxItem:
            [[[mailView mailView] messageTableView] reloadData];
            view = mailView;
            break;
        case OLCommunitySearchItem:
            [searchView reloadData];
            [searchView setDelegate:self];
            view = searchView;
            break;
        default:
            CPLog.warn(@"Unhandled case in %s, %s", [self className], _cmd);
            break;
    }
    
    return view;
}

@end

@implementation StupidClassWeWillDeleteRightAwayThatMimicsOLProjectController : CPObject
{
    OLProject selectedProject   @accessors;
}

- (id)initWithSelectedProject:(OLProject)aProject
{
    if (self = [super init])
    {
        selectedProject = aProject;
    }
    return self;
}

@end