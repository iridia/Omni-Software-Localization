@import <AppKit/CPWindow.j>

@implementation OLFeedbackWindow : CPWindow
{
    CPView _feedbackView;
    CPView _submittingFeedbackView;
    CPView _submittedFeedbackView;
    
    CPTextField _emailTextField;
    CPPopUpButton _feedbackTypePopUpButton;
    CPTextField _feedbackTextField;
    
    JSONObject _feedback @accessors(property=feedback, readonly);
    
    id _delegate @accessors(property=delegate);
}

- (id)initWithContentRect:(CGRect)rect styleMask:(unsigned)styleMask
{
    self = [super initWithContentRect:rect styleMask:styleMask];
    
    if (self)
    {
        [self setTitle:@"Submit Feedback"];
        
        var contentView = [self contentView];
        
        _feedbackView = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];
        
        var emailLabel = [CPTextField labelWithTitle:@"Your e-mail (optional):"];
        [_feedbackView addSubview:emailLabel];
        
        _emailTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"email@example.com" width:CGRectGetWidth([_feedbackView bounds])];
        [_emailTextField setFont:[CPFont systemFontOfSize:16.0]];
        [_emailTextField sizeToFit];
        [_emailTextField setFrameOrigin:CPMakePoint(0, CGRectGetHeight([emailLabel bounds]))];
        [_feedbackView addSubview:_emailTextField];
        
        var feedbackTypeLabel = [CPTextField labelWithTitle:@"Type of feedback:"];
        [feedbackTypeLabel setFrameOrigin:CPMakePoint(0, calculateNextYPosition(_emailTextField, 5))];
        [_feedbackView addSubview:feedbackTypeLabel];
        
        _feedbackTypePopUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([_feedbackView bounds]), 24)];
        [_feedbackTypePopUpButton setFrameOrigin:CPMakePoint(0, calculateNextYPosition(feedbackTypeLabel))];
        var feedbackTypes = [@"Bug Report", @"Comment", @"Question", @"Suggestion"];
        [_feedbackTypePopUpButton addItemsWithTitles:feedbackTypes];
        [_feedbackView addSubview:_feedbackTypePopUpButton];
        
        var feedbackTextLabel = [CPTextField labelWithTitle:@"Comments:"];
        [feedbackTextLabel setFrameOrigin:CPMakePoint(0, calculateNextYPosition(_feedbackTypePopUpButton, 5))];
        [_feedbackView addSubview:feedbackTextLabel];
        
        _feedbackTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"" width:CGRectGetWidth([_feedbackView bounds])];
        [_feedbackTextField setLineBreakMode:CPLineBreakByWordWrapping];
        [_feedbackTextField setFrameOrigin:CPMakePoint(0, calculateNextYPosition(feedbackTextLabel))];
        [_feedbackView addSubview:_feedbackTextField];
        
        var submitButton = [CPButton buttonWithTitle:@"Submit Feedback"];
        [submitButton setTarget:self];
        [submitButton setAction:@selector(submitFeedback:)];
        [submitButton setFrameOrigin:CPMakePoint(CGRectGetWidth([_feedbackView bounds]) - CGRectGetWidth([submitButton bounds]), CGRectGetHeight([_feedbackView bounds]) - CGRectGetHeight([submitButton bounds]))];
        [_feedbackView addSubview:submitButton];
        
        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(cancel:)];
        [cancelButton setFrameOrigin:CPMakePoint([submitButton frame].origin.x - CGRectGetWidth([cancelButton bounds]) - 5, CGRectGetHeight([_feedbackView bounds]) - CGRectGetHeight([cancelButton bounds]))];
        [_feedbackView addSubview:cancelButton];
        
        [contentView addSubview:_feedbackView];
        
        // Initialize empty feedback object.
        _feedback = {};
    }
    
    return self;
}

- (void)submitFeedback:(id)sender
{
    _feedback.email = [_emailTextField stringValue];
    _feedback.type = [_feedbackTypePopUpButton titleOfSelectedItem];
    _feedback.text = [_feedbackTextField stringValue];
    
    if ([_delegate respondsToSelector:@selector(didSubmitFeedback:)])
	{
	    [_delegate didSubmitFeedback:self];
	}
}

- (void)cancel:(id)sender
{
    [[CPApplication sharedApplication] stopModal];
    [self orderOut:self];
    
    // Reset to empty values
    [_emailTextField setStringValue:@""];
    [_feedbackTypePopUpButton selectItemAtIndex:0];
    [_feedbackTextField setStringValue:@""];
}

@end

function calculateNextYPosition(previousView, padding)
{
    padding = padding || 0;
    return CGRectGetHeight([previousView bounds]) + [previousView frame].origin.y + padding;
}