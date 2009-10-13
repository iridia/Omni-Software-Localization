@import "OLView.j"

/*!
 * OLUploadedView
 *
 * The screen that is displayed when something is uploading.
 */
@implementation OLUploadedView : OLView
{
	CPString _fileName;
}

- (id)initWithFrame:(CGRect)frame withFilename:(CPString)fileName withController:(AppController)controller
{
	if(self = [super initWithFrame:frame withController:controller])
	{
		_fileName = fileName;
		
		// do stuff.. not sure yet what
		alert(fileName);
	}
}

@end