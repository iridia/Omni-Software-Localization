@import <Foundation/CPObject.j>

@import "../models/OLResourceBundle.j"
@import "../Utilities/OLException.j"

/*!
 * The OLResourceBundleController is a controller for the resource bundle view and
 * the decisions on which data to send to the view is made here.
 */
@implementation OLResourceBundleController : CPObject
{
	CPArray             resourceBundles     @accessors;
    // OLResourceBundle    _editingBundle      @accessors(property=editingBundle);
    // OLResource          _editingResource;
    
	id                  delegate            @accessors;
}

- (id)init
{
    if (self = [super init])
    {
        resourceBundles = [CPArray array];
    }
    return self;
}

- (void)voteUpResource:(OLResource)resource
{
    [resource voteUp];
}

- (void)voteDownResource:(OLResource)resource
{
    [resource voteDown];
}

@end
