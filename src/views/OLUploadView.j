@import "OLView.j"

/*!
 * OLUploadView
 *
 * The screen that is displayed when something is uploading.
 */
@implementation OLUploadView : OLView
{
	CPString _fileName;
	OLView _currentView;
}

- (id)initWithFrame:(CGRect)frame withController:(OLWelcomeController)controller
{
	if(self = [super initWithFrame:frame withController:controller])
	{
		var uploadingText = [CPTextField labelWithTitle:@"Uploading..."];
		
		_currentView = [[OLView alloc] initWithFrame:CPMakeRect(0,0,CGRectGetWidth(frame),CGRectGetHeight(frame)) withController:controller];
		
		[uploadingText setFont:[CPFont boldSystemFontOfSize:18]];
		[uploadingText sizeToFit];
		[uploadingText setCenter:CGPointMake([self center].x, 25)];
		
		var spinner = [[CPImage alloc] initByReferencingFile:@"Resources/upload_spinner.gif" size:CGSizeMake(24,24)];
		var imageView = [[CPImageView alloc] initWithFrame:CPMakeRect(0,0,24,24)];
		[imageView setCenter:CGPointMake([self center].x, 65)];
		[imageView setImage:spinner];
		
		[self setBackgroundColor: [CPColor whiteColor]];
		
		[_currentView addSubview:uploadingText];
		[_currentView addSubview:imageView];
		
		[self addSubview:_currentView];
	}
	
	return self;
}

- (void)finishedUploadingWithFilename:(CPString)aFileName
{
	_fileName = aFileName;
	
	var finishedText = [CPTextField labelWithTitle:@"Finished!"];
	[finishedText setFont:[CPFont boldSystemFontOfSize:18]];
	[finishedText sizeToFit];
	[finishedText setCenter:CGPointMake([_currentView center].x, 25)];
	
	var newView = [[CPView alloc] initWithFrame:[_currentView frame]];
	[newView addSubview:finishedText];
	
	[self replaceSubview:_currentView with:newView];
}

- (void)drawRect:(CPRect)rect
{
	var bPath = [CPBezierPath bezierPathWithRect:rect];
	
	[bPath setLineWidth:5];
	[bPath stroke];
}

@end