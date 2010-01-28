@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "OLLineItemEditWindowController.j"
@import "../Models/OLLineItem.j"

OLLineItemSelectedLineItemIndexDidChangeNotification = @"OLLineItemSelectedLineItemIndexDidChangeNotification";

@implementation OLLineItemController : CPObject
{
	CPArray		    lineItems;
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

- (void)saveCommentWithOptions:(CPDictionary)options
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLProjectShouldCreateCommentNotification
        object:self
        userInfo:options];
}

- (void)editSelectedLineItem
{   
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
    
    var userInfo = [CPDictionary dictionary];
    [userInfo setObject:nextIndex forKey:@"SelectedIndex"];
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLLineItemSelectedLineItemIndexDidChangeNotification
        object:self
        userInfo:userInfo];
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
    
    var userInfo = [CPDictionary dictionary];
    [userInfo setObject:previousIndex forKey:@"SelectedIndex"];
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLLineItemSelectedLineItemIndexDidChangeNotification
        object:self
        userInfo:userInfo];
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
                lineItems = [[object selectedResource] lineItems];
            }
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end
