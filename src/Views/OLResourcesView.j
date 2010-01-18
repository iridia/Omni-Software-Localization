@import <AppKit/CPView.j>

@import "OLResourcesSplitView.j"

@implementation OLResourcesView : CPView
{
    OLResourcesView resourcesView;
    CPPopUpButton   popUpButton;
    CPTextField     title;
    CPTextField     owner;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        var splitViewSize = CGRectMake(0, 40, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame)-99);
    
        resourcesView = [[OLResourcesSplitView alloc] initWithFrame:splitViewSize];
        [self addSubview:resourcesView];
        
        var titleBar = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(aFrame), 40)];
        [titleBar setBackgroundColor:[CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/_CPToolbarViewBackground.png"]]]];
        
        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
        [popUpButton setCenter:CGPointMake(CGRectGetWidth(aFrame)-90, 20)];
        
        [titleBar addSubview:popUpButton];
        
        title = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
        
        [title setFont:[CPFont boldSystemFontOfSize:20.0]];
        [title setTextShadowColor:[CPColor colorWithCalibratedWhite:240.0 / 255.0 alpha:1.0]];
        [title setTextShadowOffset:CGSizeMake(0.0, 1.5)];
        [title setTextColor:[CPColor colorWithCalibratedWhite:79.0 / 255.0 alpha:1.0]];
        
        owner = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
        
        [owner setFont:[CPFont boldSystemFontOfSize:14.0]];
        [owner setTextShadowColor:[CPColor colorWithCalibratedWhite:240.0 / 255.0 alpha:1.0]];
        [owner setTextShadowOffset:CGSizeMake(0.0, 1.5)];
        [owner setTextColor:[CPColor colorWithCalibratedWhite:79.0 / 255.0 alpha:1.0]];
        
        [self addSubview:titleBar];
        [self addSubview:title];
        [self addSubview:owner];
    }
    
    return self;
}

- (void)setUpTitle:(CPString)value
{
    [title setStringValue:value];
    
    [title sizeToFit];
    
    [title setCenter:CPPointMake(CGRectGetWidth([self frame])/2, 20)];
}

- (void)setUpOwner:(CPString)ownerId
{
    var ownerName = [OLUser findByRecordID:ownerId withCallback:function(user){ 
        var ownerName = [user email];
        
        if(ownerId === [[CPUserSessionManager defaultManager] userIdentifier])
        {
            ownerName = "yours";
        }
        
        [owner setStringValue:ownerName];
        [owner sizeToFit];
        [owner setCenter:CPPointMake(CGRectGetWidth([owner frame])/2 + 10, 20)];
    }];
}

- (void)reloadData:(OLResourceBundleController)resourceBundleController
{
    [popUpButton removeAllItems];
    [popUpButton addItemsWithTitles:[resourceBundleController titlesOfResourceBundles]];
    [popUpButton selectItemAtIndex:[resourceBundleController indexOfSelectedResourceBundle]];
    [self setUpTitle:[resourceBundleController projectName]];
    [self setUpOwner:[resourceBundleController ownerId]];
}

- (void)setResourceBundleController:(OLResourceBundleController)resourceBundleController
{
    [popUpButton setTarget:resourceBundleController];
    [popUpButton setAction:@selector(selectedResourceBundleDidChange:)]
}

- (void)setResourceController:(OLResourceController)resourceController
{
    [resourcesView setResourceController:resourceController];
}

- (void)setLineItemController:(OLLineItemsController)aLineItemsController
{
    [resourcesView setLineItemController:aLineItemsController];
}

- (void)editingView
{
    return [resourcesView editingView];
}

- (void)resourceTableView
{
    return [resourcesView resourceTableView];
}

- (void)showLineItemsTableView
{
    [resourcesView showLineItemsTableView];
}

- (void)hideLineItemsTableView
{
    [resourcesView hideLineItemsTableView];
}

- (void)setVoteCount:(int)votes
{
    [resourcesView setVoteCount:votes];
}

@end