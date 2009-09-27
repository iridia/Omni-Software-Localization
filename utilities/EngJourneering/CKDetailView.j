@import <AppKit/CPCollectionView.j>

@implementation CKDetailView : CPView
{
    CPArray users;
    CPCollectionView details;
    CPView titleView;
}

- (id)initWithFrame:(CGRect)rect users:someUsers
{
    self = [super initWithFrame:rect];
    
    if (self)
    {
        users = someUsers;
        
        titleView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([self frame]), 100)];
        [titleView setBackgroundColor:[CPColor grayColor]];
        [self addSubview:titleView];
        
        var dataView = [[CPCollectionViewItem alloc] init];
        [dataView setView:[[UserDataView alloc] initWithFrame:CGRectMakeZero()]];
        
        details = [[CPCollectionView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
        [details setItemPrototype:dataView];
        [details setMaxNumberOfColumns:1];
        [details setVerticalMargin:10.0];
        [details setMinItemSize:CGSizeMake(100.0, 42.0)];
        [details setMaxItemSize:CGSizeMake(1000000.0, 42.0)];
        
        var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setDocumentView:details];
        
        [self addSubview:scrollView];
        [self setBackgroundColor:[CPColor lightGrayColor]];
    }
    
    return self;
}

- (void)setUser:(User)user
{
    console.log("setting user", [user name]);
    [details setContent:[user data]];
    [self setNeedsDisplay:YES];
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
        // Do some initialization?
        [self setBackgroundColor:[CPColor whiteColor]];
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