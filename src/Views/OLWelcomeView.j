@import "CPUploadButton.j"

/*!
 * OLWelcomeScreen
 *
 * The screen that is displayed to first-time visitors.
 */
@implementation OLWelcomeView : CPView
{
    CPCheckBox      showWindowOnLaunch;
	id              delegate            @accessors;
}

- (id)initWithFrame:(CGRect)frame
{	
	if (self = [super initWithFrame:frame])
	{
	    [self setBackgroundColor:[CPColor borderColor]];
	    
	    var myContentView = [[CPView alloc] initWithFrame:CGRectMake(1, 0, CGRectGetWidth(frame)-2, CGRectGetHeight(frame)-1)];
	    [self addSubview:myContentView];
	    
	    var welcomeTextView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [welcomeTextView setBackgroundColor:[CPColor whiteColor]];
        
        var oslImageView = [[CPImageView alloc] initWithFrame:CPMakeRect(0, 0, 150.0, 244.5)];
        [oslImageView setFrameOrigin:CPMakePoint((CGRectGetWidth([welcomeTextView bounds]) - 500.0) / 2.0, 10.0)];
		
		var oslImage = [[CPImage alloc] initByReferencingFile:@"Resources/Images/logo-new-mirror.png" size:CGSizeMake(300.0, 244.5)];
		[oslImageView setImage:oslImage];
		
		var welcomeText = [CPTextField labelWithTitle:[CPString stringWithFormat:@"Welcome to %s", [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"]]];
		[welcomeText setFont:[CPFont boldSystemFontOfSize:16.0]];
		[welcomeText sizeToFit];
		[welcomeText setCenter:CPMakePoint((CGRectGetWidth([welcomeTextView bounds]) + 320.0) / 2.0, 40 )];
		
		[welcomeTextView addSubview:oslImageView];
		[welcomeTextView addSubview:welcomeText];     
		
        var fakeBottomBarBorder = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 51.0)];
        [fakeBottomBarBorder setBackgroundColor:[CPColor colorWithHexString:@"7F7F7F"]];
        [fakeBottomBarBorder setFrameOrigin:CPMakePoint(0.0, CGRectGetHeight(frame) - 51.0)];
        
        var fakeBottomBar = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 50.0)];
        [fakeBottomBar setBackgroundColor:[CPColor colorWithHexString:@"D8D8D8"]];
        [fakeBottomBar setFrameOrigin:CPMakePoint(0.0, CGRectGetHeight(frame) - 50.0)];
        
        var closeButton = [[CPButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 24.0)];
        [closeButton setTitle:@"Close"];
        [closeButton setTarget:self];
        [closeButton setAction:@selector(close:)];
        [closeButton setCenter:CPMakePoint(CGRectGetWidth(frame) - (CGRectGetWidth([closeButton bounds]) / 2.0) - 10.0, CGRectGetHeight([closeButton bounds]))]

        showWindowOnLaunch = [CPCheckBox checkBoxWithTitle:[CPString stringWithFormat:@"Show this window when %s launches", [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"]]];
        [showWindowOnLaunch setFrameOrigin:CPMakePoint(10.0, CGRectGetHeight([showWindowOnLaunch bounds]))];
        [showWindowOnLaunch setTarget:self];
        [showWindowOnLaunch setAction:@selector(shouldShowWindowOnLaunch:)];
        
        var state = ([[CPUserDefaults standardUserDefaults] objectForKey:OLUserDefaultsShouldShowWelcomeWindowOnStartupKey]) ? CPOnState : CPOffState;
        [showWindowOnLaunch setState:state];
        [fakeBottomBar addSubview:showWindowOnLaunch];
		[fakeBottomBar addSubview:closeButton];
		
		var newProjectButton = [[CPButton alloc] initWithFrame:CGRectMake(0, 280.0, 370, 70)];
		var newProjectButtonImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/new-document.png"];
		var newProjectButtonPressedImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/new-document-pressed.png"];
		[newProjectButton setImage:newProjectButtonImage];
		[newProjectButton setBordered:NO];
		[newProjectButton setImageDimsWhenDisabled:YES];
		[newProjectButton setAlternateImage:newProjectButtonPressedImage];
        [newProjectButton setCenter:CPPointMake((CGRectGetWidth([welcomeTextView bounds]) + 320.0) / 2.0, 105.0)];
        [newProjectButton setTarget:self];
        [newProjectButton setAction:@selector(newProject:)];
        
        var newProjectButtonTitle = [CPTextField labelWithTitle:@"New Project"];
        var newProjectButtonDescription = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
            
        [newProjectButtonTitle setFont:[CPFont boldSystemFontOfSize:14.0]];
        [newProjectButtonDescription setFont:[CPFont boldSystemFontOfSize:12.0]];
        [newProjectButtonTitle setTextColor:[CPColor blackColor]];
        [newProjectButtonDescription setTextColor:[CPColor grayColor]];
        [newProjectButtonDescription setLineBreakMode:CPLineBreakByWordWrapping];
        [newProjectButtonDescription setStringValue:[CPString stringWithFormat:@"Get started with %s by creating a new project", 
            [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"]]];
        [newProjectButtonTitle sizeToFit];
        
        [newProjectButtonTitle setCenter:CGPointMake(450, 90)];
        [newProjectButtonDescription setCenter:CGPointMake(547, 125)];
		
		var helpButton = [[CPButton alloc] initWithFrame:CGRectMake(0, 360.0, 370, 70)];
		var helpButtonImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/help.png"];
		var helpButtonPressedImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/help-pressed.png"];
		[helpButton setImage:helpButtonImage];
		[helpButton setBordered:NO];
		[helpButton setImageDimsWhenDisabled:YES];
		[helpButton setAlternateImage:helpButtonPressedImage];
        [helpButton setCenter:CPPointMake((CGRectGetWidth([welcomeTextView bounds]) + 320.0) / 2.0, 187.0)];
        [helpButton setTarget:self];
        [helpButton setAction:@selector(help:)];
        
        var helpButtonTitle = [CPTextField labelWithTitle:@"Help Documentation"];
        var helpButtonDescription = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
            
        [helpButtonTitle setFont:[CPFont boldSystemFontOfSize:14.0]];
        [helpButtonDescription setFont:[CPFont boldSystemFontOfSize:12.0]];
        [helpButtonTitle setTextColor:[CPColor blackColor]];
        [helpButtonDescription setTextColor:[CPColor grayColor]];
        [helpButtonDescription setLineBreakMode:CPLineBreakByWordWrapping];
        [helpButtonDescription setStringValue:[CPString stringWithFormat:@"Get started with %s by reading the help documentation", 
            [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"]]];
        [helpButtonTitle sizeToFit];
        
        [helpButtonTitle setCenter:CGPointMake(480, 172)];
        [helpButtonDescription setCenter:CGPointMake(547, 207)];
		
		[myContentView addSubview:welcomeTextView];
		[myContentView addSubview:fakeBottomBarBorder];
		[myContentView addSubview:fakeBottomBar];
		
		[myContentView addSubview:helpButton];
		[myContentView addSubview:newProjectButton];
		
		[myContentView addSubview:newProjectButtonTitle];
		[myContentView addSubview:newProjectButtonDescription];
		
		[myContentView addSubview:helpButtonTitle];
		[myContentView addSubview:helpButtonDescription];
		
        [helpButtonTitle setNextResponder:helpButton];
        [helpButtonDescription setNextResponder:helpButton];
        [newProjectButtonTitle setNextResponder:newProjectButton];
        [newProjectButtonDescription setNextResponder:newProjectButton];
	}
	
	return self;
}

- (void)close:(id)sender
{
    if ([[self delegate] respondsToSelector:@selector(closeWelcomeWindow:)])
    {
        [[self delegate] closeWelcomeWindow:self];
    }
}

- (void)shouldShowWindowOnLaunch:(id)sender
{
    if ([[self delegate] respondsToSelector:@selector(showWindowOnLaunchDidChange:)])
    {
        [[self delegate] showWindowOnLaunchDidChange:([showWindowOnLaunch state] === CPOnState)];
    }
}

- (void)help:(id)sender
{
    [self close:sender];
    
    [[OLHelpManager sharedHelpManager] showHelp:sender];
}

- (void)newProject:(id)sender
{
    [self close:sender];
    
    [[self delegate] showNewProject:self];
}

@end
