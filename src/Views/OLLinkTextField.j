@import <Foundation/CPObject.j>
@import "../Utilities/OLUserSessionManager.j"
@import "../Controllers/OLProfileController.j"

@implementation OLLinkTextField : CPTextField
{
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        [self setDelegate:self];
    }
    return self;
}

- (void)mouseEntered:(CPEvent)anEvent
{
    [self setBackgroundColor:[CPColor shadowColor]];
}

- (void)mouseExited:(CPEvent)anEvent
{ 
    [self setBackgroundColor:[CPColor clearColor]];
}

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent clickCount] === 1)
    {
        var projectTitle = [self objectValue];
        var userEmail = [[projectTitle componentsSeparatedByString:@"'"] objectAtIndex:0];
        if (userEmail !== projectTitle)
        {
            [[CPNotificationCenter defaultCenter] postNotificationName:OLProfileNeedsToBeLoaded object:userEmail];
        }
    }
    else
    {
        return;
    }
}

@end