@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "OLLineItemEditWindowController.j"
@import "../Models/OLLineItem.j"

OLLineItemSelectedLineItemIndexDidChangeNotification = @"OLLineItemSelectedLineItemIndexDidChangeNotification";

@implementation OLLineItemController : CPObject
{
	CPArray		    lineItems;
	CPString        ownerId             @accessors;
	OLLineItem      selectedLineItem    @accessors;
}

- (id)init
{
	if(self = [super init])
	{
	    lineItems = [CPArray array];
	}
	return self;
}

- (void)selectLineItemAtIndex:(int)index
{
    if (index === CPNotFound)
    {
        [self setSelectedLineItem:nil];
    }
    else
    {
        [self setSelectedLineItem:[lineItems objectAtIndex:index]];
    }
}

- (void)editSelectedLineItem
{
    var userSessionManager = [OLUserSessionManager defaultSessionManager];
    if(![userSessionManager isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to edit this item!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(editSelectedLineItem:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];
        
        [[CPNotificationCenter defaultCenter]
            postNotificationName:@"OLUserShouldLoginNotification"
            object:nil
            userInfo:userInfo];
        return;
    }
    else if(![userSessionManager isUserTheLoggedInUser:ownerId])
    {
        [[CPNotificationCenter defaultCenter]
            postNotificationName:@"OLProjectShouldBranchNotification"
            object:nil];
            
        return;
    }
    
    var lineItemEditWindowController = [[OLLineItemEditWindowController alloc] initWithWindowCibName:@"LineItemEditor.cib" lineItem:selectedLineItem];
    [lineItemEditWindowController setDelegate:self];
    [self addObserver:lineItemEditWindowController forKeyPath:@"selectedLineItem" options:CPKeyValueObservingOptionNew context:nil];
    [lineItemEditWindowController loadWindow];
}

- (void)nextLineItem
{
    var currentIndex = [lineItems indexOfObject:selectedLineItem];
    var nextIndex = currentIndex + 1;
    
    if (nextIndex >= [lineItems count])
    {
        nextIndex = 0;
    }

    [self selectLineItemAtIndex:nextIndex];
    
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLLineItemSelectedLineItemIndexDidChangeNotification
        object:nextIndex];
}

- (void)previousLineItem
{
    var currentIndex = [lineItems indexOfObject:selectedLineItem];
    var previousIndex = currentIndex - 1;
    
    if (previousIndex < 0)
    {
        previousIndex = [lineItems count] - 1;
    }

    [self selectLineItemAtIndex:previousIndex];
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLLineItemSelectedLineItemIndexDidChangeNotification
        object:previousIndex];
}

@end

@implementation OLLineItemController (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"selectedResource":
            var selectedResource = [object selectedResource];
            if (selectedResource)
            {
                ownerId = [object ownerId];
                lineItems = [[object selectedResource] lineItems];
            }
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end
