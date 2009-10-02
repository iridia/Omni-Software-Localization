@import <AppKit/CPView.j>

@implementation OLResourceView : CPView
{
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		var fileSelectionView = [[CPView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(frame), 200)];
		
		var filterTableView = [[CPTableView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(frame)/4, 200)];
		var structureTableView = [[CPTableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/4,0,CGRectGetWidth(frame)/4, 200)];
		var filesTableView = [[CPTableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2,0,CGRectGetWidth(frame)/2, 200)];
		
		[fileSelectionView addSubview:filterTableView];
		[fileSelectionView addSubview:structureTableView];
		[fileSelectionView addSubview:filesTableView];
		
		var column = [[CPTableColumn alloc] initWithIdentifier:@"a"];
		[column setWidth: 200];
		
		[filterTableView addTableColumn:column];		
		[structureTableView addTableColumn:column];	
		[filesTableView addTableColumn:column];
		
		[filterTableView setDataSource:self];
		[structureTableView setDataSource:self];
		[filesTableView setDataSource:self];
		
		var lineItemTableView = [[CPTableView alloc] initWithFrame:CGRectMake(0,200,CGRectGetWidth(frame),CGRectGetHeight(frame)-200)];
		
		[self addSubview:fileSelectionView];
		[self addSubview:lineItemTableView];
	}
	return self;
}

- (int)numberOfRowsInTableView:(CPTableView)view
{
	return 2;
}

- (id)tableView:(CPTableView)view objectValueForTableColumn:(CPTableColumn)column row:(int)row
{	
	return "Bob";
}

@end
