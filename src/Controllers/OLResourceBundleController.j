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
    OLResource _editingResource;
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

- (void)didEditResourceForEditingBundle
{
    [_editingBundle replaceObjectInResourcesAtIndex:0 withObject:_editingResource];
    [_editingBundle save];
}

- (void)editLineItem:(OLLineItem)aLineItem resource:(OLResource)editingResource
{
    _editingResource = editingResource;
    var lineItemEditWindowController = [[OLLineItemEditWindowController alloc] 
        initWithWindowCibName:"LineItemEditor.cib" lineItem:aLineItem];
    [lineItemEditWindowController setDelegate:self];
    [lineItemEditWindowController loadWindow];
}

- (void)nextLineItem:(OLLineItem)currentLineItem
{
    var nextIndex = [self indexOfLineItem:currentLineItem] + 1;

    if([self indexOfLineItem:currentLineItem] == [[_editingResource lineItems] count]-1)
    {
        nextIndex = 0;
    }

    return [[_editingResource lineItems] objectAtIndex:nextIndex];
}

- (void)previousLineItem:(OLLineItem)currentLineItem
{
    var nextIndex = [self indexOfLineItem:currentLineItem] - 1;

    if([self indexOfLineItem:currentLineItem] == 0)
    {
        nextIndex = [[_editingResource lineItems] count]-1;
    }

    return [[_editingResource lineItems] objectAtIndex:nextIndex];
}

- (void)voteUpResource:(OLResource)resource
{
    [resource voteUp];
}

- (void)voteDownResource:(OLResource)resource
{
    [resource voteDown];
}

- (void)indexOfLineItem:(OLLineItem)aLineItem
{
	return [[_editingResource lineItems] indexOfObject:aLineItem];
}

@end
