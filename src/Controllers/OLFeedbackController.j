@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Views/OLFeedbackWindow.j"
@import "../Models/OLFeedback.j"

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
        
        [[CPNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(userDidChange:)
			name:OLUserSessionManagerUserDidChangeNotification
			object:nil];
    }
    
    return self;
}

- (void)userDidChange:(CPNotification)notification
{
    var userSessionManager = [notification object];
    var email = @"";
    if ([userSessionManager isUserLoggedIn])
    {
        email = [[userSessionManager user] email];
    }
    
    [[_feedbackWindow emailTextField] setStringValue:[user email]];
}

- (void)showFeedbackWindow:(id)sender
{
    [[CPApplication sharedApplication] runModalForWindow:_feedbackWindow];
}

- (void)didSubmitFeedback:(CPDictionary)feedbackDictionary
{
    var email = [feedbackDictionary objectForKey:@"email"];
    var type = [feedbackDictionary objectForKey:@"type"];
    var text = [feedbackDictionary objectForKey:@"text"];
    
    var feedback = [[OLFeedback alloc] initWithEmail:email type:type text:text];
    [feedback setDelegate:self];
    [feedback save];
}

- (void)willCreateRecord:(OLFeedback)feedback
{
    [_feedbackWindow showSendingFeedbackView];
}

- (void)didCreateRecord:(OLFeedback)feedback
{
    [_feedbackWindow showReceivedFeedbackView];
}

@end