@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@implementation OLSidebarController : CPObject
{
    CPDictionary            sidebarItems;
    OLSidebarOutlineView    sidebarOutlineView;
    
    @outlet                 CPScrollView                sidebarScrollView;
}

- (void)awakeFromCib
{
    sidebarItems = [CPDictionary dictionary];
    
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

- (void)setSidebarItems:(CPArray)someItems forKey:(CPString)aKey
{
    [sidebarItems setObject:someItems forKey:aKey];
    [sidebarOutlineView reloadData];
    [sidebarOutlineView expandItem:aKey];
}

@end

@implementation OLSidebarController (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    var itemsSelector = CPSelectorFromString(keyPath);
    if (![object respondsToSelector:itemsSelector])
    {
        CPLog.warn(@"%s: Cannot get items for: %s, in: %s", _cmd, keyPath, [self className]);
        return;
    }
    var items = [object performSelector:itemsSelector];
    
    var sidebarKey = [keyPath capitalizedString];
    if ([object respondsToSelector:@selector(sidebarKey)])
    {
        sidebarKey = [object sidebarKey];
    }
    
    [self setSidebarItems:items forKey:sidebarKey];
}

@end

@implementation OLSidebarController (CPOutlineViewDataSource)

- (id)outlineView:(CPOutlineView)outlineView child:(int)index ofItem:(id)item
{
    if (item === nil)
    {
        var keys = [sidebarItems allKeys];
        return [keys objectAtIndex:index];
    }
    else
    {
        var values = [sidebarItems objectForKey:item];
        return [values objectAtIndex:index];
    }
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    var values = [sidebarItems objectForKey:item];
    
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
        var values = [sidebarItems objectForKey:item];
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
