@import <Foundation/CPObject.j>
@import "../Controllers/OLResourceBundleController.j"
@import "../Views/OLResourcesView.j"
@import "../Views/OLResourceEditorView.j"

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
	
	var view = [[OLResourcesView alloc] initWithFrame:_frame];
	[view setDelegate:[_controllers valueForKey:key]];
	[_delegate showView:view];
	
	[resourceBundleController addObserver:view forKeyPath:@"bundles" options:CPKeyValueObservingOptionNew context:nil];
	[resourceBundleController loadBundles];
}

- (void)showResourceView
{
	var key = [OLResourceBundleController class];
	if(![[_controllers allKeys] containsObject:key])
	{
		[_controllers setValue:[[OLResourceBundleController alloc] init] forKey:key];
	}
	
	var resourceBundleController = [_controllers valueForKey:key];
	
	var resourceEditorView = [[OLResourceEditorView alloc] initWithFrame:_frame];
	[resourceBundleController addObserver:resourceEditorView forKeyPath:@"editingBundle" options:CPKeyValueObservingOptionNew context:nil];
    [resourceBundleController addObserver:resourceEditorView forKeyPath:@"editingBundle.resources" options:CPKeyValueObservingOptionNew context:nil];
	[resourceEditorView setDelegate:resourceBundleController];

	[_delegate showView:resourceEditorView];
}

@end