@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Models/OLResource.j"

@import "OLLineItemController.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";

@implementation OLResourceController : CPObject
{
    CPArray                 resources;
    OLResource              selectedResource    @accessors;
	CPString                ownerId             @accessors;
	
	OLLineItemController    lineItemController;
}

- (id)init
{
    if(self = [super init])
    {
        resources = [CPArray array];
        
        lineItemController = [[OLLineItemController alloc] init];
    	[self addObserver:lineItemController forKeyPath:@"selectedResource" options:CPKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (int)numberOfLineItems
{
    return [[selectedResource lineItems] count];
}

- (OLLineItem)lineItemAtIndex:(int)index
{
    return [[selectedResource lineItems] objectAtIndex:index];
}

- (void)selectLineItemAtIndex:(int)index
{
    [lineItemController selectLineItemAtIndex:index];
}

- (void)editSelectedLineItem
{
    [lineItemController editSelectedLineItem];
}

- (void)selectResourceAtIndex:(int)index
{
    if (index === CPNotFound)
    {
        [self setSelectedResource:nil];
    }
    else
    {
        [self setSelectedResource:[resources objectAtIndex:index]];
    }
}

- (void)voteUp
{
    var user = [[OLUserSessionManager defaultSessionManager] user];
    [selectedResource voteUp:user];
}

- (void)voteDown
{
    var user = [[OLUserSessionManager defaultSessionManager] user];
    [selectedResource voteDown:user];
}

- (int)numberOfVotesForSelectedResource
{
    return [selectedResource numberOfVotes];
}

@end

@implementation OLResourceController (OLResourceBundleControllerKVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"selectedResourceBundle":
            ownerId = [object ownerId];
            resources = [[object selectedResourceBundle] resources];
            [self setSelectedResource:nil];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end