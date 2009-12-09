@import <Foundation/CPObject.j>

@import "../Views/OLSidebarOutlineView.j"

@implementation OLSidebarController : CPObject
{
    CPDictionary    _items;
    CPString        _currentItem;

    @outlet         CPScrollView        sidebarScrollView;

    id              _delegate           @accessors(property=delegate);
}

- (void)awakeFromCib
{
    _items = [CPDictionary dictionaryWithObjects:[[@"glossary 1"], [@"proj 1", @"proj 2", @"proj 3"]] forKeys:[@"Glossaries", @"Projects"]];
 
    // Autohide the scrollers here and not in the Cib because it is impossible to
    // select the scrollView in Atlas again otherwise.
    [sidebarScrollView setAutohidesScrollers:YES];
    [sidebarScrollView setHasHorizontalScroller:NO];
    
    var sidebarOutlineView = [[OLSidebarOutlineView alloc] initWithFrame:[sidebarScrollView bounds]];
    [sidebarOutlineView setDataSource:self];
    [sidebarOutlineView setDelegate:self];

    [sidebarScrollView setDocumentView:sidebarOutlineView];
}

- (void)handleMessage:(SEL)aMessage
{
    console.log(aMessage);
	console.log(_sidebarView);
	objj_msgSend(_sidebarView, aMessage);
}

- (void)showResourcesView
{
	[_delegate contentViewSendMessage:@selector(showResourcesView)];
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
	var listIndex = [[aCollectionView selectionIndexes] firstIndex];
	    
	var item = [_items objectAtIndex:listIndex];

    // If our selection didn't change, don't do anything.
    if (_currentItem !== item)
    {
        _currentItem = item;
	    if (item === ResourcesItem)
    	{
    		[self showResourcesView];
    	}
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
    return ([values count] > 0);
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
    
    CPLog("%@, %@", outlineView, [outlineView selectedRowIndexes]);
}

@end
