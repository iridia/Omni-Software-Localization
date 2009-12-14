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
	id _delegate @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)frame
{	
	if (self = [super initWithFrame:frame])
	{
	    var welcomeTextView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) - 200.0, CGRectGetHeight(frame))];
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
		
        var quickLinksView = [[CPView alloc] initWithFrame:CGRectMake(CGRectGetWidth([welcomeTextView bounds]), 0, 200.0, CGRectGetHeight(frame))];
        [quickLinksView setBackgroundColor:[CPColor colorWithHexString:@"EEEEEE"]];

		var importButton = [[UploadButton alloc] initWithFrame:CGRectMakeZero()];
		[importButton setTitle:@"Import"];
		[importButton sizeToFit];
		[importButton setDelegate:self];
		[importButton setURL:@"Upload/upload.php"];
		[importButton setCenter:CPMakePoint(CGRectGetWidth([quickLinksView bounds]) / 2.0, 40.0)];
		
        var importText = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([quickLinksView bounds]) - 10.0, 48.0)];
        [importText setStringValue:@"Import localizable files in order for them to be translated!"];
		[importText setTextColor:[CPColor grayColor]];
		[importText setCenter:CPMakePoint(CGRectGetWidth([quickLinksView bounds]) / 2.0, 80.0)];
        [importText setLineBreakMode:CPLineBreakByWordWrapping];

        var localizeButton = [CPButton buttonWithTitle:@"Localize"];
        [localizeButton setCenter:CPMakePoint(CGRectGetWidth([quickLinksView bounds]) / 2.0, 130.0)];
        [localizeButton setTarget:self];
		[localizeButton setAction:@selector(transitionToResourceList:)];
		
        var localizeText = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([quickLinksView bounds]) - 10.0, 48.0)];
        [localizeText setStringValue:@"Start localizing applications from one language to another!"];
        [localizeText setLineBreakMode:CPLineBreakByWordWrapping];
 		[localizeText setTextColor:[CPColor grayColor]];
 		[localizeText setCenter:CPMakePoint(CGRectGetWidth([quickLinksView bounds]) / 2.0, 170.0)];
        
        [quickLinksView addSubview:importButton];
        [quickLinksView addSubview:importText];
        [quickLinksView addSubview:localizeButton];
        [quickLinksView addSubview:localizeText];
        
        
        var fakeBottomBar = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 50.0)];
        [fakeBottomBar setBackgroundColor:[CPColor colorWithHexString:@"D8D8D8"]];
        [fakeBottomBar setFrameOrigin:CPMakePoint(0.0, CGRectGetHeight(frame) - 50.0)];
        
        var closeButton = [[CPButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 24.0)];
        [closeButton setTitle:@"Close"];
        [closeButton setTarget:self];
        [closeButton setAction:@selector(close:)];
        [closeButton setCenter:CPMakePoint(CGRectGetWidth(frame) - (CGRectGetWidth([closeButton bounds]) / 2.0) - 10.0, CGRectGetHeight([closeButton bounds]))]
		
		// Uncomment these lines to add a checkbox that allows the user to select if this window should show on startup
        // var showWindowOnLaunch = [CPCheckBox checkBoxWithTitle:@"Show this window when OSL launches"];
        // [showWindowOnLaunch setFrameOrigin:CPMakePoint(10.0, CGRectGetHeight([showWindowOnLaunch bounds]))];
        // 
        // [fakeBottomBar addSubview:showWindowOnLaunch];
		[fakeBottomBar addSubview:closeButton];
		
		[self addSubview:welcomeTextView];
		[self addSubview:quickLinksView];
		[self addSubview:fakeBottomBar];
	}
	
	return self;
}

- (void)close:(id)sender
{
    if ([_delegate respondsToSelector:@selector(closeWelcomeWindow:)])
    {
        [_delegate closeWelcomeWindow:self];
    }
}

- (void)uploadButton:(id)sender didChangeSelection:(CPString)selection
{
	[sender submit];
}

- (void)uploadButtonDidBeginUpload:(id)sender
{
	[_delegate showUploading];
}

- (void)uploadButton:(id)sender didFinishUploadWithData:(CPString)response
{
	[_delegate finishedUploadingWithResponse:response];
}

- (void)transitionToResourceList:(id)sender
{
	[_delegate transitionToResourceList:sender];
}

@end
