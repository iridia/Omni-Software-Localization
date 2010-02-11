@import "CPUploadButton.j"

var BETA_TEXT = @"The Omni Software Localization tool is currently under construction,"+
" and as such, the development team and their affiliates (Omni Group and Rose-Hulman"+
" Institute of Technology) are not liable for the content or functionality of the"+
" application at this time. We provide no warranty, guarantee, or license, expressed or"+
" implied, for the accuracy or reliability of the information or services that the tool currently renders.";

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
	    var welcomeTextView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [welcomeTextView setBackgroundColor:[CPColor whiteColor]];
        
        var oslImageView = [[CPImageView alloc] initWithFrame:CPMakeRect(0, 0, 150.0, 244.5)];
        [oslImageView setFrameOrigin:CPMakePoint((CGRectGetWidth([welcomeTextView bounds]) - 500.0) / 2.0, 10.0)];
		
		var oslImage = [[CPImage alloc] initByReferencingFile:@"Resources/Images/logo-new-mirror.png" size:CGSizeMake(300.0, 244.5)];
		[oslImageView setImage:oslImage];
		
		var welcomeText = [CPTextField labelWithTitle:@"Welcome to Omni Software Localization!"];
		[welcomeText setFont:[CPFont boldSystemFontOfSize:16.0]];
		[welcomeText sizeToFit];
		[welcomeText setCenter:CPMakePoint((CGRectGetWidth([welcomeTextView bounds]) + 320.0) / 2.0, 40 )];
		
		var betaText = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([welcomeTextView bounds]) - 10.0, 100.0)];
		[betaText setStringValue:BETA_TEXT];
        [betaText setCenter:CPPointMake([welcomeTextView center].x, 350.0)];
        [betaText setLineBreakMode:CPLineBreakByWordWrapping];
        [betaText setAlignment:CPJustifiedTextAlignment];
		
		[welcomeTextView addSubview:oslImageView];
		[welcomeTextView addSubview:welcomeText];
		[welcomeTextView addSubview:betaText];        
		
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

        showWindowOnLaunch = [CPCheckBox checkBoxWithTitle:@"Show this window when OSL launches"];
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
		
		[self addSubview:welcomeTextView];
		[self addSubview:fakeBottomBarBorder];
		[self addSubview:fakeBottomBar];
		
		[self addSubview:helpButton];
		[self addSubview:newProjectButton];
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
