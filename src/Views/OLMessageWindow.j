@import <AppKit/CPWindow.j>

@import "../models/OLMessage.j"

@implementation OLMessageWindow : CPWindow
{
    CPView messageView;
    CPView submittingMessageView;
    CPView submittedMessageView;
    CPView currentView; // Keeps track of the current content view
    
    CPTextField emailTextField @accessors;
    CPTextField messageTextView;  
    CPButton    submitButton;
    CPTextField messageTextLabel;
    
    id delegate @accessors;
}

- (id)initWithContentRect:(CGRect)rect styleMask:(unsigned)styleMask
{
    self = [super initWithContentRect:rect styleMask:styleMask];
    
    if (self)
    {
        [self setTitle:@"Send Message"];
                
                var contentView = [self contentView];
                var inputFont = [CPFont systemFontOfSize:16.0];
                
                messageView = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];
                
                var emailLabel = [CPTextField labelWithTitle:@"To"];
                [messageView addSubview:emailLabel];
                
                emailTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"email@example.com" width:CGRectGetWidth([messageView bounds])];
                [emailTextField setFont:inputFont];
                [emailTextField sizeToFit];
                [emailTextField setFrameOrigin:CPMakePoint(0, CGRectGetHeight([emailLabel bounds]))];
                [messageView addSubview:emailTextField];
                                
                var subjectLabel = [CPTextField labelWithTitle:@"Subject"];
                [subjectLabel setFrameOrigin:CPMakePoint(0, calculateNextYPosition(emailTextField, 5))];
                [messageView addSubview:subjectLabel];
                                
                subjectTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"Urgent" width:CGRectGetWidth([messageView bounds])];
                [subjectTextField setFont:inputFont];
                [subjectTextField sizeToFit];
                [subjectTextField setFrameOrigin:CPMakePoint(0, calculateNextYPosition(subjectLabel, 5))];
                [messageView addSubview:subjectTextField];
                                
                messageTextView = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([messageView bounds]), 130)];
                [messageTextView setFrameOrigin:CPMakePoint(0, calculateNextYPosition(subjectTextField, 5))];
                [messageTextView setFont:inputFont];
                [messageTextView setEditable:YES];
                [messageTextView setBezeled:YES];
                [messageTextView setLineBreakMode:CPLineBreakByWordWrapping];
                [messageTextView setTarget:self];
                [messageTextView setAction:@selector(sendMessage:)]
                [messageView addSubview:messageTextView];
                
                submitButton = [CPButton buttonWithTitle:@"Send Message"];
                [submitButton setTarget:self];
                [submitButton setAction:@selector(sendMessage:)];
                [submitButton setFrameOrigin:CPMakePoint(CGRectGetWidth([messageView bounds]) - CGRectGetWidth([submitButton bounds]), CGRectGetHeight([messageView bounds]) - CGRectGetHeight([submitButton bounds]))];
                [messageView addSubview:submitButton];
                                
                var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
                [cancelButton setTarget:self];
                [cancelButton setAction:@selector(cancel:)];
                [cancelButton setFrameOrigin:CPMakePoint([submitButton frame].origin.x - CGRectGetWidth([cancelButton bounds]) - 5, CGRectGetHeight([messageView bounds]) - CGRectGetHeight([cancelButton bounds]))];
                [messageView addSubview:cancelButton];
                                
                [contentView addSubview:messageView];
                
                currentView = messageView;
        
        // Create other views up front
        submittingMessageView = createSubmittingMessageView(self, contentView);
        submittedMessageView = createSubmittedMessageView(self, contentView);
    }
    
    return self;
}

- (void)sendMessage:(id)sender
{
    var message = [CPDictionary dictionary];
    [message setObject:[emailTextField stringValue] forKey:@"ToUserID"];
    [message setObject:[subjectTextField stringValue] forKey:@"subject"];
    [message setObject:[messageTextView stringValue] forKey:@"content"];
    
    if ([delegate respondsToSelector:@selector(didSendMessage:)])
	{
	    [delegate didSendMessage:message];
	}
}

- (void)setStatus:(CPString)statusString
{
    var statusLabel = [CPTextField labelWithTitle:statusString];
    [statusLabel setTextColor:[CPColor redColor]];
    [statusLabel sizeToFit];
    [statusLabel setCenter:CPMakePoint(CGRectGetWidth([messageView bounds])/2, 5)];
    [messageView addSubview:statusLabel];  
}

- (void)setCurrentView:(CPView)aView
{
    [[self contentView] replaceSubview:currentView with:aView];
    currentView = aView;
}

- (void)cancel:(id)sender
{
    [[CPApplication sharedApplication] stopModal];
    [self orderOut:self];
    
    // Reset to empty values
    [messageTextView setStringValue:@""];
    [submitButton setTitle:@"Send Message"];
    
    // Put back first view
    [self setCurrentView:messageView];
}

- (void)showSendingMessageView
{
    [self setCurrentView:submittingMessageView];
}

- (void)showSentMessageView
{
    [self setCurrentView:submittedMessageView];
}

@end

function createSubmittingMessageView(self, contentView)
{
    var view = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];
    
    var sendingText = [CPTextField labelWithTitle:@"Sending message..."];
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

function createSubmittedMessageView(self, contentView)
{
    var view = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];
    
    var thankYouText = [CPTextField labelWithTitle:@"Message was sent!"];
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