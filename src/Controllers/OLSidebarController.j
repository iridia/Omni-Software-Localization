@import <Foundation/CPObject.j>

@import "../Views/OLSidebarOutlineView.j"

@implementation OLSidebarController : CPObject
{
    CPOutlineView   _sidebarOutlineView @accessors(property=sidebarOutlineView, readonly);
    CPDictionary    _items              @accessors(property=items, readonly);
	CPString        _currentItem;
	
	id              _delegate           @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)aRect
{
	if (self = [super init])
	{
        _items = [CPDictionary dictionaryWithObjects:[[@"glossary 1"], [@"proj 1", @"proj 2", @"proj 3"]] forKeys:[@"Glossaries", @"Projects"]];
        _sidebarOutlineView = [[OLSidebarOutlineView alloc] initWithFrame:aRect];
        [_sidebarOutlineView setDataSource:self];
	}
	return self;
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
    CPLog("outlineView:%@ child:%@ ofItem:%@", outlineView, index, item);

    if (item === nil)
    {
        var keys = [_items allKeys];
        console.log([keys objectAtIndex:index]);
        return [keys objectAtIndex:index];
    }
    else
    {
        var values = [_items objectForKey:item];
        console.log(values);
        return "blah";
    }
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    CPLog("outlineView:%@ isItemExpandable:%@", outlineView, item);
    
    var values = [_items objectForKey:item];
    console.log(([values count] > 0));
    return ([values count] > 0);
}

- (int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
    CPLog("outlineView:%@ numberOfChildrenOfItem:%@", outlineView, item);

    if (item === nil)
    {
        console.log([_items count]);
        return [_items count];
    }
    else
    {
        var values = [_items objectForKey:item];
        console.log([values count]);
        return [values count];
    }
}

- (id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
    CPLog("outlineView:%@ objectValueForTableColumn:%@ byItem:%@", outlineView, tableColumn, item);

    console.log(item);
    return item;   
}

@end
