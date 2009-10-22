@import <Foundation/CPObject.j>

@import "../views/OLFeedbackWindow.j"

@implementation OLFeedbackController : CPObject
{
    OLFeedbackWindow _feedbackWindow;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _feedbackWindow = [[OLFeedbackWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
        [_feedbackWindow setDelegate:self];
    }
    
    return self;
}

- (void)showFeedbackWindow:(id)sender
{
    [[CPApplication sharedApplication] runModalForWindow:_feedbackWindow];
}

- (void)didSubmitFeedback:(id)sender
{
    var feedback = [_feedbackWindow feedback];
    
    // Send it to the server
}

@end