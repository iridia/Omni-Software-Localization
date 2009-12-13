@import <Foundation/CPObject.j>

@import "../models/OLResourceBundle.j"
@import "../Utilities/OLException.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";

/*!
 * The OLResourceBundleController is a controller for the resource bundle view and
 * the decisions on which data to send to the view is made here.
 */
@implementation OLResourceBundleController : CPObject
{
	id delegate @accessors;
	CPArray _bundles @accessors(property=bundles);
	OLResourceBundle _editingBundle @accessors(property=editingBundle);
    OLResource _editingResource;
}

- (void)didSelectBundleAtIndex:(CPInteger)selectedIndex
{	
    [self setEditingBundle:[_bundles objectAtIndex:selectedIndex]];
}

- (void)didEditResourceForEditingBundle
{
    [_editingBundle replaceObjectInResourcesAtIndex:0 withObject:_editingResource];
	console.log(delegate);
    [delegate save];
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

- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [_bundles count];
}

- (id)tableView:(CPTableView)resourceTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    var resourceBundle = [_bundles objectAtIndex:row];
    var resource = [[resourceBundle resources] objectAtIndex:0]; // FIXME: shoud not be hard coded to 0.
    
    if ([tableColumn identifier] === OLResourcesViewFileNameColumn)
    {
        return [resource fileName];
    }
}

@end

@implementation OLResourceBundleController (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
	switch (keyPath)
    {
        case @"selectedProject":
			[self setBundles:[[object selectedProject] resourceBundles]];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end
