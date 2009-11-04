@import "OLView.j"

/*!
 * OLUploadedView
 *
 * The screen that is displayed when something is finished uploading.
 */
@implementation OLUploadedView : OLView
{
	CPString _fileName;
	OLView _currentView;
}

- (id)initWithFrame:(CGRect)frame withController:(OLWelcomeController)controller withFileName:(CPString)aFileName
{
	if(self = [super initWithFrame:frame withController:controller])
	{
		_fileName = aFileName;
		
		var uploadedText = [CPTextField labelWithTitle:@"Finished Uploading "+aFileName+"!"];
		var localizeButton = [CPButton buttonWithTitle:@"Localize"];
		var localizeText = [CPTextField labelWithTitle:@"Start localizing applications from one language to another!"];
		
		_currentView = [[OLView alloc] initWithFrame:CPMakeRect(0,0,CGRectGetWidth(frame),CGRectGetHeight(frame)) withController:controller];
		
		[uploadedText setFont:[CPFont boldSystemFontOfSize:18]];
		[uploadedText sizeToFit];
		[uploadedText setCenter:CGPointMake([self center].x, 25)];
				
		[self setBackgroundColor: [CPColor whiteColor]];
				
		var point = [uploadedText center];
		point.y = point.y + 45;
		[localizeButton setCenter:point];
		point.y = point.y + 25;
		[localizeText setCenter:point];		
		
 		[localizeText setTextColor:[CPColor grayColor]];
		
		[_currentView addViews:new Array(uploadedText, localizeButton, localizeText)];
		
		[self addSubview:_currentView];
		
		[localizeButton setTarget:controller];
		[localizeButton setAction:@selector(transitionToResourceView:)];
	}
	
	return self;
}

- (void)drawRect:(CPRect)rect
{
	var bPath = [CPBezierPath bezierPathWithRect:rect];
	
	[bPath setLineWidth:5];
	[bPath stroke];
}

@end