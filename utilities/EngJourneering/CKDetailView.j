@import <AppKit/CPCollectionView.j>

@implementation CKDetailView : CPView
{
    CPArray users;
    CPCollectionView details;
}

- (id)initWithFrame:(CGRect)rect users:someUsers
{
    self = [super initWithFrame:rect];
    
    if (self)
    {
        users = someUsers;
        
        var dataView = [[CPCollectionViewItem alloc] init];
        [dataView setView:[[UserDataView alloc] initWithFrame:CGRectMakeZero()]];
        
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

- (void)setAllUsers:(CPArray)users
{
    var data = [];
    
    for (var i = 0; i < [users count]; i++)
    {
        [data addObjectsFromArray:[users[i] data]];
    }
    
    [data sortUsingSelector:@selector(compare:)];
    [details setContent:data];
}

- (void)setUser:(User)user
{
    var data = [user data];
    [data sortUsingSelector:@selector(compare:)];
    [details setContent:data];
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
    var listIndex = [[aCollectionView selectionIndexes] firstIndex];
    
    var link = [[[aCollectionView content] objectAtIndex:listIndex] link];
    
    window.open([link absoluteString]);
}

@end

@implementation UserDataView : CPView
{
    CPTextField dateAndTime;
    CPTextField message;
    CPTextField sourceAndUser;
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
    
    if (!sourceAndUser)
    {
        sourceAndUser = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([self bounds]), CGRectGetHeight([self bounds]))];
        
        [sourceAndUser setFont:[CPFont systemFontOfSize:10.0]];
        [sourceAndUser setTextColor:[CPColor grayColor]];
        
        [self addSubview:sourceAndUser];
    }
    
    [sourceAndUser setStringValue:"Posted by " + [anObject user] + " to " + [anObject source]];
    [sourceAndUser sizeToFit];
    [sourceAndUser setFrameOrigin:CGPointMake(CGRectGetWidth([self bounds]) - CGRectGetWidth([sourceAndUser bounds]), CGRectGetHeight([self bounds]) - CGRectGetHeight([sourceAndUser bounds]))];
}

@end