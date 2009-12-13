@import <Foundation/CPObject.j>

@import "../Views/OLResourcesView.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";

@implementation OLResourceController : CPObject
{
    CPArray         resources;
    OLResourcesView resourcesView   @accessors(readonly);
}

- (id)init
{
    if(self = [super init])
    {
        resources = [CPArray array];
        
        resourcesView = [[OLResourcesView alloc] initWithFrame:[[[CPApp delegate] mainContentView] bounds]];
        [resourcesView setResourceController:self];
    }
    return self;
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

