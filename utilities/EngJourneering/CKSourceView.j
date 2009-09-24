@import <AppKit/CPCollectionView.j>

@import "CKDetailView.j"

@implementation CKSourceView : CPCollectionView
{
    CPArray users @accessors(readonly);
    CPString key @accessors(readonly);
    CKDetailView detailView @accessors;
}

- (id)initWithFrame:(CGRect)rect users:someUsers key:aKey
{
    self = [super initWithFrame:rect];
    
    if (self)
    {
        users = someUsers;
        key = aKey;
        
        var userListView = [[CPCollectionViewItem alloc] init];
        [userListView setView:[[UserListView alloc] initWithFrame:CGRectMakeZero()]];
        [self setItemPrototype:userListView];
        
        [self setMaxNumberOfColumns:1];
        [self setVerticalMargin:0.0];
        
        [self setMinItemSize:CGSizeMake(100.0, 32.0)];
        [self setMaxItemSize:CGSizeMake(1000000.0, 32.0)];
        
        [self setContent:users];
        [self setDelegate:self];
    }
    
    return self;
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
    var listIndex = [[aCollectionView selectionIndexes] firstIndex];
    
    var user = [[self users] objectAtIndex:listIndex];
    console.log("CHANGING SELECTION TO:", user);
    
    var user_text = [user data];
    console.log(user_text);
    
    [[self detailView] setContent:user_text];
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
 
    [label setStringValue:[[anObject handles] objectForKey:@"github"]];
    [label sizeToFit];
 
    [label setFrameOrigin:CGPointMake(10,CGRectGetHeight([label bounds]) / 2.0)];
}
 
- (void)setSelected:(BOOL)flag
{
    if (!highlightView)
    {
        highlightView = [[CPView alloc] initWithFrame:CGRectCreateCopy([self bounds])];
        [highlightView setBackgroundColor:[CPColor blueColor]];
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