@import <Foundation/CPObject.j>
@import "../Controllers/OLResourceBundleController.j"

@implementation OLTransitionManager : CPObject
{
	id _delegate @accessors(property=delegate);
	CPDictionary _controllers;
}

- (id)init
{
	if(self = [super init])
	{
		_controllers = [CPDictionary dictionary];
	}
	return self;
}

- (void)transitionToResourcesView
{
	var key = [OLResourceBundleController class];
	if(![[_controllers allKeys] containsObject:key])
	{
		[_controllers setValue:[[OLResourceBundleController alloc] init] forKey:key];
	}
	[_delegate setContentController:[_controllers valueForKey:key]];
}

@end
