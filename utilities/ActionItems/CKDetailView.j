@import <AppKit/CPCollectionView.j>

@implementation CKDetailView : CPView
{
	CPArray sources;
	CPCollectionView details;
}

- (id)initWithFrame:(CGRect)rect sources:someSources
{
	self = [super initWithFrame:rect];
	
	if (self)
	{
		sources = someSources;
		
		var dataView = [[CPCollectionViewItem alloc] init];
		[dataView setView:[[SourceDataView alloc] initWithFrame:CGRectMakeZero()]];
		
		details = [[CPCollectionView alloc] initWithFrame:rect];
		[details setItemPrototype:dataView];
		[details setMaxNumberOfColumns:1];
		[details setVerticalMargin:10.0];
		[details setMinItemSize:CGSizeMake(500.0, 42.0)];
		[details setMaxItemSize:CGSizeMake(10000.0, 10000.0)];
		[details setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[details setDelegate:self];
		
		var scrollView = [[CPScrollView alloc] initWithFrame:rect];
		[scrollView setAutohidesScrollers:YES];
		[scrollView setDocumentView:details];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		[self addSubview:scrollView];
		[self setBackgroundColor:[CPColor colorWithCalibratedWhite:0.656 alpha:1.000]];
	}
	
	return self;
}

- (void)setSource:(WikiPage)source
{
	var data = [source actionItems];
	// don't sort for now // [data sortUsingFunction:function(i, j) {return ([i date] < [j date]) ? CPOrderedDescending : CPOrderedAscending} context:nil]
	[details setContent:data];
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
	var listIndex = [[aCollectionView selectionIndexes] firstIndex];
	
	var link = [[[aCollectionView content] objectAtIndex:listIndex] link];
	
	window.open([link absoluteString]);
}

@end

@implementation SourceDataView : CPView
{
	CPTextField message;
	
	CPWebView webView;
	
}//
//
//- (id)initWithFrame:(CGRect)frame
//{
//	self = [super initWithFrame:frame];
//	
//	if (self)
//	{
//		[self setBackgroundColor:[CPColor colorWithCalibratedWhite:0.926 alpha:1.000]];
//		[self setAutoresizingMask:CPViewWidthSizable];
//	}
//	
//	return self;
//}

- (void)setRepresentedObject:(JSObject)anObject
{
	//if (!message)
//	{
//		message = [[CPTextField alloc] initWithFrame:CGRectInset([self bounds], 10, 10)];
//		
//		[message setFont:[CPFont systemFontOfSize:16.0]];
//		[message setTextShadowColor:[CPColor whiteColor]];
//		[message setTextShadowOffset:CGSizeMake(0, 1)];
// 
//		[self addSubview:message];
//	}
//	
//	[message setStringValue:[anObject actionItem]];
//	[message sizeToFit];
//	[message setFrameOrigin:CGPointMake(10,CGRectGetHeight([message bounds]) / 2.0)];


	if (!webView)
	{
		webView = [[CPWebView alloc] initWithFrame:CGRectInset([self bounds], 10, 10)];
		[self addSubview:webView];
	}
	
	var actionItemHTML = [anObject actionItem];
	actionItemHTML = @"<html><body>" + actionItemHTML + @"</body></html>";
	
	[webView loadHTMLString:actionItemHTML];
	[webView setFrameSize:CGSizeMake(CGRectGetWidth([self bounds]), 500)];
	
}

@end