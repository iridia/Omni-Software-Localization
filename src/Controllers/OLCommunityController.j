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
	
	OLProjectSearchController   searchController;
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

@implementation OLCommunityController (OLCommunityTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)mailTableView
{
    var result = 0;
    
    for(var i = 0; i < [messages count]; i++)
    {
        if([[messages objectAtIndex:i] toUserID] === [[[OLUserSessionManager defaultSessionManager] user] email])
        {
            result++;
        }
    }
    
    return result;//Needs to be the number of mail items in the DB for the user.
}

- (id)tableView:(CPTableView)mailTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    var message = [messages objectAtIndex:row];
    
    if([message toUserID] === [[[OLUserSessionManager defaultSessionManager] user] email])
    {
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
            object:[OLMenuItemNewLanguage, OLMenuItemDeleteLanguage]];
	    [self setSelectedItem:item];
	}
	else
	{
	    [self setSelectedItem:nil];
	}
}

@end