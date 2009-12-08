@import <Foundation/CPObject.j>
@import "../Controllers/OLResourceBundleController.j"
@import "../Views/OLResourcesView.j"

@implementation OLTransitionManager : CPObject
{
	id _delegate @accessors(property=delegate);
	CPDictionary _controllers;
	CGRect _frame;
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super init])
	{
		_controllers = [CPDictionary dictionary];
		_frame = frame;
	}
	return self;
}

- (void)showResourcesView
{
    var key = [OLResourceBundleController class];
    if(![[_controllers allKeys] containsObject:key])
    {
        [_controllers setValue:[[OLResourceBundleController alloc] init] forKey:key];
    }
    
    var resourceBundleController = [_controllers valueForKey:key];
    [resourceBundleController setDelegate:_delegate];
     
    [_delegate setContentController:resourceBundleController];
    
    [_delegate showView:[resourceBundleController view]];

    // [resourceBundleController loadBundles];
}

@end
