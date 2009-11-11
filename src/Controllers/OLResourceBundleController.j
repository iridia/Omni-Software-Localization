@import <Foundation/CPObject.j>
@import "../models/OLResourceBundle.j"

/*!
 * The OLResourceBundleController is a controller for the resource bundle view and
 * the decisions on which data to send to the view is made here.
 */
@implementation OLResourceBundleController : CPObject
{
	id _delegate @accessors(property=delegate);
	CPArray _bundles @accessors(property=bundles);
	CPInteger _editingBundle @accessors(property=editingBundle);
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _bundles = nil;
        _delegate = nil;
        _editingBundle = nil;
    }
    
    return self;
}

- (void)loadBundles
{
	[self setBundles:[OLResourceBundle list]];
}

- (void)didSelectBundleAtIndex:(CPInteger)selectedIndex
{
	[_delegate handleMessage:@selector(showResourceView)];
	
    [self setEditingBundle:[_bundles objectAtIndex:selectedIndex]];
}

- (void)didEditResourceForEditingBundle:(OLResource)editedResource
{
    [_editingBundle replaceObjectInResourcesAtIndex:0 withObject:editedResource];
    [_editingBundle save];
}

@end
