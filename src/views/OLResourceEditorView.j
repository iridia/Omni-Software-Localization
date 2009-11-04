@import "../models/OLResource.j"

var OLResourceEditorViewIdentifierColumnHeader = @"OLResourceEditorViewIdentifierColumnHeader";
var OLResourceEditorViewValueColumnHeader = @"OLResourceEditorViewValueColumnHeader";

@implementation OLResourceEditorView : CPView
{
    OLResource _editingResource @accessors(property=editingResource, readonly);
    CPTableView _lineItemsTableView;
    CPScrollView _scrollView;
    
    CPTextField _editorTextField;
    CPInteger _editingRow;
    
    id _delegate @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        _scrollView = [[CPScrollView alloc] initWithFrame:[self bounds]];
		[_scrollView setAutohidesScrollers:YES];
		[_scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		_lineItemsTableView = [[CPTableView alloc] initWithFrame:[_scrollView bounds]];
		[_lineItemsTableView setDataSource:self];
		[_lineItemsTableView setUsesAlternatingRowBackgroundColors:YES];
		[_lineItemsTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[_lineItemsTableView setTarget:self];
		[_lineItemsTableView setDoubleAction:@selector(edit:)];
				
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"button-bezel-center.png"]]];
		[[_lineItemsTableView cornerView] setBackgroundColor:headerColor];
		
		// add the first column
		var column = [[CPTableColumn alloc] initWithIdentifier:OLResourceEditorViewIdentifierColumnHeader];
		[[column headerView] setStringValue:@"Identifier"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:200.0];
		[_lineItemsTableView addTableColumn:column];
		
		var column = [[CPTableColumn alloc] initWithIdentifier:OLResourceEditorViewValueColumnHeader];
		[[column headerView] setStringValue:@"Value"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:(CGRectGetWidth(aFrame) - 200.0)];
		[_lineItemsTableView addTableColumn:column];
		
		[_scrollView setDocumentView:_lineItemsTableView];
		[self addSubview:_scrollView];
		
		_editorTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"" width:(CGRectGetWidth(aFrame) - 200.0)];
		[_editorTextField setEditable:YES];
		[_editorTextField setDelegate:self];
		_editingRow = nil;
		
		_delegate = nil;
    }
    
    return self;
}

- (void)edit:(id)sender
{
    var _editingRow = [[sender selectedRowIndexes] firstIndex];
    if (_editingRow < 0)
    {
        _editingRow = nil;
        return;
    }
    
    var rowRect = [_lineItemsTableView rectOfRow:_editingRow];
    [_editorTextField setFrameOrigin:CPMakePoint(200.0 - 3.0, rowRect.origin.y + (CGRectGetHeight([_editorTextField bounds]) / 2.0))];
    
    [_editorTextField setStringValue:[[[_editingResource lineItems] objectAtIndex:_editingRow] value]];
    [self addSubview:_editorTextField];
    
    [[_editorTextField window] makeFirstResponder:_editorTextField]; 
}

- (void)controlTextDidEndEditing:(CPNotification)aNotification
{
	var newValue = [_editorTextField stringValue];
	
	if ([_delegate respondsToSelector:@selector(didEditResourceForEditingBundle:)])
	{

        [[[_editingResource lineItems] objectAtIndex:_editingRow] setValue:newValue];
        [_delegate didEditResourceForEditingBundle:_editingResource];
	}
	
	[_editorTextField removeFromSuperview];
    _editingRow = nil;
}

- (void)setEditingResource:(OLResource)resource
{
    if (_editingResource !== resource)
    {
        _editingResource = resource;
    }
    [_lineItemsTableView reloadData];
}

@end

@implementation OLResourceEditorView (CPTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [[_editingResource lineItems] count];
}

- (id)tableView:(CPTableView)resourceTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    if ([tableColumn identifier] === OLResourceEditorViewIdentifierColumnHeader)
    {
        return [[[_editingResource lineItems] objectAtIndex:row] identifier];
    }
    else if ([tableColumn identifier] === OLResourceEditorViewValueColumnHeader)
    {
        return [[[_editingResource lineItems] objectAtIndex:row] value];
    }
}

@end

@implementation OLResourceEditorView (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    if (keyPath === @"editingBundle")
    {
        var resource = [[[change objectForKey:CPKeyValueChangeNewKey] resources] objectAtIndex:0];
        [self setEditingResource:resource];
    }
    else if (keyPath === @"editingBundle.resources")
    {
        var resource = [[[object editingBundle] resources] objectAtIndex:0];
        [self setEditingResource:resource];
    }
}

@end