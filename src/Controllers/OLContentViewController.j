@import <Foundation/CPObject.j>

@implementation OLContentViewController : CPObject
{
	id _contentController @accessors(property=contentController);
	id _transitionManager @accessors(property=transitionManager);
	id _delegate @accessors(property=delegate);
}

- (void)handleMessage:(SEL)aMessage
{
	objj_msgSend(_transitionManager, aMessage);
}

- (void)showView:(CPView)aView
{
	[_delegate setContentView:aView];
}

@end
