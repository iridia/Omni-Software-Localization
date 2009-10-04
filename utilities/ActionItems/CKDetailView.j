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
		[details setMaxItemSize:CGSizeMake(10000.0, 42.0)];
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
	var data = [source data];
	[data sortUsingFunction:function(i, j) {return ([i date] < [j date]) ? CPOrderedDescending : CPOrderedAscending} context:nil]
	[details setContent:[source data]];
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
	CPTextField dateAndTime;
	CPTextField message;
//	CPTextField sourceAndUser;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self)
	{
		[self setBackgroundColor:[CPColor colorWithCalibratedWhite:0.926 alpha:1.000]];
		[self setAutoresizingMask:CPViewWidthSizable];
	}
	
	return self;
}

- (void)setRepresentedObject:(JSObject)anObject
{
	if (!message)
	{
		message = [[CPTextField alloc] initWithFrame:CGRectInset([self bounds], 10, 10)];
		
		[message setFont:[CPFont systemFontOfSize:16.0]];
		[message setTextShadowColor:[CPColor whiteColor]];
		[message setTextShadowOffset:CGSizeMake(0, 1)];
 
		[self addSubview:message];
	}
	
	[message setStringValue:[anObject message]];
	[message sizeToFit];
	[message setFrameOrigin:CGPointMake(10,CGRectGetHeight([message bounds]) / 2.0)];
	
	if (!dateAndTime)
	{
		dateAndTime = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([self bounds]), CGRectGetHeight([self bounds]))];
		
		[dateAndTime setFont:[CPFont systemFontOfSize:10.0]];
		[dateAndTime setTextColor:[CPColor grayColor]];
		
		[self addSubview:dateAndTime];
	}
	
	[dateAndTime setStringValue:[anObject date] + " for " + [anObject time] + " minutes."];
	[dateAndTime sizeToFit];
	
//	if (!sourceAndUser)
//	{
//		sourceAndUser = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([self bounds]), CGRectGetHeight([self bounds]))];
//		
//		[sourceAndUser setFont:[CPFont systemFontOfSize:10.0]];
//		[sourceAndUser setTextColor:[CPColor grayColor]];
//		
//		[self addSubview:sourceAndUser];
//	}
	
//	[sourceAndUser setStringValue:"Posted by " + [anObject user] + " to " + [anObject source]];
//	[sourceAndUser sizeToFit];
//	[sourceAndUser setFrameOrigin:CGPointMake(CGRectGetWidth([self bounds]) - CGRectGetWidth([sourceAndUser bounds]), CGRectGetHeight([self bounds]) - CGRectGetHeight([sourceAndUser bounds]))];
}

@end