@import <Foundation/CPObject.j>

@implementation OLSidebarController : CPObject
{
	CPView _sidebarView @accessors(property=sidebarView);
	id _delegate @accessors(property=delegate);
}

- (void)showResourcesView
{
	[_delegate contentViewSendMessage:@selector(showResourcesView)];
}

@end
