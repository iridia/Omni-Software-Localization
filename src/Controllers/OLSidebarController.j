@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@implementation OLSidebarController : CPObject
{
    CPArray                 sidebarItems;
    OLSidebarOutlineView    sidebarOutlineView;
    
    @outlet                 CPScrollView                sidebarScrollView;
}

- (void)awakeFromCib
{
    sidebarItems = [CPArray array];
    
    // Autohide the scrollers here and not in the Cib because it is impossible to
    // select the scrollView in Atlas again otherwise.
    [sidebarScrollView setAutohidesScrollers:YES];
    [sidebarScrollView setHasHorizontalScroller:NO];
    var onlyColumn = [[CPTableColumn alloc] initWithIdentifier:@"OnlyColumn"];
    [onlyColumn setWidth:CGRectGetWidth([sidebarScrollView bounds])];
    
    sidebarOutlineView = [[CPOutlineView alloc] initWithFrame:[sidebarScrollView bounds]];
    [sidebarOutlineView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [sidebarOutlineView addTableColumn:onlyColumn];
    [sidebarOutlineView setOutlineTableColumn:onlyColumn];
    [sidebarOutlineView setHeaderView:nil];
    [sidebarOutlineView setCornerView:nil];
    [sidebarOutlineView setDataSource:self];
    [sidebarOutlineView setDelegate:self];

    [sidebarScrollView setDocumentView:sidebarOutlineView];
}

- (void)addSidebarItem:(id)anItem
{
    [sidebarItems addObject:anItem];
    [sidebarOutlineView reloadData];
    if ([anItem respondsToSelector:@selector(shouldExpandSidebarItemOnReload)] && [anItem shouldExpandSidebarItemOnReload])
    {
        [sidebarOutlineView expandItem:anItem];
    }
}
@end

@implementation OLSidebarController (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    [sidebarOutlineView reloadData];
    
    if ([object respondsToSelector:@selector(shouldExpandSidebarItemOnReload)] && [object shouldExpandSidebarItemOnReload])
    {
        [sidebarOutlineView expandItem:object];
    }
}

@end

@implementation OLSidebarController (CPOutlineViewDataSource)

- (CPArray)childrenOfItem:(id)item
{
    if ([item respondsToSelector:@selector(sidebarItems)])
    {
        return [item sidebarItems];
    }
    return [CPArray array];
}

- (id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
    if (item === nil)
    {
        return [sidebarItems objectAtIndex:index];
    }
    else
    {
        var values = [self childrenOfItem:item];
        return [values objectAtIndex:index];
    }
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    var values = [self childrenOfItem:item];
    
    var isItemExpandable = ([values count] > 0);
    
    return isItemExpandable;
}

- (int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
    if (item === nil)
    {
        return [sidebarItems count];
    }
    else
    {
        var values = [self childrenOfItem:item];
        return [values count];
    }
}

- (id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
    if ([item respondsToSelector:@selector(sidebarName)])
    {
        return [item sidebarName];
    }
    else
    {
        return item;  
    }
}

@end
