@import <AppKit/CPView.j>
@import "CPUploadButton.j"

// OLWelcomeScreen
//
// The screen that is displayed to first-time visitors.
@implementation OLWelcomeScreen : CPView
{
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		var welcomeText = [CPTextField labelWithTitle:@"Welcome to Omni Software Localization!"];
		var importText = [CPTextField labelWithTitle:@"Import localizable files in order for them to be translated!"];
		var localizeText = [CPTextField labelWithTitle:@"Start localizing applications from one language to another!"];
		var importButton = [[UploadButton alloc] initWithFrame:CGRectMakeZero()];
		var localizeButton = [CPButton buttonWithTitle:@"Localize"];
		var awesomeImage = [[CPImage alloc] initByReferencingFile:@"http://www.gstatic.com/hostedimg/dbf8ffc7c45dee79_large" size:CGSizeMake(200,100)];
		var imageView = [[CPImageView alloc] initWithFrame:CPMakeRect(250,60,75,100)];
		
		[imageView setImage:awesomeImage];
		
		[self addSubview:welcomeText];
		[self addSubview:importText];
		[self addSubview:localizeText];
		[self addSubview:importButton];
		[self addSubview:localizeButton];
		[self addSubview:imageView];
		[self setBackgroundColor: [CPColor whiteColor]];
		
		[welcomeText setFont:[CPFont boldSystemFontOfSize:18]];
		[welcomeText sizeToFit];
		[welcomeText setCenter:CGPointMake([self center].x, 40)];
		
		[importButton setTitle:@"Import"];
		[importButton sizeToFit];
		[importButton setDelegate:self];
				
		var point = [welcomeText center];
		point.y = point.y + 25;
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
		[importButton setAction:@selector(uploadFile:)];
		
		[localizeButton setTarget:self];
		[localizeButton setAction:@selector(startLocalizing:)];		
	}
	return self;
}

- (void)startLocalizing:(id)sender
{
	// TODO: Go to localizing screen
}

- (void)uploadButton:(id)sender didChangeSelection:(CPString)selection
{
	[sender submit];
}

- (void)uploadButtonDidBeginUpload:(id)sender
{
	// TODO: Begin Upload Stuff
}

- (void)uploadDidFinishWithResponse:(id)sender
{
	// TODO: Upload finished stuff
}

- (void)drawRect:(CPRect)rect
{
	var bPath = [CPBezierPath bezierPathWithRect:rect];
	
	[bPath setLineWidth:5];
	[bPath stroke];
}

@end
