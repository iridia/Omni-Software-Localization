@import <Foundation/CPObject.j>

@import "../Views/OLSidebarOutlineView.j"

@implementation OLSidebarController : CPObject
{
    CPDictionary    _items;
    CPString        _currentItem;

    @outlet         CPScrollView                sidebarScrollView;
    @outlet         OLResourceBundleController  resourceBundleController;

    id              _delegate                   @accessors(property=delegate);
}

- (void)awakeFromCib
{
    _items = [CPDictionary dictionary];

    [self updateResourcesWithResourceBundles:[resourceBundleController bundles]];

    [resourceBundleController addObserver:self forKeyPath:@"bundles" options:CPKeyValueObservingOptionNew context:nil];

    // Autohide the scrollers here and not in the Cib because it is impossible to
    // select the scrollView in Atlas again otherwise.
    [sidebarScrollView setAutohidesScrollers:YES];
    [sidebarScrollView setHasHorizontalScroller:NO];
    
    var sidebarOutlineView = [[OLSidebarOutlineView alloc] initWithFrame:[sidebarScrollView bounds]];
    [sidebarOutlineView setDataSource:self];
    [sidebarOutlineView setDelegate:self];

    [sidebarScrollView setDocumentView:sidebarOutlineView];
}

- (void)updateResourcesWithResourceBundles:(CPArray)resourceBundles
{
    var resources = [];
    
    for (var i = 0; i < [resourceBundles count]; i++)
    {
        var resourceBundle = [resourceBundles objectAtIndex:i];
        
        [resources addObject:[[[resourceBundle resources] objectAtIndex:0] fileName]];
    }
    
    [_items setObject:resources forKey:@"Resources"];
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
    if (keyPath === @"bundles")
    {
        alert("CHANGED");
        [self updateResourcesWithResourceBundles:[object bundles]];
    }
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
    return item;   
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
