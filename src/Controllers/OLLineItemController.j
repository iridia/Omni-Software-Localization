@import <Foundation/CPObject.j>

@import "OLLineItemEditWindowController.j"
@import "../Views/OLResourcesView.j"
@import "../Models/OLLineItem.j"

var OLResourceEditorViewIdentifierColumnHeader = @"OLResourceEditorViewIdentifierColumnHeader";
var OLResourceEditorViewValueColumnHeader = @"OLResourceEditorViewValueColumnHeader";

@implementation OLLineItemController : CPObject
{
	CPArray		    lineItems;
	OLLineItem      selectedLineItem    @accessors;
	OLResourcesView resourcesView       @accessors;
}

- (id)init
{
	if(self = [super init])
	{
	    lineItems = [CPArray array];
	    
    	[[CPNotificationCenter defaultCenter]
    	    addObserver:self
    	    selector:@selector(didReceiveProjectDidChangeNotification:)
    	    name:@"OLProjectDidChangeNotification"
    	    object:nil];
	}
	return self;
}

- (void)editSelectedLineItem:(id)sender
{
    var lineItemEditWindowController = [[OLLineItemEditWindowController alloc] initWithWindowCibName:@"LineItemEditor.cib" lineItem:selectedLineItem];
    [lineItemEditWindowController setDelegate:self];
    [self addObserver:lineItemEditWindowController forKeyPath:@"selectedLineItem" options:CPKeyValueObservingOptionNew context:nil];
    [lineItemEditWindowController loadWindow];
}

- (void)nextLineItem
{
    var currentIndex = [lineItems indexOfObject:selectedLineItem];
    var nextIndex = currentIndex + 1;
    
    if (nextIndex >= [lineItems count])
    {
        nextIndex = 0;
    }

    [self setSelectedLineItem:[lineItems objectAtIndex:nextIndex]];
    [[[resourcesView editingView] lineItemsTableView] selectRowIndexes:[CPIndexSet indexSetWithIndex:nextIndex] byExtendingSelection:NO];
}

- (void)previousLineItem
{
    var currentIndex = [lineItems indexOfObject:selectedLineItem];
    var previousIndex = currentIndex - 1;
    
    if (previousIndex < 0)
    {
        previousIndex = [lineItems count] - 1;
    }

    [self setSelectedLineItem:[lineItems objectAtIndex:previousIndex]];
    [[[resourcesView editingView] lineItemsTableView] selectRowIndexes:[CPIndexSet indexSetWithIndex:previousIndex] byExtendingSelection:NO];
}

- (void)didReceiveProjectDidChangeNotification:(CPNotification)notification
{
    [[[resourcesView editingView] lineItemsTableView] reloadData];
}

@end

@implementation OLLineItemController (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"selectedResource":
            var selectedResource = [object selectedResource];
            if (selectedResource)
            {
                lineItems = [[object selectedResource] lineItems];
                [[[resourcesView editingView] lineItemsTableView] reloadData];
                [resourcesView showLineItemsTableView];
    			[resourcesView setVoteCount:[selectedResource numberOfVotes]];
            }
            else
            {
                [resourcesView hideLineItemsTableView];
            }
            [[[resourcesView editingView] lineItemsTableView] selectRowIndexes:[CPIndexSet indexSetWithIndex:-1] byExtendingSelection:NO];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end

@implementation OLLineItemController (OLLineItemsTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [lineItems count];
}

- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    if ([tableColumn identifier] === OLResourceEditorViewIdentifierColumnHeader)
    {
        return [[lineItems objectAtIndex:row] identifier];
    }
    else if ([tableColumn identifier] === OLResourceEditorViewValueColumnHeader)
    {
        return [[lineItems objectAtIndex:row] value];
    }
}


@end

@implementation OLLineItemController (OLLineItemsTableViewDelegate)

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var tableView = [aNotification object];
    
    var selectedRow = [[tableView selectedRowIndexes] firstIndex];
    
    [self setSelectedLineItem:[lineItems objectAtIndex:selectedRow]];
}

@end
