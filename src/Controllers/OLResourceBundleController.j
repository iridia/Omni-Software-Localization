@import <Foundation/CPObject.j>
@import "../models/OLResourceBundle.j"
@import "../Utilities/OLException.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";

/*!
 * The OLResourceBundleController is a controller for the resource bundle view and
 * the decisions on which data to send to the view is made here.
 */
@implementation OLResourceBundleController : CPViewController
{
	id _delegate @accessors(property=delegate);
	CPArray _bundles @accessors(property=bundles);
	OLResourceBundle _editingBundle @accessors(property=editingBundle);
    OLResource _editingResource;
}

- (void)init
{
        return [self initWithCibName:"Resources" bundle:nil externalNameTable:[CPDictionary dictionaryWithObject:self forKey:CPCibOwner]];
}

- (void)initWithCibName:(CPString)aName bundle:(CPBundle)aBundle externalNameTable:(CPDictionary)anExternalNameTable
{
    self = [super initWithCibName:aName bundle:aBundle externalNameTable:anExternalNameTable];
    return self;
}

- (void)awakeFromCib
{
    [self loadBundles];

    console.log([[self view] bounds]);
    var scrollView = [[CPScrollView alloc] initWithFrame:[[self view] bounds]];
    [scrollView setAutohidesScrollers:YES];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

    var tableView = [[CPTableView alloc] initWithFrame:[[self view] bounds]];
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [tableView setDataSource:self];
    [tableView setDelegate:self];

    // define the header color
	var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"button-bezel-center.png"]]];

    [[tableView cornerView] setBackgroundColor:headerColor];

	// add the filename column
	var column = [[CPTableColumn alloc] initWithIdentifier:OLResourcesViewFileNameColumn];
	[column setWidth:CGRectGetWidth([[self view] bounds])];
	[[column headerView] setStringValue:@"Filename"];
	[[column headerView] setBackgroundColor:headerColor];
	[tableView addTableColumn:column];

    [scrollView setDocumentView:tableView];

    [[self view] addSubview:scrollView];
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
