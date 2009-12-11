@import <Foundation/CPObject.j>

@import "OLProjectController.j"
@import "../Views/OLSidebarOutlineView.j"

@implementation OLSidebarController : CPObject
{
    CPDictionary            _items;
    CPString                _currentItem;
    OLProjectController     _projectController;
    OLSidebarOutlineView    sidebarOutlineView;

    @outlet         CPScrollView                sidebarScrollView;
    @outlet         OLResourceBundleController  resourceBundleController;

    id              _delegate                   @accessors(property=delegate);
}

- (void)awakeFromCib
{
    _items = [CPDictionary dictionary];

    [self updateResourcesWithResourceBundles:[resourceBundleController bundles]];
    [resourceBundleController addObserver:self forKeyPath:@"bundles" options:CPKeyValueObservingOptionNew context:nil];
    
    _projectController = [[OLProjectController alloc] init];
    [self updateProjectsWithProjects:[_projectController projects]];
    [_projectController addObserver:self forKeyPath:@"projects" options:CPKeyValueObservingOptionNew context:nil];
    
    // Autohide the scrollers here and not in the Cib because it is impossible to
    // select the scrollView in Atlas again otherwise.
    [sidebarScrollView setAutohidesScrollers:YES];
    [sidebarScrollView setHasHorizontalScroller:NO];
    
    sidebarOutlineView = [[OLSidebarOutlineView alloc] initWithFrame:[sidebarScrollView bounds]];
    [sidebarOutlineView setDataSource:self];
    [sidebarOutlineView setDelegate:self];

    [sidebarScrollView setDocumentView:sidebarOutlineView];
}

- (void)updateResourcesWithResourceBundles:(CPArray)resourceBundles
{
    // var resources = [];
    // 
    // for (var i = 0; i < [resourceBundles count]; i++)
    // {
    //     var resourceBundle = [resourceBundles objectAtIndex:i];
    //     
    //     [resources addObject:[[[resourceBundle resources] objectAtIndex:0] fileName]];
    // }
    
    [_items setObject:resourceBundles forKey:@"Resources"];
}

- (void)updateProjectsWithProjects:(CPArray)projects
{
    [_items setObject:projects forKey:@"Projects"];
}

- (void)handleMessage:(SEL)aMessage
{
    console.log(aMessage);
	objj_msgSend(_sidebarView, aMessage);
}

- (void)showResourcesView
{
	[_delegate showResourcesView];
}

@end

@implementation OLSidebarController (OLResourceBundleControllerKVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    console.log(_cmd, object, change, context);
    switch (keyPath)
    {
        case @"bundles":
            alert("CHANGED");
            [self updateResourcesWithResourceBundles:[object bundles]];
            break;
        case @"projects":
            console.log(_cmd, object);
            [self updateProjectsWithProjects:[object projects]];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
    
    [sidebarOutlineView reloadData];
}

@end

@implementation OLSidebarController (CPOutlineViewDataSource)

- (id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
    if (item === nil)
    {
        var keys = [_items allKeys];
        return [keys objectAtIndex:index];
    }
    else
    {
        var values = [_items objectForKey:item];
        return [values objectAtIndex:index];
    }
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    var values = [_items objectForKey:item];
    
    var isItemExpandable = ([values count] > 0);
    
    return isItemExpandable;
}

- (int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
    if (item === nil)
    {
        return [_items count];
    }
    else
    {
        var values = [_items objectForKey:item];
        return [values count];
    }
}

- (id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
    if ([item isKindOfClass:[OLProject class]])
    {
        return [item name];
    }
    else if ([item isKindOfClass:[OLResourceBundle class]])
    {
        return [[[item resources] objectAtIndex:0] fileName];
    }
    else
    {
        return item;  
    }
}

@end

@implementation OLSidebarController (CPOutlineViewDelegate)

- (void)outlineViewSelectionDidChange:(CPNotification)notification
{
    var outlineView = [notification object];
    
    var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
    var item = [outlineView itemAtRow:selectedRow];
    
    var parent = [outlineView parentForItem:item];
    
    if (parent === @"Resources")
    {
        [self showResourcesView];
    }
}

@end
