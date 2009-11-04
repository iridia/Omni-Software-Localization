@import <AppKit/CPView.j>
//@import <Foundation/CPObject.j>

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";

@implementation OLResourcesView : CPView
{
    CPArray     _resources @accessors(property=resources);
    CPTableView _resourceTableView @accessors(property=resourceTableView);
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
		_resourceTableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[_resourceTableView setDataSource:self];
		[_resourceTableView setUsesAlternatingRowBackgroundColors:YES];
		[_resourceTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"button-bezel-center.png"]]];

		
		[[_resourceTableView cornerView] setBackgroundColor:headerColor];
		
		// add the first column
		var column = [[CPTableColumn alloc] initWithIdentifier:OLResourcesViewFileNameColumn];
		[[column headerView] setStringValue:"Filename"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:CGRectGetWidth(aFrame)];
		[_resourceTableView addTableColumn:column];
		[scrollView setDocumentView:_resourceTableView];
		[self addSubview:scrollView];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
	console.log("Observed!");
    if (keyPath === @"resources")
    {
        _resources = [object resources];
        [_resourceTableView reloadData];
    }
}

// ---
// CPTableView datasource methods
- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [_resources count];
}

- (void)reload
{
	[_resourceTableView reloadData];
}

- (id)tableView:(CPTableView)resourceTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    if ([tableColumn identifier] === OLResourcesViewFileNameColumn)
    {
        var resourceBundle = [_resources objectAtIndex:row];
        var resource = [[resourceBundle resources] objectAtIndex:0]; // FIXME
        return [resource fileName];
    }
    else
    {
    	return [_resources[row] description];
	}
}
@end