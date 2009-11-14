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

    _currentItem = item;
	if (item == ResourcesItem)
	{
		[self showResourcesView];
	}
}

@end
