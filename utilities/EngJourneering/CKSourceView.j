@import <AppKit/CPCollectionView.j>

@import "CKDetailView.j"

@implementation CKSourceView : CPView
{
    CPArray users @accessors(readonly);
    CKDetailView detailView @accessors;
}

- (id)initWithFrame:(CGRect)rect users:someUsers
{
    self = [super initWithFrame:rect];
    
    if (self)
    {
        users = someUsers;
        
        var userListView = [[CPCollectionViewItem alloc] init];
        [userListView setView:[[UserListView alloc] initWithFrame:CGRectMakeZero()]];
        
        var collectionView = [[CPCollectionView alloc] initWithFrame:rect];
        [collectionView setItemPrototype:userListView];
        [collectionView setMaxNumberOfColumns:1];
        [collectionView setVerticalMargin:0.0];
        [collectionView setMinItemSize:CGSizeMake(100.0, 40.0)];
        [collectionView setMaxItemSize:CGSizeMake(1000000.0, 40.0)];
        [collectionView setContent:users];
        [collectionView setDelegate:self];
        
        [self addSubview:collectionView];
        [self setBackgroundColor:[CPColor colorWithCalibratedRed:0.840 green:0.868 blue:0.899 alpha:1.000]];
    }
    
    return self;
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
    var listIndex = [[aCollectionView selectionIndexes] firstIndex];
    
    var user = [[self users] objectAtIndex:listIndex];
    
    [[self detailView] setUser:user];
}

@end

@implementation UserListView : CPView
{
    CPTextField label;
    CPView highlightView;
}

- (void)setRepresentedObject:(JSObject)anObject
{
    if (!label)
    {
        label = [[CPTextField alloc] initWithFrame:CGRectInset([self bounds], 4, 4)];
        
        [label setFont:[CPFont systemFontOfSize:16.0]];
        [label setTextShadowColor:[CPColor whiteColor]];
        [label setTextShadowOffset:CGSizeMake(0, 1)];
 
        [self addSubview:label];
    }
 
    [label setStringValue:[anObject name]];
    [label sizeToFit];
 
    [label setFrameOrigin:CGPointMake(10,CGRectGetHeight([label bounds]) / 2.0)];
}
 
- (void)setSelected:(BOOL)flag
{
    if (!highlightView)
    {
        highlightView = [[CPView alloc] initWithFrame:CGRectCreateCopy([self bounds])];
        [highlightView setBackgroundColor:[CPColor colorWithCalibratedRed:0.561 green:0.631 blue:0.761 alpha:1.000]];
    }
 
    if (flag)
    {
        [self addSubview:highlightView positioned:CPWindowBelow relativeTo:label];
        [label setTextColor:[CPColor whiteColor]];    
        [label setTextShadowColor:[CPColor blackColor]];
    }
    else
    {
        [highlightView removeFromSuperview];
        [label setTextColor:[CPColor blackColor]];
        [label setTextShadowColor:[CPColor whiteColor]];
    }
}

@end