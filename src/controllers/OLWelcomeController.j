@import <Foundation/CPObject.j>
@import "../views/OLWelcomeView.j"
@import "../views/OLResourceView.j"
@import "../views/OLUploadingView.j"
@import "../views/OLUploadedView.j"
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
	OLUploadingView _uploadingView;
	OLUploadedView _uploadedView;
	CPString _fileName;
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
	if (_uploadingView) { [_uploadingView removeFromSuperview]; }
	if (_uploadedView) { [_uploadedView removeFromSuperview]; }
	
	_resourceView = [[OLResourceView alloc] initWithFrame:[_contentView bounds] withController:[[OLResourceController alloc] init]];
	
	[_contentView addSubview:_resourceView];
}

- (void)showUploading
{	
	_uploadingView = [[OLUploadingView alloc] initWithFrame:CPRectMake(0,0,250,100) withController:self];
	[_uploadingView setCenter:CPPointMake([_contentView center].x, 45)];
	
	[_contentView addSubview:_uploadingView];
}

- (void)finishedUploadingWithResponse:(CPString)response
{
	_fileName = response;
	
	[_uploadingView removeFromSuperview];
	
	_uploadedView = [[OLUploadedView alloc] initWithFrame:CPRectMake(0,0,400,160) withController:self withFileName:response];
	[_uploadedView setCenter:CPPointMake([_contentView center].x, 75)];
	
	[_contentView addSubview:_uploadedView];
}

- (void)downloadFile:(id)sender
{
	window.open(_fileName);
}

@end