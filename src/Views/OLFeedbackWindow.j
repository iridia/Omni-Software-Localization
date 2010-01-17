@import <AppKit/CPWindow.j>

@import "../Models/OLFeedback.j"
@import "../Categories/CPView+Positioning.j"

@implementation OLFeedbackWindow : CPWindow
{
    CPView _feedbackView;
    CPView _submittingFeedbackView;
    CPView _submittedFeedbackView;
    CPView _currentView; // Keeps track of the current content view
    
    CPTextField _emailTextField @accessors(property=emailTextField, readonly);
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
        [_feedbackView addSubview:feedbackTypeLabel positioned:CPViewBelow relativeTo:_emailTextField withPadding:5];
        
        _feedbackTypePopUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([_feedbackView bounds]), 24)];
        var feedbackTypes = [@"Bug Report", @"Comment", @"Question", @"Suggestion"];
        [_feedbackTypePopUpButton addItemsWithTitles:feedbackTypes];
        [_feedbackTypePopUpButton setTarget:self];
        [_feedbackTypePopUpButton setAction:@selector(feedbackTypeDidChange:)];
        [_feedbackView addSubview:_feedbackTypePopUpButton positioned:CPViewBelow relativeTo:feedbackTypeLabel withPadding:0];
        
        _feedbackTextLabel = [CPTextField labelWithTitle:@""];
        [self feedbackTypeDidChange:_feedbackTypePopUpButton];
        [_feedbackView addSubview:_feedbackTextLabel positioned:CPViewBelow relativeTo:_feedbackTypePopUpButton withPadding:5];
        
        _feedbackTextView = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([_feedbackView bounds]), 130)];
        [_feedbackTextView setFont:inputFont];
	    [_feedbackTextView setEditable:YES];
		[_feedbackTextView setBezeled:YES];
		[_feedbackTextView setLineBreakMode:CPLineBreakByWordWrapping];
		[_feedbackTextView setTarget:self];
		[_feedbackTextView setAction:@selector(submitFeedback:)]
        [_feedbackView addSubview:_feedbackTextView positioned:CPViewBelow relativeTo:_feedbackTextLabel withPadding:0];
        
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
        
        [self setDefaultButton:_submitButton];
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
    [view addSubview:sendingText positioned:CPViewWidthCentered | CPViewHeightCentered relativeTo:view withPadding:0];
    
    var indeterminateProgressIndicator = [[CPProgressIndicator alloc] initWithFrame:CGRectMakeZero()];
    [indeterminateProgressIndicator setIndeterminate:YES];
    [indeterminateProgressIndicator setStyle:CPProgressIndicatorSpinningStyle];
    [indeterminateProgressIndicator sizeToFit];
    [view addSubview:indeterminateProgressIndicator positioned:CPViewBelow | CPViewWidthCentered relativeTo:sendingText withPadding:0];

    return view;
}

function createSubmittedFeedbackView(self, contentView)
{
    var view = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];
    
    var thankYouText = [CPTextField labelWithTitle:@"Thanks for your feedback!"];
    [thankYouText setFont:[CPFont boldSystemFontOfSize:18.0]];
    [thankYouText sizeToFit];
    [view addSubview:thankYouText positioned:CPViewWidthCentered | CPViewHeightCentered relativeTo:view withPadding:0];
    
    var closeButton = [CPButton buttonWithTitle:@"Close"];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(cancel:)];
    [view addSubview:closeButton positioned:CPViewBelow | CPViewWidthCentered relativeTo:thankYouText withPadding:0];
    
    return view;
}