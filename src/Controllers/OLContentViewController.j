@import <Foundation/CPObject.j>

@implementation OLContentViewController : CPObject
{
	id _contentController @accessors(property=contentController);
	id _transitionManager @accessors(property=transitionManager);
}

- (void)handleMessage:(SEL)aMessage
{
	objj_msgSend(_transitionManager, aMessage);
}

@end
