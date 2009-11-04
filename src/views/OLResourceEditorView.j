@import "../models/OLResource.j"

var OLResourceEditorViewIdentifierColumnHeader = @"OLResourceEditorViewIdentifierColumnHeader";
var OLResourceEditorViewValueColumnHeader = @"OLResourceEditorViewValueColumnHeader";

@implementation OLResourceEditorView : CPView
{
    OLResource _editingResource @accessors(property=editingResource, readonly);
    CPTableView _lineItemsTableView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        var scrollView = [[CPScrollView alloc] initWithFrame:[self bounds]];
		[scrollView setAutohidesScrollers:YES];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		// create the resourceTableView
		_lineItemsTableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[_lineItemsTableView setDataSource:self];
		[_lineItemsTableView setUsesAlternatingRowBackgroundColors:YES];
		[_lineItemsTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
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
		
		[scrollView setDocumentView:_lineItemsTableView];
		[self addSubview:scrollView];
    }
    
    return self;
}

- (void)setEditingResource:(OLResource)resource
{
    if (_editingResource !== resource)
    {
        _editingResource = resource;
        [_lineItemsTableView reloadData];
    }
}

@end

@implementation OLResourceEditorView (CPTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    [[_editingResource lineItems] count];
}

- (id)tableView:(CPTableView)resourceTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    return @"TEST";
}

@end