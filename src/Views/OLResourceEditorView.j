@import "../models/OLResource.j"

var OLResourceEditorViewIdentifierColumnHeader = @"OLResourceEditorViewIdentifierColumnHeader";
var OLResourceEditorViewValueColumnHeader = @"OLResourceEditorViewValueColumnHeader";

@implementation OLResourceEditorView : CPView
{
    OLResource _editingResource @accessors(property=editingResource, readonly);
    CPTableView _lineItemsTableView;
    CPScrollView _scrollView;
    CPTextField _votes;
    
    CPTextField _editorTextField;
    CPInteger _editingRow;
    
    id _delegate @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {     
        _scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) -  32.0)];
		[_scrollView setAutohidesScrollers:YES];
		[_scrollView setAutoresizingMask:CPViewWidthSizable | CPViewMaxYMargin];
		
		_lineItemsTableView = [[CPTableView alloc] initWithFrame:[_scrollView bounds]];
		[_lineItemsTableView setDataSource:self];
		[_lineItemsTableView setUsesAlternatingRowBackgroundColors:YES];
		[_lineItemsTableView setAutoresizingMask:CPViewWidthSizable | CPViewWidthSizable];
		[_lineItemsTableView setTarget:self];
		[_lineItemsTableView setDoubleAction:@selector(edit:)];
				
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
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
		
		// This is bug #72
		var bottomBar = [[CPView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight([_scrollView bounds]) - 28.0, CGRectGetWidth(aFrame), 32.0)];
		[bottomBar setBackgroundColor:[CPColor lightGrayColor]];
		[bottomBar setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];
		
		var voteUpButton = [CPButton buttonWithTitle:@"Vote Up"];
		[voteUpButton setAutoresizingMask:CPViewMaxXMargin];
		[voteUpButton setFrameOrigin:CPMakePoint(10.0, 4.0)];
        [voteUpButton setTarget:self];
        [voteUpButton setAction:@selector(voteUp:)];
        [bottomBar addSubview:voteUpButton];
        
        var voteDownButton = [CPButton buttonWithTitle:@"Vote Down"];
        [voteDownButton setAutoresizingMask:CPViewMaxXMargin];
        [voteDownButton setTarget:self];
        [voteDownButton setAction:@selector(voteDown:)];
        [voteDownButton setFrameOrigin:CPMakePoint(CGRectGetWidth([voteUpButton bounds]) + 15.0, 4.0)];
        [bottomBar addSubview:voteDownButton];
        
        _votes = [CPTextField labelWithTitle:@"Votes: "];
        [_votes setFont:[CPFont systemFontOfSize:14.0]];
        [_votes sizeToFit];
        [_votes setAutoresizingMask:CPViewMaxXMargin];
        [_votes setFrameOrigin:CPMakePoint(CGRectGetWidth([voteUpButton bounds]) + CGRectGetWidth([voteDownButton bounds]) + 30.0, 7.0)];
        [bottomBar addSubview:_votes];

        [self addSubview:bottomBar];
		
		_editorTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"" width:(CGRectGetWidth(aFrame) - 200.0)];
		[_editorTextField setEditable:YES];
		[_editorTextField setDelegate:self];
		_editingRow = nil;
		
		_delegate = nil;
    }
    
    return self;
}

- (void)voteUp:(id)sender
{
    if ([_delegate respondsToSelector:@selector(voteUpResource:)])
    {
        [_delegate voteUpResource:_editingResource];
    }
    
    [self saveResource];
    [self reloadVotes];
}

- (void)voteDown:(id)sender
{
    if ([_delegate respondsToSelector:@selector(voteDownResource:)])
    {
        [_delegate voteDownResource:_editingResource];
    }
    
    [self saveResource];
    [self reloadVotes];
}

- (void)reloadVotes
{
    [_votes setStringValue:@"Votes: " + [_editingResource votes]];
    [_votes sizeToFit];
}

- (void)edit:(id)sender
{
    var _editingRow = [[sender selectedRowIndexes] firstIndex];

    if(_delegate && [_delegate respondsToSelector:@selector(editLineItem:resource:)])
    {
        var lineItem = [[_editingResource lineItems] objectAtIndex:_editingRow];
        [_delegate editLineItem:lineItem resource:_editingResource];
    }
    
//    var rowRect = [_lineItemsTableView rectOfRow:_editingRow];
//    [_editorTextField setFrameOrigin:CPMakePoint(200.0 - 3.0, rowRect.origin.y + (CGRectGetHeight([_editorTextField bounds]) / 2.0))];
    
//    [_editorTextField setStringValue:[[[_editingResource lineItems] objectAtIndex:_editingRow] value]];
//    [self addSubview:_editorTextField];
    
//    [[_editorTextField window] makeFirstResponder:_editorTextField]; 
}

- (void)saveResource
{
    if ([_delegate respondsToSelector:@selector(didEditResourceForEditingBundle:)])
	{
        [_delegate didEditResourceForEditingBundle:_editingResource];
	}
}

- (void)controlTextDidEndEditing:(CPNotification)aNotification
{
    var newValue = [_editorTextField stringValue];
    [[[_editingResource lineItems] objectAtIndex:_editingRow] setValue:newValue];

	[self saveResource];
	
	[_editorTextField removeFromSuperview];
    _editingRow = nil;
}

- (void)controlTextDidBlur:(CPNotification)aNotification
{
    [self controlTextDidEndEditing:aNotification]; // FIXME: This seems wrong, but it works.
}

- (void)setEditingResource:(OLResource)resource
{
    if (_editingResource !== resource)
    {
        _editingResource = resource;
        [self reloadVotes];
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
        var resource = [[[change objectForKey:CPKeyValueChangeNewKey] resources] objectAtIndex:0]; // FIXME: should not be hardcoded
        [self setEditingResource:resource];
    }
    else if (keyPath === @"editingBundle.resources")
    {
        var resource = [[[object editingBundle] resources] objectAtIndex:0]; // FIXME: should not be hardcoded
        [self setEditingResource:resource];
    }
}

@end