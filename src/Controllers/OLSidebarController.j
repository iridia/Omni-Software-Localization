@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@implementation OLSidebarController : CPObject
{
    CPArray                 sidebarItems;
    OLSidebarOutlineView    sidebarOutlineView;
    
    @outlet                 CPScrollView                sidebarScrollView;
    @outlet                 CPButtonBar                 sidebarButtonBar;
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
    [onlyColumn setDataView:[[OLSidebarViewItem alloc] initWithFrame:CGRectMakeZero()]];
    
    sidebarOutlineView = [[CPOutlineView alloc] initWithFrame:[sidebarScrollView bounds]];
    [sidebarOutlineView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [sidebarOutlineView addTableColumn:onlyColumn];
    [sidebarOutlineView setOutlineTableColumn:onlyColumn];
    // [sidebarOutlineView setHeaderView:nil];
    [sidebarOutlineView setCornerView:nil];
    [sidebarOutlineView setDataSource:self];
    [sidebarOutlineView setDelegate:self];
    [sidebarOutlineView setTag:@"sidebar"];
    [sidebarOutlineView setBackgroundColor:[CPColor sourceViewColor]];
    [sidebarOutlineView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];

    [sidebarScrollView setDocumentView:sidebarOutlineView];
}

- (void)outlineView:(CPOutlineView)anOutlineView shouldSelectRow:(CPNumber)row
{
    return [anOutlineView levelForRow:row] > 0;
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
    var objectValue = item;
    
    if ([item respondsToSelector:@selector(sidebarName)])
    {
        objectValue = [item sidebarName];
    }
    
    return objectValue;
}

@end


@implementation OLSidebarController (CPSplitViewDelegate)

- (CGFloat)splitView:(CPSplitView)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(int)dividerIndex
{    
    return proposedMin + 150.0;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(int)dividerIndex
{
    return 350.0;
}

// Additional rect for CPButtonBar's handles
- (CGRect)splitView:(CPSplitView)splitView additionalEffectiveRectOfDividerAtIndex:(int)dividerIndex
{
    var rect = [sidebarButtonBar frame];
    var additionalWidth = 20.0;
    var additionalRect = CGRectMake(rect.origin.x + rect.size.width - additionalWidth, rect.origin.y, additionalWidth, rect.size.height);
    return additionalRect;
}

@end


@implementation OLSidebarViewItem : CPTextField

- (void)defaultSetup
{    
    [self setValue:CPTextTransformationStyleNormal forThemeAttribute:@"text-transformation-style"];
    
    [self setValue:[CPFont systemFontOfSize:12.0] forThemeAttribute:@"font"];
    [self setValue:[CPFont boldSystemFontOfSize:12.0] forThemeAttribute:@"font" inState:CPThemeStateSelected];
    [self setValue:[CPFont systemFontOfSize:12.0] forThemeAttribute:@"font" inState:CPThemeStateInactive];
    
    [self setValue:[CPColor colorWithHexString:@"333333"] forThemeAttribute:@"text-color"];
    [self setValue:[CPColor whiteColor] forThemeAttribute:@"text-color" inState:CPThemeStateSelected];
    [self setValue:[CPColor colorWithHexString:@"555555"] forThemeAttribute:@"text-color" inState:CPThemeStateInactive];
    
    [self setValue:[CPColor clearColor] forThemeAttribute:@"text-shadow-color"];
    [self setValue:[CPColor blackColor] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateSelected];
    [self setValue:[CPColor clearColor] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateInactive];
    
    [self setValue:CGSizeMake(0, 0) forThemeAttribute:@"text-shadow-offset"];
    [self setValue:CGSizeMake(0, 1) forThemeAttribute:@"text-shadow-offset" inState:CPThemeStateSelected];
    
    [self setVerticalAlignment:CPCenterVerticalTextAlignment];
}

- (void)setObjectValue:(id)anObjectValue
{
    if(anObjectValue === "Projects" || anObjectValue === "Glossaries" || anObjectValue === "Community")
    {
        [self setValue:CPTextTransformationStyleUppercase forThemeAttribute:@"text-transformation-style"];
        [self setValue:[CPFont boldSystemFontOfSize:11.0] forThemeAttribute:@"font"];
        [self setValue:[CPColor colorWithHexString:@"7988A2"] forThemeAttribute:@"text-color"];
        [self setValue:[CPColor whiteColor] forThemeAttribute:@"text-shadow-color"];
        [self setValue:CGSizeMake(0, 1) forThemeAttribute:@"text-shadow-offset"];
    }
    else
    {
        [self defaultSetup];
    }
    
    [self setValue:CPLineBreakByTruncatingTail forThemeAttribute:@"line-break-mode"];
    
    [super setObjectValue:anObjectValue];
}

@end