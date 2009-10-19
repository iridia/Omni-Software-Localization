@import "OLView.j"
@import "OLFilterTableView.j"
@import "OLStructureTableView.j"
@import "OLFileTableView.j"
@import "OLLineItemTableView.j"

/*!
 * The view for displaying relevant resource information.
 */
@implementation OLResourceBundleView : OLView
{
}

- (id)initWithFrame:(CGRect)frame withController:(CPObject)controller
{
	if(self = [super initWithFrame:frame withController:controller])
	{				
		var fileSelectionView = [[CPView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(frame), 220)];
		
		var filterView = [[CPScrollView alloc] initWithFrame:CGRectMake(20,20,CGRectGetWidth(frame)/4-40, 200)];
		var filterTableView = [[OLFilterTableView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth([filterView bounds]), 200)];
		[filterView setDocumentView:filterTableView];
		[filterView setBackgroundColor:[CPColor whiteColor]];
		[filterView setHasHorizontalScroller:NO];
		[filterView setAutohidesScrollers:YES];
		
		var structureView = [[CPScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/4 + 20, 20,CGRectGetWidth(frame)/4 - 40, 200)];
		var structureTableView = [[OLStructureTableView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([structureView bounds]), 200)];
		[structureView setDocumentView:structureTableView];
		[structureView setBackgroundColor:[CPColor whiteColor]];
		[structureView setAutohidesScrollers:YES];
		[structureView setHasHorizontalScroller:NO];
		
		var filesView = [[CPScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2 + 20, 20,CGRectGetWidth(frame)/2 - 40, 200)];
		var filesTableView = [[OLFileTableView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([filesView bounds]), 200)];
		[filesView setDocumentView:filesTableView];
		[filesView setBackgroundColor:[CPColor whiteColor]];
		[filesView setAutohidesScrollers:YES];
		[filesView setHasHorizontalScroller:NO];
		
		[filterTableView setDataSource:controller];
		[structureTableView setDataSource:controller];
		[filesTableView setDataSource:controller];
		
		[fileSelectionView addSubview:filterView];
		[fileSelectionView addSubview:structureView];
		[fileSelectionView addSubview:filesView];
		
		var lineItemTableView = [[OLLineItemTableView alloc] initWithFrame:CGRectMake(20,240,CGRectGetWidth(frame)-40,CGRectGetHeight(frame)-200)];
		[lineItemTableView setDataSource:controller];
		
		[self addSubview:fileSelectionView];
		[self addSubview:lineItemTableView];
	}
	return self;
}

@end
