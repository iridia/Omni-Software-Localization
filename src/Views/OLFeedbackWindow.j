@import <AppKit/CPWindow.j>

@import "../models/OLFeedback.j"

@implementation OLFeedbackWindow : CPWindow
{
    CPView _feedbackView;
    CPView _submittingFeedbackView;
    CPView _submittedFeedbackView;
    CPView _currentView; // Keeps track of the current content view
    
    CPTextField _emailTextField;
    CPPopUpButton _feedbackTypePopUpButton;
    CPTextField _feedbackTextView;
    
    CPButton _submitButton;
    CPTextField _feedbackTextLabel;
    
    id _delegate @accessors(property=delegate);
}

- (id)initWithContentRect:(CGRect)rect styleMask:(unsigned)styleMask
{
    self = [super initWithContentRect:rect styleMask:styleMask];
    
    if (self)
    {
        [self setTitle:@"Submit Feedback"];
        
        var contentView = [self contentView];
        var inputFont = [CPFont systemFontOfSize:16.0];
        
        _feedbackView = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];
        
        var emailLabel = [CPTextField labelWithTitle:@"Your e-mail (optional):"];
        [_feedbackView addSubview:emailLabel];
        
        _emailTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"email@example.com" width:CGRectGetWidth([_feedbackView bounds])];
        [_emailTextField setFont:inputFont];
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
        [_feedbackTypePopUpButton setTarget:self];
        [_feedbackTypePopUpButton setAction:@selector(feedbackTypeDidChange:)];
        [_feedbackView addSubview:_feedbackTypePopUpButton];
        
        _feedbackTextLabel = [CPTextField labelWithTitle:@""];
        [self feedbackTypeDidChange:_feedbackTypePopUpButton];
        [_feedbackTextLabel setFrameOrigin:CPMakePoint(0, calculateNextYPosition(_feedbackTypePopUpButton, 5))];
        [_feedbackView addSubview:_feedbackTextLabel];
        
        _feedbackTextView = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([_feedbackView bounds]), 130)];
        [_feedbackTextView setFrameOrigin:CPMakePoint(0, calculateNextYPosition(_feedbackTextLabel))];
        [_feedbackTextView setFont:inputFont];
	    [_feedbackTextView setEditable:YES];
		[_feedbackTextView setBezeled:YES];
		[_feedbackTextView setLineBreakMode:CPLineBreakByWordWrapping];
        [_feedbackView addSubview:_feedbackTextView];
        
        _submitButton = [CPButton buttonWithTitle:@"Submit Feedback"];
        [_submitButton setTarget:self];
        [_submitButton setAction:@selector(submitFeedback:)];
        [_submitButton setFrameOrigin:CPMakePoint(CGRectGetWidth([_feedbackView bounds]) - CGRectGetWidth([_submitButton bounds]), CGRectGetHeight([_feedbackView bounds]) - CGRectGetHeight([_submitButton bounds]))];
        [_feedbackView addSubview:_submitButton];
        
        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(cancel:)];
        [cancelButton setFrameOrigin:CPMakePoint([_submitButton frame].origin.x - CGRectGetWidth([cancelButton bounds]) - 5, CGRectGetHeight([_feedbackView bounds]) - CGRectGetHeight([cancelButton bounds]))];
        [_feedbackView addSubview:cancelButton];
        
        [contentView addSubview:_feedbackView];
        
        _currentView = _feedbackView;
        
        // Create other views up front
        _submittingFeedbackView = createSubmittingFeedbackView(self, contentView);
        _submittedFeedbackView = createSubmittedFeedbackView(self, contentView);
    }
    
    return self;
}

- (void)feedbackTypeDidChange:(id)sender
{
    var selectedItemTitle = [sender titleOfSelectedItem];
    [_feedbackTextLabel setStringValue:selectedItemTitle + @":"];
    [_feedbackTextLabel sizeToFit];
}

- (void)submitFeedback:(id)sender
{
    var feedback = [CPDictionary dictionary];
    [feedback setObject:[_emailTextField stringValue] forKey:@"email"];
    [feedback setObject:[_feedbackTypePopUpButton titleOfSelectedItem] forKey:@"type"];
    [feedback setObject:[_feedbackTextView stringValue] forKey:@"text"];
    
    if ([_delegate respondsToSelector:@selector(didSubmitFeedback:)])
	{
	    [_delegate didSubmitFeedback:feedback];
	}
}

- (void)setCurrentView:(CPView)aView
{
    [[self contentView] replaceSubview:_currentView with:aView];
    _currentView = aView;
}

- (void)cancel:(id)sender
{
    [[CPApplication sharedApplication] stopModal];
    [self orderOut:self];
    
    // Reset to empty values
    [_emailTextField setStringValue:@""];
    [_feedbackTypePopUpButton selectItemAtIndex:0];
    [self feedbackTypeDidChange:_feedbackTypePopUpButton];
    [_feedbackTextView setStringValue:@""];
    [_submitButton setTitle:@"Submit Feedback"];
    
    // Put back first view
    [self setCurrentView:_feedbackView];
}

- (void)showSendingFeedbackView
{
    [self setCurrentView:_submittingFeedbackView];
}

- (void)showReceivedFeedbackView
{
    [self setCurrentView:_submittedFeedbackView];
}

@end

function createSubmittingFeedbackView(self, contentView)
{
    var view = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];
    
    var sendingText = [CPTextField labelWithTitle:@"Sending feedback..."];
    [sendingText setFont:[CPFont boldSystemFontOfSize:18.0]];
    [sendingText sizeToFit];
    [sendingText setFrameOrigin:calculateCenter(view, sendingText)];
    [view addSubview:sendingText];
    
    var indeterminateProgressIndicator = [[CPProgressIndicator alloc] initWithFrame:CGRectMakeZero()];
    [indeterminateProgressIndicator setIndeterminate:YES];
    [indeterminateProgressIndicator setStyle:CPProgressIndicatorSpinningStyle];
    [indeterminateProgressIndicator sizeToFit];
    [indeterminateProgressIndicator setFrameOrigin:CPMakePoint((CGRectGetWidth([view bounds]) / 2.0) - (CGRectGetWidth([indeterminateProgressIndicator bounds]) / 2.0), calculateNextYPosition(sendingText))];
    [view addSubview:indeterminateProgressIndicator];
    
    return view;
}

function createSubmittedFeedbackView(self, contentView)
{
    var view = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];
    
    var thankYouText = [CPTextField labelWithTitle:@"Thanks for your feedback!"];
    [thankYouText setFont:[CPFont boldSystemFontOfSize:18.0]];
    [thankYouText sizeToFit];
    [thankYouText setFrameOrigin:calculateCenter(view, thankYouText)];
    [view addSubview:thankYouText];
    
    var closeButton = [CPButton buttonWithTitle:@"Close"];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(cancel:)];
    [closeButton setFrameOrigin:CPMakePoint((CGRectGetWidth([view bounds]) / 2.0) - (CGRectGetWidth([closeButton bounds]) / 2.0), calculateNextYPosition(thankYouText))];
    [view addSubview:closeButton];
    
    return view;
}

function calculateNextYPosition(previousView, padding)
{
    padding = padding || 0;
    return CGRectGetHeight([previousView bounds]) + [previousView frame].origin.y + padding;
}

function calculateCenter(viewRelativeTo, view)
{
    return CPMakePoint((CGRectGetWidth([viewRelativeTo bounds]) / 2.0) - (CGRectGetWidth([view bounds]) / 2.0),
        (CGRectGetHeight([viewRelativeTo bounds]) / 2.0) - CGRectGetHeight([view bounds]));
}