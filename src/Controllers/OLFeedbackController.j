@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Views/OLFeedbackWindow.j"
@import "../Models/OLFeedback.j"

@implementation OLFeedbackController : CPObject
{
    OLFeedbackWindow feedbackWindow;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        feedbackWindow = [[OLFeedbackWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
        [feedbackWindow setDelegate:self];
        
        [[CPNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(userDidChange:)
			name:OLUserSessionManagerUserDidChangeNotification
			object:nil];
    }
    
    return self;
}

- (void)setValueOfEmailTextField:(CPString)email
{
    [[feedbackWindow emailTextField] setStringValue:email];
}

- (void)showFeedbackWindow:(id)sender
{
    [[CPApplication sharedApplication] runModalForWindow:feedbackWindow];
    [feedbackWindow isBeingShown];
}

- (void)userDidChange:(CPNotification)notification
{
    var email = @"";
    if ([[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        email = [[[OLUserSessionManager defaultSessionManager] user] email];
    }
    
    [[feedbackWindow emailTextField] setStringValue:email];
}

- (void)didSubmitFeedback:(CPDictionary)feedbackDictionary
{
    var email = [feedbackDictionary objectForKey:@"email"];
    var type = [feedbackDictionary objectForKey:@"type"];
    var text = [feedbackDictionary objectForKey:@"text"];
    
    var feedback = [[OLFeedback alloc] initWithEmail:email type:type text:text];
    [feedback saveWithCallback:function(){
        [feedbackWindow showReceivedFeedbackView];
    }];
}

- (void)willCreateRecord:(OLFeedback)feedback
{
    [feedbackWindow showSendingFeedbackView];
}

- (void)didCreateRecord:(OLFeedback)feedback
{
    [feedbackWindow showReceivedFeedbackView];
}

@end