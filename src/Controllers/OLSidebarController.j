@import <Foundation/CPObject.j>

var ResourcesItem = "Resources";

@implementation OLSidebarController : CPObject
{
	CPView _sidebarView @accessors(property=sidebarView);
	id _delegate @accessors(property=delegate);
	CPArray _items @accessors(property=items, readonly);
	CPString _currentItem;
}

- (id)init
{
	if(self = [super init])
	{
		_items = [CPArray arrayWithObject:ResourcesItem];
	}
	return self;
}

- (void)showResourcesView
{
	[_delegate contentViewSendMessage:@selector(showResourcesView)];
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
	var listIndex = [[aCollectionView selectionIndexes] firstIndex];
	    
	var item = [_items objectAtIndex:listIndex];
    
    if (item !== _currentApplication)
    {
        _currentItem = item;
		if (app == ResourcesItem)
		{
			[self showResourcesView];
		}
    }
}

@end
