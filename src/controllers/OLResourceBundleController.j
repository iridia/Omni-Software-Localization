@import <Foundation/CPObject.j>
@import "../models/OLResourceBundle.j"

/*!
 * The OLResourceBundleController is a controller for the resource bundle view and
 * the decisions on which data to send to the view is made here.
 */
@implementation OLResourceBundleController : CPObject
{
	OLResourceBundle _bundle @accessors(property=bundle); //, readonly);
}

@end
