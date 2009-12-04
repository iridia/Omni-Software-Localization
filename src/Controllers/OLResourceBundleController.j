@import <Foundation/CPObject.j>
@import "../models/OLResourceBundle.j"
@import "../Utilities/OLException.j"

/*!
 * The OLResourceBundleController is a controller for the resource bundle view and
 * the decisions on which data to send to the view is made here.
 */
@implementation OLResourceBundleController : CPObject
{
	id _delegate @accessors(property=delegate);
	CPArray _bundles @accessors(property=bundles);
	OLResourceBundle _editingBundle @accessors(property=editingBundle);
}

- (void)loadBundles
{
	try
	{
		[self setBundles:[OLResourceBundle list]];
	} catch (ex) {
		[OLException raise:"OLResourceBundleController" reason:"it couldn't load the bundles properly."];
	}
}

- (void)didSelectBundleAtIndex:(CPInteger)selectedIndex
{	
    [self setEditingBundle:[_bundles objectAtIndex:selectedIndex]];
}

- (void)didEditResourceForEditingBundle:(OLResource)editedResource
{
    [_editingBundle replaceObjectInResourcesAtIndex:0 withObject:editedResource];
    [_editingBundle save];
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
