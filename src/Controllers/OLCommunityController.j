@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "../Models/OLMessage.j"

var OLMailViewFromUserIDColumnHeader = @"OLMailViewFromUserIDColumnHeader";
var OLMailViewSubjectColumnHeader = @"OLMailViewSubjectColumnHeader";
var OLMailViewDateSentColumnHeader = @"OLMailViewDateSentColumnHeader";

// Manages an array of community items (Mailbox)
@implementation OLCommunityController : CPObject
{
    CPMutableArray      messages    	    @accessors;
	OLMessage	        selectedItem    	@accessors;
	CPView              mailView            @accessors;
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
	    [self setSelectedItem:item];
        [[[mailView mailView] messageTableView] reloadData];
	}
	else
	{
	    [self setSelectedItem:nil];
	}
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
    var selectedRow = [[tableView selectedRowIndexes] firstIndex];
    var textToDisplay = @"";
    
    if (selectedRow >= 0 )
    {
       textToDisplay = [[messages objectAtIndex:selectedRow] content];
    }
   
    [[[[mailView mailView] messageDetailView] content] setStringValue:textToDisplay];
    [[mailView mailView] showMessageDetailView];
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

@end

@implementation OLCommunityController (SidebarItem)

- (CPString)sidebarName
{
    return @"Community";
}

- (CPArray)sidebarItems
{
    return [@"Inbox"];
}

- (CPView)contentView
{
    return mailView;
}

@end