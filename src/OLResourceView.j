@import <AppKit/CPView.j>

@implementation OLResourceView : CPView
{
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		var fileSelectionView = [[CPView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(frame), 220)];
		
		var filterView = [[CPScrollView alloc] initWithFrame:CGRectMake(20,20,CGRectGetWidth(frame)/4-40, 200)];
		var filterTableView = [[CPTableView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth([filterView bounds]), 200)];
		var filterTableColumn = [[CPTableColumn alloc] initWithIdentifier:@"filterColumn"];
		[filterTableColumn setWidth: CGRectGetWidth([filterTableView bounds])];
		[filterTableView addTableColumn: filterTableColumn];
		[filterTableView setUsesAlternatingRowBackgroundColors:YES];
		[filterTableView setRowHeight:50];
		[filterView setDocumentView:filterTableView];
		[filterView setBackgroundColor:[CPColor whiteColor]];
		[filterView setHasHorizontalScroller:NO];
		[filterView setAutohidesScrollers:YES];
		
		var structureView = [[CPScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/4 + 20, 20,CGRectGetWidth(frame)/4 - 40, 200)];
		var structureTableView = [[CPTableView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([structureView bounds]), 200)];
		var structureTableColumn = [[CPTableColumn alloc] initWithIdentifier:@"structureColumn"];
		[structureTableColumn setWidth: CGRectGetWidth([structureTableView bounds])];
		[structureTableView addTableColumn: structureTableColumn];
		[structureTableView setUsesAlternatingRowBackgroundColors:YES];
		[structureView setDocumentView:structureTableView];
		[structureView setBackgroundColor:[CPColor whiteColor]];
		[structureView setAutohidesScrollers:YES];
		[structureView setHasHorizontalScroller:NO];
		
		var filesView = [[CPScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2 + 20, 20,CGRectGetWidth(frame)/2 - 40, 200)];
		var filesTableView = [[CPTableView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([filesView bounds]), 200)];
		var filesTableColumn = [[CPTableColumn alloc] initWithIdentifier:@"filesColumn"];
		[filesTableColumn setWidth: CGRectGetWidth([filesTableView bounds])];
		[filesTableView addTableColumn: filesTableColumn];
		[filesTableView setUsesAlternatingRowBackgroundColors:YES];
		[filesView setDocumentView:filesTableView];
		[filesView setBackgroundColor:[CPColor whiteColor]];
		[filesView setAutohidesScrollers:YES];
		[filesView setHasHorizontalScroller:NO];
		
		[fileSelectionView addSubview:filterView];
		[fileSelectionView addSubview:structureView];
		[fileSelectionView addSubview:filesView];
		
		[filterTableView setDataSource:self];
		[structureTableView setDataSource:self];
		[filesTableView setDataSource:self];
		
		var lineItemTableView = [[CPTableView alloc] initWithFrame:CGRectMake(20,240,CGRectGetWidth(frame)-40,CGRectGetHeight(frame)-200)];
		var lineItemTableColumn = [[CPTableColumn alloc] initWithIdentifier:@"lineItemColumn"];
		[lineItemTableColumn setWidth: CGRectGetWidth([lineItemTableView bounds])];
		[lineItemTableView addTableColumn: lineItemTableColumn];
		[lineItemTableView setUsesAlternatingRowBackgroundColors:YES];
		
		[lineItemTableView setDataSource:self];
		
		[self addSubview:fileSelectionView];
		[self addSubview:lineItemTableView];
	}
	return self;
}

- (int)numberOfRowsInTableView:(CPTableView)view
{
	return 8;
}

- (id)tableView:(CPTableView)view objectValueForTableColumn:(CPTableColumn)column row:(int)row
{	
	return "Bob";
}

@end
