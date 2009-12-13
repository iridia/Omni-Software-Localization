@import <Foundation/CPObject.j>

@import "OLProjectController.j"
@import "../Views/OLSidebarOutlineView.j"

var OLSidebarProjectsKey = @"Projects";

@implementation OLSidebarController : CPObject
{
    CPDictionary            _items;
    CPString                _currentItem;
    OLSidebarOutlineView    sidebarOutlineView;

    @outlet         CPScrollView                sidebarScrollView;

    id              _delegate                   @accessors(property=delegate);
}

- (void)awakeFromCib
{
    _items = [CPDictionary dictionary];
    
    // Autohide the scrollers here and not in the Cib because it is impossible to
    // select the scrollView in Atlas again otherwise.
    [sidebarScrollView setAutohidesScrollers:YES];
    [sidebarScrollView setHasHorizontalScroller:NO];
    
    sidebarOutlineView = [[OLSidebarOutlineView alloc] initWithFrame:[sidebarScrollView bounds]];
    [sidebarOutlineView setDataSource:self];
    [sidebarOutlineView setDelegate:self];

    [sidebarScrollView setDocumentView:sidebarOutlineView];
    
    // Initially show all items as expanded
    var allTopLevelObjects = [_items allKeys];
    for (var i = 0; i < [allTopLevelObjects count]; i++)
    {
        [sidebarOutlineView expandItem:[allTopLevelObjects objectAtIndex:i]];
    }
}

- (void)updateProjectsWithProjects:(CPArray)projects
{
    [_items setObject:projects forKey:OLSidebarProjectsKey];
}

- (void)handleMessage:(SEL)aMessage
{
    console.log(aMessage);
	objj_msgSend(_sidebarView, aMessage);
}

@end

@implementation OLSidebarController (OLResourceBundleControllerKVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"bundles":
            [self updateResourcesWithResourceBundles:[object bundles]];
            break;
        case @"projects":
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
