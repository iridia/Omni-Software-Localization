@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
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

- (OLLineItem)lineItemAtIndex:(int)index
{
    if (index === CPNotFound)
    {
        return nil;
    }
    
    return [lineItems objectAtIndex:index];
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

- (CPString)commentForSelectedLineItem
{
    return [selectedLineItem comment];
}

- (CPString)valueForSelectedLineItem
{
    return [selectedLineItem value];
}

- (CPString)identifierForSelectedLineItem
{
    return [selectedLineItem identifier];
}

- (CPArray)commentsForSelectedLineItem
{
    return [selectedLineItem comments];
}

- (void)addCommentForSelectedLineItem:(CPString)value
{
    var comment = [[OLComment alloc] initFromUser:[[OLUserSessionManager defaultSessionManager] user] withContent:value];
    [selectedLineItem addComment:comment];
}

- (void)setValueForSelectedLineItem:(CPString)value
{
    [selectedLineItem setValue:value];
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
