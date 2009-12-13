@import <Foundation/CPObject.j>

@import "../Views/OLResourcesView.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";

@implementation OLResourceController : CPObject
{
    CPArray         resources;
    OLResource      selectedResource    @accessors;
    OLResourcesView resourcesView       @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        resources = [CPArray array];
    }
    return self;
}

@end

@implementation OLResourceController (OLResourceBundleControllerKVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"selectedProject":
            resources = [[object selectedProject] resources];
			[[resourcesView resourceTableView] reloadData];
			[[resourcesView resourceTableView] selectRowIndexes:[CPIndexSet indexSetWithIndex:-1] byExtendingSelection:NO];
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
    }
    
    [self setSelectedResource:selectedResource];
}

@end
