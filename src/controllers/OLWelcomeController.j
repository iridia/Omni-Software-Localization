@import <Foundation/CPObject.j>
@import "../views/OLWelcomeView.j"
@import "../views/OLResourceView.j"
@import "../views/OLUploadView.j"
@import "OLResourceController.j"

/*!
 * The OLWelcomeController is a controller for the welcome views that decides
 * on how to handle the actions that occur in those views.
 */
@implementation OLWelcomeController : CPObject
{
	CPView _contentView;
	OLWelcomeView _welcomeView;
	OLResourceView _resourceView;
	OLUploadView _uploadView;
}

- (id)initWithContentView:(CPView)contentView
{
	if(self = [super init])
	{
		_contentView = contentView
		
		_welcomeView = [[OLWelcomeView alloc] initWithFrame:CPRectMake(0,0,700,200) withController:self];
		[_welcomeView setCenter:[_contentView center]];
		
		[_welcomeView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin | CPViewMinYMargin];
		
		[_contentView addSubview:_welcomeView];
		[_contentView setBackgroundColor: [CPColor colorWithHexString:@"AAAAAA"]];
	}
	return self;
}

- (void)transitionToResourceView:(id)sender
{
	[_welcomeView removeFromSuperview];
	
	_resourceView = [[OLResourceView alloc] initWithFrame:[_contentView bounds] withController:[[OLResourceController alloc] init]];
	
	[_contentView addSubview:_resourceView];
}

- (void)showUploading
{	
	_uploadView = [[OLUploadView alloc] initWithFrame:CPRectMake(0,0,250,100) withController:self];
	[_uploadView setCenter:CPPointMake([_contentView center].x, 45)];
	
	[_contentView addSubview:_uploadView];
}

- (void)finishedUploadingWithResponse:(CPString)response
{
	[_uploadView finishedUploadingWithFilename:response];
}

@end