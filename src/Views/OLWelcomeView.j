@import "OLView.j"
@import "CPUploadButton.j"
@import "CPTextView.j"

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
		var betaText = [[CPTextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 650, 100)]
		var imageView = [[CPImageView alloc] initWithFrame:CPMakeRect(180,0,150,150)];
		
		[imageView setImage:awesomeImage];

		[self setBackgroundColor:[CPColor whiteColor]];
		
		[importButton setTitle:@"Import"];
		[importButton sizeToFit];
		[importButton setDelegate:self];
		[importButton setURL:@"upload.php"];
		
		[betaText setStringValue:BETA_TEXT];
		[betaText setFrameOrigin:point];
		[betaText setCenter:CPPointMake([self center].x, 200)];
		
        var views = [importText, localizeText, betaText, importButton, localizeButton, imageView]; //welcomeText];
        [self addViews:views];
				
		var point = CGPointMake([self center].x, 25);
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
		[localizeButton setAction:@selector(transitionToResourceList:)];    
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
