@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "../Models/OLMessage.j"

var OLMailViewIdentifierColumnHeader = @"OLMailViewIdentifierColumnHeader";
var OLMailViewValueColumnHeader = @"OLMailViewValueColumnHeader";

// Manages an array of glossaries
@implementation OLCommunityController : CPObject
{
    CPArray             items        	    @accessors;
	OLMessage	        selectedItem    	@accessors;
	OLMailView          mailView            @accessors;
}

- (id)init
    {
        if(self = [super init])
        {        
    		items = [CPArray array];

    		[[CPNotificationCenter defaultCenter]
    			addObserver:self
    			selector:@selector(didReceiveOutlineViewSelectionDidChangeNotification:)
    			name:CPOutlineViewSelectionDidChangeNotification
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

	if (parent === @"Community")
	{
	    [self setSelectedItem:item];
        // [[[self mailView] tableView] reloadData];
	}
	else
	{
	    [self setSelectedItem:nil];
	}
}
@end

@implementation OLCommunityController (OLCommunityTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)mailTableView
{
    return 1;//Needs to be the number of mail items in the DB for the user.
}

- (id)tableView:(CPTableView)mailTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    //Needs to set the values from the message passed in.
    // var message = [[[selectedCommunitItem lineItems] objectAtIndex:row];]
    //    
    //        if ([tableColumn identifier] === OLMailViewFromColumnHeader)
    //        {
    //            return [message fromUserID];
    //        }
    //        else if ([tableColumn identifier] === OLMailViewSubjectColumnHeader)
    //        {
    //            return [message subject];
    //        }
    //        else if ([tableColumn identifier] === OLMailViewDateColumnHeader)
    //        {
    //            return ;
    //        }
}

@end
