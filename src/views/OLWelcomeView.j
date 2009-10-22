@import "OLView.j"
@import "CPUploadButton.j"

/*!
 * OLWelcomeScreen
 *
 * The screen that is displayed to first-time visitors.
 */
@implementation OLWelcomeView : OLView

- (id)initWithFrame:(CGRect)frame withController:(OLWelcomeController)controller
{
	if(self = [super initWithFrame:frame withController:controller])
	{
        var welcomeText = [CPTextField labelWithTitle:@"Welcome to Omni Software Localization!"];
		var importText = [CPTextField labelWithTitle:@"Import localizable files in order for them to be translated!"];
        var localizeText = [CPTextField labelWithTitle:@"Start localizing applications from one language to another!"];
		var importButton = [[UploadButton alloc] initWithFrame:CGRectMakeZero()];
        var localizeButton = [CPButton buttonWithTitle:@"Localize"];
		var awesomeImage = [[CPImage alloc] initByReferencingFile:@"Resources/logo.png" size:CGSizeMake(150,150)];
		var imageView = [[CPImageView alloc] initWithFrame:CPMakeRect(180,40,150,150)];
		
		[imageView setImage:awesomeImage];

		[self setBackgroundColor:[CPColor whiteColor]];
		
        [welcomeText setFont:[CPFont boldSystemFontOfSize:18]];
        [welcomeText sizeToFit];
        [welcomeText setCenter:CGPointMake([self center].x, 25)];
		
		[importButton setTitle:@"Import"];
		[importButton sizeToFit];
		[importButton setDelegate:self];
		[importButton setURL:@"upload.php"];
		
        var views = [importText, localizeText, importButton, localizeButton, imageView]; //welcomeText];
        [self addViews:views];
				
		var point = [welcomeText center];
		point.y = point.y + 40;
		[importButton setFrameOrigin:point];
		point.y = point.y + 25;		
		[importText setFrameOrigin:point];
		
		point.y = point.y + 25;
		[localizeButton setFrameOrigin:point];
		point.y = point.y + 25;
		[localizeText setFrameOrigin:point];		
		
		[importText setTextColor:[CPColor grayColor]];
 		[localizeText setTextColor:[CPColor grayColor]];

		[importButton setTarget:self];
		
		[localizeButton setTarget:controller];
		[localizeButton setAction:@selector(transitionToResourceView:)];
        [localizeButton setEnabled:NO];     
	}
	return self;
}

- (void)uploadButton:(id)sender didChangeSelection:(CPString)selection
{
	[sender submit];
}

- (void)uploadButtonDidBeginUpload:(id)sender
{
	[_controller showUploading];
}

- (void)uploadButton:(id)sender didFinishUploadWithData:(CPString)response
{
	[_controller finishedUploadingWithResponse:response];
}

// - (void)drawRect:(CPRect)rect
// {
//  var bPath = [CPBezierPath bezierPathWithRect:rect];
//  
//  [bPath setLineWidth:5];
//  [bPath stroke];
// }

@end
