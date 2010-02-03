@import <Foundation/CPObject.j>
@import "../Utilities/OLUserSessionManager.j"

editingTextFieldDidChangeNotification = @"editingTextFieldDidChangeNotificaiton";

@implementation OLFormEditableTextField : CPTextField
{
    BOOL currentlyEditable   @accessors;
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
    [self setBackgroundColor:[CPColor greenColor]];
}

- (void)mouseExited:(CPEvent)anEvent
{ 
    [self setBackgroundColor:[CPColor clearColor]];
}

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent clickCount] === 2 && currentlyEditable)
    {
        [self setEditable:YES];
        [self setBezeled:YES];
        [[self window] makeFirstResponder:self];
    }
    else
    {
        [self setBezeled:NO];
        [self setEditable:NO];
        [super mouseDown:anEvent];
    }
}

- (void)controlTextDidBlur:(CPNotification)aNotification
{
    [self setBezeled:NO];
    [self setEditable:NO];
    [[CPNotificationCenter defaultCenter] postNotificationName:editingTextFieldDidChangeNotification object:self];
}

@end