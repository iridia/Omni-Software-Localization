@import "OLView.j"

/*!
 * OLUploadingView
 *
 * The screen that is displayed when something is uploading.
 */
@implementation OLUploadingView : OLView
{
}

- (id)initWithFrame:(CGRect)frame withController:(OLWelcomeController)controller
{
	if(self = [super initWithFrame:frame withController:controller])
	{
		var uploadingText = [CPTextField labelWithTitle:@"Uploading..."];
		
		[uploadingText setFont:[CPFont boldSystemFontOfSize:18]];
		[uploadingText sizeToFit];
		[uploadingText setCenter:CGPointMake([self center].x, 25)];
		
		var spinner = [[CPImage alloc] initByReferencingFile:@"Resources/upload_spinner.gif" size:CGSizeMake(24,24)];
		var imageView = [[CPImageView alloc] initWithFrame:CPMakeRect(0,0,24,24)];
		[imageView setCenter:CGPointMake([self center].x, 65)];
		[imageView setImage:spinner];
		
		[self setBackgroundColor: [CPColor whiteColor]];
		
		[self addSubview:uploadingText];
		[self addSubview:imageView];
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