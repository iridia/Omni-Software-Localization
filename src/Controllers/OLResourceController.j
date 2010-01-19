@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Views/OLResourcesView.j"
@import "../Models/OLResource.j"

@import "OLLineItemController.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";

@implementation OLResourceController : CPObject
{
    CPArray         resources;
    OLResource      selectedResource    @accessors;
    OLResourcesView resourcesView       @accessors;
	CPString        ownerId             @accessors;
	
	OLLineItemController    lineItemController;
}

- (id)init
{
    if(self = [super init])
    {
        resources = [CPArray array];
        
        lineItemController = [[OLLineItemController alloc] init];
    	[self addObserver:lineItemController forKeyPath:@"selectedResource" options:CPKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (int)numberOfLineItems
{
    return [[selectedResource lineItems] count];
}

- (OLLineItem)lineItemAtIndex:(int)index
{
    return [[selectedResource lineItems] objectAtIndex:index];
}

- (void)selectLineItemAtIndex:(int)index
{
    [lineItemController selectLineItemAtIndex:index];
}

- (void)editSelectedLineItem
{
    [lineItemController editSelectedLineItem];
}

- (void)selectResourceAtIndex:(int)index
{
    if (index === CPNotFound)
    {
        [self setSelectedResource:nil];
    }
    else
    {
        [self setSelectedResource:[resources objectAtIndex:index]];
    }
}

- (void)voteUp:(id)sender
{
    var user = [[OLUserSessionManager defaultSessionManager] user];
    [selectedResource voteUp:user];
    [resourcesView setVoteCount:[[self selectedResource] numberOfVotes]];

    [[CPNotificationCenter defaultCenter]
        postNotificationName:@"OLProjectDidChangeNotification"
        object:self];
}

- (void)voteDown:(id)sender
{
    var user = [[OLUserSessionManager defaultSessionManager] user];
    [selectedResource voteDown:user];
    [resourcesView setVoteCount:[[self selectedResource] numberOfVotes]];

    [[CPNotificationCenter defaultCenter]
        postNotificationName:@"OLProjectDidChangeNotification"
        object:self];
}

@end

@implementation OLResourceController (OLResourceBundleControllerKVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"selectedResourceBundle":
            ownerId = [object ownerId];
            resources = [[object selectedResourceBundle] resources];
			[[resourcesView resourceTableView] reloadData];
            [[resourcesView resourceTableView] selectRowIndexes:[CPIndexSet indexSet] byExtendingSelection:NO];
            [self setSelectedResource:nil];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end

@implementation OLResourceController (OLResourcesTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [resources count];
}

- (id)tableView:(CPTableView)resourceTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    var resource = [resources objectAtIndex:row];
    
    if ([tableColumn identifier] === OLResourcesViewFileNameColumn)
    {
        return [resource fileName];
    }
}

@end

@implementation OLResourceController (OLResourcesTableViewDelegate)

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var tableView = [aNotification object];
    
    var selectedRow = [[tableView selectedRowIndexes] firstIndex];
    
    var selectedResource = nil;
    
    if (selectedRow >= 0)
    {
        selectedResource = [resources objectAtIndex:selectedRow];
        [resourcesView setVoteCount:[[self selectedResource] numberOfVotes]];
    }
    
    [self setSelectedResource:selectedResource];
}

@end
