@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@implementation OLSidebarOutlineView : CPOutlineView
{
    CPArray                 sidebarItems; 
}
- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
	{
	    
	    var onlyColumn = [[CPTableColumn alloc] initWithIdentifier:@"OnlyColumn"];
        [onlyColumn setWidth:CGRectGetWidth(aFrame)];
        [onlyColumn setDataView:[[OLSidebarViewItem alloc] initWithFrame:CGRectMakeZero()]];
        
        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [self addTableColumn:onlyColumn];
        [self setOutlineTableColumn:onlyColumn];
        // [sidebarOutlineView setHeaderView:nil];
        [self setCornerView:nil];
        [self setDataSource:self];
        [self setDelegate:self];
        [self setBackgroundColor:[CPColor sourceViewColor]];
        [self setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
    }
    return self;
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

@implementation OLSidebarOutlineView (CPOutlineViewDataSource)

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
    var objectValue = item;
    
    if ([item respondsToSelector:@selector(sidebarName)])
    {
        objectValue = [item sidebarName];
    }
    
    return objectValue;
}

@end
