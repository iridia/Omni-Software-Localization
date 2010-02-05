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
        
        var oslImageView = [[CPImageView alloc] initWithFrame:CPMakeRect(0, 0, 150.0, 150.0)];
        [oslImageView setFrameOrigin:CPMakePoint((CGRectGetWidth([welcomeTextView bounds]) - 150.0) / 2.0, 10.0)];
		
		var oslImage = [[CPImage alloc] initByReferencingFile:@"Resources/Images/logo.png" size:CGSizeMake(150.0, 150.0)];
		[oslImageView setImage:oslImage];
		
		var welcomeText = [CPTextField labelWithTitle:@"Welcome to Omni Software Localization!"];
		[welcomeText setFont:[CPFont boldSystemFontOfSize:16.0]];
		[welcomeText sizeToFit];
		[welcomeText setCenter:CPMakePoint(CGRectGetWidth([welcomeTextView bounds]) / 2.0, CGRectGetHeight([oslImageView bounds]) + 20.0 )];
		
		var betaText = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([welcomeTextView bounds]) - 10.0, 100.0)];
		[betaText setStringValue:BETA_TEXT];
        [betaText setCenter:CPPointMake([welcomeTextView center].x, 250.0)];
        [betaText setLineBreakMode:CPLineBreakByWordWrapping];
        [betaText setAlignment:CPJustifiedTextAlignment];
		
		[welcomeTextView addSubview:oslImageView];
		[welcomeTextView addSubview:welcomeText];
		[welcomeTextView addSubview:betaText];        
        
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
		
		[self addSubview:welcomeTextView];
		[self addSubview:fakeBottomBar];
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

@end
