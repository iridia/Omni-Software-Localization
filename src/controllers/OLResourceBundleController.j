@import <Foundation/CPObject.j>
@import "../models/OLResourceBundle.j"

/*!
 * The OLResourceBundleController is a controller for the resource bundle view and
 * the decisions on which data to send to the view is made here.
 */
@implementation OLResourceBundleController : CPObject
{
	id _delegate @accessors(property=delegate);
	OLResourceBundle _bundle @accessors(property=bundle); //, readonly);
	CPArray _resources @accessors(property=resources);
}

- (void)loadBundles
{
	[self setResources:[OLResourceBundle list]];
}

- (void)doubleClickedResource:(OLResource)aResource
{
	[_delegate switchToBundleView:self];
	[self setBundle:aResource];//[[OLResourceBundle alloc] initWithResources:new Array(aResource) language:[OLLanguage english]]];
}

@end
