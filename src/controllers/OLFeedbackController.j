@import <Foundation/CPObject.j>

@import "../views/OLFeedbackWindow.j"

@implementation OLFeedbackController : CPObject
{
    OLFeedbackWindow _feedbackWindow;
    CPURL _emailURL;
    CPURLRequest _emailRequest;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _feedbackWindow = [[OLFeedbackWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
        [_feedbackWindow setDelegate:self];
        
        _emailURL = [CPURL URLWithString:@"feedback.php"];
        _emailRequest = [CPURLRequest requestWithURL:_emailURL];
        [_emailRequest setHTTPMethod:@"GET"];
    }
    
    return self;
}

- (void)showFeedbackWindow:(id)sender
{
    [[CPApplication sharedApplication] runModalForWindow:_feedbackWindow];
}

- (void)didSubmitFeedback:(JSObject)feedback
{
    // Send it to the server
    [_emailRequest setValue:feedback.email forHTTPHeaderField:@"email"];
    [_emailRequest setValue:feedback.type forHTTPHeaderField:@"type"];
    [_emailRequest setValue:feedback.text forHTTPHeaderField:@"text"];
    
    // var connection = [CPURLConnection connectionWithRequest:_emailRequest delegate:self];
    /* simulate sending data */
    [_feedbackWindow sendingFeedback];
    window.setTimeout(function() {[_feedbackWindow receivedFeedback]}, 1000);
}

- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
    [_feedbackWindow receivedFeedback];
    console.log("Completed email with data: ", data);
}

@end