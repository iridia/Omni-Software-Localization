@import <AppKit/CPWindow.j>

@import "../Categories/CPView+Positioning.j"

@implementation OLMessageWindow : CPWindow
{
    CPView messageView;
    CPView submittingMessageView;
    CPView submittedMessageView;
    CPView currentView; // Keeps track of the current content view
    
    CPTextField emailLabel;
    CPTextField emailTextField;
    CPTextField messageTextView;
    CPTextField messageTextLabel;
    CPTextField statusLabel;
    
    CPButton    closeButton;
    CPButton    submitButton;
    
    CPDictionary    messageDictionary;
    
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

        emailLabel = [CPTextField labelWithTitle:@"To"];
        [messageView addSubview:emailLabel];

        emailTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"email@example.com" width:CGRectGetWidth([messageView bounds])];
        [emailTextField setFont:inputFont];
        [emailTextField sizeToFit];
        [messageView addSubview:emailTextField positioned:CPViewBelow relativeTo:emailLabel withPadding:0.0];
                        
        var subjectLabel = [CPTextField labelWithTitle:@"Subject"];
        [messageView addSubview:subjectLabel positioned:CPViewBelow relativeTo:emailTextField withPadding:5.0];
                        
        subjectTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"Urgent" width:CGRectGetWidth([messageView bounds])];
        [subjectTextField setFont:inputFont];
        [subjectTextField sizeToFit];
        [messageView addSubview:subjectTextField positioned:CPViewBelow relativeTo:subjectLabel withPadding:0.0];
                        
        messageTextView = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([messageView bounds]), 130)];
        [messageTextView setFont:inputFont];
        [messageTextView setEditable:YES];
        [messageTextView setBezeled:YES];
        [messageTextView setLineBreakMode:CPLineBreakByWordWrapping];
        [messageTextView setTarget:self];
        [messageTextView setAction:@selector(sendMessage:)];
        [messageView addSubview:messageTextView positioned:CPViewBelow relativeTo:subjectTextField withPadding:5.0];
        
        submitButton = [CPButton buttonWithTitle:@"Send Message"];
        [submitButton setTarget:self];
        [submitButton setAction:@selector(sendMessage:)];
        [messageView addSubview:submitButton positioned:CPViewRightAligned | CPViewBottomAligned relativeTo:messageView withPadding:0.0];
        
        [self setDefaultButton:submitButton];
                        
        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(cancel:)];
        [messageView addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:submitButton withPadding:5.0];
        
        var statusLabel = [CPTextField labelWithTitle:@""];
        [messageView addSubview:statusLabel];
                        
        [contentView addSubview:messageView];
        
        currentView = messageView;
        
        // Create other views up front
        submittingMessageView = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];

        var sendingText = [CPTextField labelWithTitle:@"Sending message..."];
        [sendingText setFont:[CPFont boldSystemFontOfSize:18.0]];
        [sendingText sizeToFit];
        [submittingMessageView addSubview:sendingText positioned:CPViewHeightCentered | CPViewWidthCentered relativeTo:submittingMessageView withPadding:0.0];

        var indeterminateProgressIndicator = [[CPProgressIndicator alloc] initWithFrame:CGRectMakeZero()];
        [indeterminateProgressIndicator setIndeterminate:YES];
        [indeterminateProgressIndicator setStyle:CPProgressIndicatorSpinningStyle];
        [indeterminateProgressIndicator sizeToFit];
        [submittingMessageView addSubview:indeterminateProgressIndicator positioned:CPViewBelow | CPViewWidthCentered relativeTo:sendingText withPadding:5.0];

        submittedMessageView = [[CPView alloc] initWithFrame:CGRectInset([contentView bounds], 10, 10)];

        var thankYouText = [CPTextField labelWithTitle:@"Message was sent!"];
        [thankYouText setFont:[CPFont boldSystemFontOfSize:18.0]];
        [thankYouText sizeToFit];
        [submittedMessageView addSubview:thankYouText positioned:CPViewHeightCentered | CPViewWidthCentered relativeTo:submittedMessageView withPadding:0.0];

        closeButton = [CPButton buttonWithTitle:@"Close"];
        [closeButton setTarget:self];
        [closeButton setAction:@selector(cancel:)];
        [submittedMessageView addSubview:closeButton positioned:CPViewBelow | CPViewWidthCentered relativeTo:thankYouText withPadding:5.0];
        
        messageDictionary = [CPDictionary dictionary];
    }
    
    return self;
}

- (void)setIsBroadcastMessage:(BOOL)isBroadcast forProject:(OLProject)aProject
{
    if (isBroadcast)
    {
        [emailLabel setHidden:YES];
        [emailTextField setHidden:YES];
        [submitButton setAction:@selector(sendBroadcastMessage:)];
        [messageTextView setAction:@selector(sendBroadcastMessage:)];
        [messageDictionary setObject:aProject forKey:@"project"];
    }
    else
    {
        [emailLabel setHidden:NO];
        [emailTextField setHidden:NO];
        [submitButton setAction:@selector(sendMessage:)];
        [messageTextView setAction:@selector(sendMessage:)];
        [messageDictionary removeObjectForKey:@"project"];
    }
}

- (void)sendBroadcastMessage:(id)sender
{
    [self setStatus:@""];
    
    [messageDictionary setObject:[subjectTextField stringValue] forKey:@"subject"];
    [messageDictionary setObject:[messageTextView stringValue] forKey:@"content"];
    
    if ([delegate respondsToSelector:@selector(didSendBroadcastMessage:)])
	{
	    [delegate didSendBroadcastMessage:messageDictionary];
	}
}

- (void)sendMessage:(id)sender
{
    [self setStatus:@""];
    
    [messageDictionary setObject:[emailTextField stringValue] forKey:@"email"];
    [messageDictionary setObject:[subjectTextField stringValue] forKey:@"subject"];
    [messageDictionary setObject:[messageTextView stringValue] forKey:@"content"];
    
    if ([delegate respondsToSelector:@selector(didSendMessage:)])
	{
	    [delegate didSendMessage:messageDictionary];
	}
}

- (void)setStatus:(CPString)statusString
{
    [statusLabel setStringValue:statusString];
    [statusLabel setTextColor:[CPColor redColor]];
    [statusLabel sizeToFit];
    [statusLabel setCenter:CPMakePoint(CGRectGetWidth([messageView bounds])/2, 5)];
}

- (void)setCurrentView:(CPView)aView
{
    [[self contentView] replaceSubview:currentView with:aView];
    currentView = aView;
}

- (void)cancel:(id)sender
{
    [self setStatus:@""];
    
    [[CPApplication sharedApplication] stopModal];
    [self orderOut:self];
    
    // Reset to empty values
    [messageTextView setStringValue:@""];
    [self setDefaultButton:submitButton];
    
    // Put back first view
    [self setCurrentView:messageView];
}

- (void)showSendingMessageView
{
    [self setCurrentView:submittingMessageView];
}

- (void)showSentMessageView
{
    [self setDefaultButton:closeButton];
    [self setCurrentView:submittedMessageView];
}

@end
