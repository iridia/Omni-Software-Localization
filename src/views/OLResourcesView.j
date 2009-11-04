@import <AppKit/CPView.j>
//@import <Foundation/CPObject.j>

@implementation OLResourcesView : CPView
{
    CPArray     _files @accessors(property=files);
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
		var column = [[CPTableColumn alloc] initWithIdentifier:"Filename"];
		[[column headerView] setStringValue:"Filename"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:CGRectGetWidth(aFrame)];
		[_resourceTableView addTableColumn:column];
		[scrollView setDocumentView:_resourceTableView];
		[self addSubview:scrollView];
	}
	
	return self;
}

// ---
// CPTableView datasource methods
- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return 75;//[_files count];
}

- (id)tableView:(CPTableView)resourceTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    if ([tableColumn identifier]==="Filename")
        return @"Tom";//@"@"+[_files[row] fromUser];
    else
    	return [_files[row] text];
}
@end