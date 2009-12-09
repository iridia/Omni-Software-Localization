@import <Foundation/CPObject.j>

@import "../Views/OLSidebarOutlineView.j"

@implementation OLSidebarController : CPObject
{
    CPOutlineView   _sidebarOutlineView;
    CPDictionary    _items;
    CPString        _currentItem;

    id              _delegate           @accessors(property=delegate);

    @outlet         CPScrollView        sidebarScrollView;
}

- (void)awakeFromCib
{
    console.log(_cmd, sidebarScrollView, self);
    _items = [CPDictionary dictionaryWithObjects:[[@"glossary 1"], [@"proj 1", @"proj 2", @"proj 3"]] forKeys:[@"Glossaries", @"Projects"]];
    
    _sidebarOutlineView = [[OLSidebarOutlineView alloc] initWithFrame:[sidebarScrollView bounds]];
    [_sidebarOutlineView setDataSource:self];

    [sidebarScrollView setDocumentView:_sidebarOutlineView];
}

- (void)handleMessage:(SEL)aMessage
{
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
