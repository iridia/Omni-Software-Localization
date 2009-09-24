@import <AppKit/CPCollectionView.j>

@implementation CKDetailView : CPCollectionView
{
    CPArray users;
}

- (id)initWithFrame:(CGRect)rect users:someUsers
{
    self = [super initWithFrame:rect];
    
    if (self)
    {
        users = someUsers;
        
        var dataView = [[CPCollectionViewItem alloc] init];
        [dataView setView:[[UserDataView alloc] initWithFrame:CGRectMakeZero()]];
        [self setItemPrototype:dataView];
        
        [self setMaxNumberOfColumns:1];
        [self setVerticalMargin:10.0];
        
        [self setMinItemSize:CGSizeMake(100.0, 32.0)];
        [self setMaxItemSize:CGSizeMake(1000000.0, 32.0)];
    }
    
    return self;
}

@end

@implementation UserDataView : CPView
{
    CPTextField label;
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
    console.log([anObject text]);
    [label setStringValue:[anObject text]];
    [label sizeToFit];
 
    [label setFrameOrigin:CGPointMake(10,CGRectGetHeight([label bounds]) / 2.0)];
}

@end