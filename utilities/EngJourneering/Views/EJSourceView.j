@import <AppKit/CPCollectionView.j>

@import "EJDetailView.j"
@import "../Users/EJUser.j"

@implementation EJSourceView : CPView
{
    EJDetailView detailView @accessors;
    EJUser _allUsers;
    CPCollectionView usersView;
}

- (id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    
    if (self)
    {        
        _allUsers = [[EJUser alloc] initWithDictionary:[[CPDictionary alloc] initWithObjects:[@"All Users", nil] forKeys:[@"Display Name", @"Handles"]]];
        
        var userListView = [[CPCollectionViewItem alloc] init];
        [userListView setView:[[UserListView alloc] initWithFrame:CGRectMakeZero()]];
        
        usersView = [[CPCollectionView alloc] initWithFrame:rect];
        [usersView setItemPrototype:userListView];
        [usersView setMaxNumberOfColumns:1];
        [usersView setVerticalMargin:0.0];
        [usersView setMinItemSize:CGSizeMake(100.0, 40.0)];
        [usersView setMaxItemSize:CGSizeMake(1000000.0, 40.0)];
        [usersView setDelegate:self];
        [usersView setAutoresizingMask:CPViewWidthSizable];
        
        [self addSubview:usersView];
        [self setBackgroundColor:[CPColor colorWithCalibratedRed:0.840 green:0.868 blue:0.899 alpha:1.000]];
    }
    
    return self;
}

- (void)setContent:(CPArray)content
{
    [content addObject:_allUsers];
    
    [usersView setContent:content];
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
    var listIndex = [[aCollectionView selectionIndexes] firstIndex];
    
    var users = [usersView content];
    
    var user = [users objectAtIndex:listIndex];
    
    if (user === _allUsers)
    {
        [[self detailView] setUsers:users];
    }
    else
    {
        [[self detailView] setUser:user];
    }
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
 
    [label setStringValue:[anObject displayName]];
    [label sizeToFit];
 
    [label setFrameOrigin:CGPointMake(10,CGRectGetHeight([label bounds]) / 2.0)];
}
 
- (void)setSelected:(BOOL)flag
{
    if (!highlightView)
    {
        highlightView = [[CPView alloc] initWithFrame:CGRectCreateCopy([self bounds])];
        [highlightView setBackgroundColor:[CPColor colorWithCalibratedRed:0.561 green:0.631 blue:0.761 alpha:1.000]];
        [highlightView setAutoresizingMask:CPViewWidthSizable];
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