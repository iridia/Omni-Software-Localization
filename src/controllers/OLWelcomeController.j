@import <Foundation/CPObject.j>
@import "../views/OLWelcomeView.j"
@import "../views/OLResourceBundleView.j"
@import "../views/OLUploadingView.j"
@import "../views/OLUploadedView.j"
@import "OLResourceBundleController.j"
@import "../models/OLResourceBundle.j"
@import "../models/OLLanguage.j"
@import "../models/OLResource.j"
@import "../models/OLLineItem.j"

/*!
 * The OLWelcomeController is a controller for the welcome views that decides
 * on how to handle the actions that occur in those views.
 */
@implementation OLWelcomeController : CPObject
{
	CPView _contentView;
	CPWindow _welcomeWindow;
	OLWelcomeView _welcomeView;
	OLUploadingView _uploadingView;
	OLUploadedView _uploadedView;
	id _delegate @accessors(property=delegate);
	SEL _finishedReadingResourceBundle;
	OLResourceBundle _bundle @accessors(property=bundle, readonly);
}

- (id)initWithContentView:(CPView)contentView
{
    self = [super init];
    
	if (self)
	{
		_contentView = contentView;
		_finishedReadingResourceBundle = @selector(finishedReadingResourceBundle:);
		
        _welcomeWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 700, 150) styleMask:CPTitledWindowMask];
        [_welcomeWindow setTitle:@"Welcome to Omni Software Localization"];
        var welcomeWindowContentView = [_welcomeWindow contentView];
		
		_welcomeView = [[OLWelcomeView alloc] initWithFrame:CPRectMake(0,0,700,150) withController:self];
        
		[welcomeWindowContentView addSubview:_welcomeView];
		
        // [[CPApplication sharedApplication] runModalForWindow:_welcomeWindow];
	}
	
	return self;
}

- (void)transitionToResourceView:(id)sender
{
    [[CPApplication sharedApplication] stopModal];
    [_welcomeWindow orderOut:self];
    
	if (_uploadingView) { [_uploadingView removeFromSuperview]; }
	if (_uploadedView) { [_uploadedView removeFromSuperview]; }
	
	if ([_delegate respondsToSelector:_finishedReadingResourceBundle])
	{
	    [_delegate finishedReadingResourceBundle:self];
	}
}

- (void)showUploading
{
    [[CPApplication sharedApplication] stopModal];
    [_welcomeWindow orderOut:self];
    
	_uploadingView = [[OLUploadingView alloc] initWithFrame:CPRectMake(0,0,250,100) withController:self];
	[_uploadingView setCenter:CPPointMake([_contentView center].x, 45)];
	
	[_contentView addSubview:_uploadingView];
}

- (void)finishedUploadingWithResponse:(CPString)response
{
	var jsonResponse = eval('(' + response + ')');
	
	_bundle = [[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]];	
	var resourceLineItems = [[CPArray alloc] init];

	[_bundle addResource:[[OLResource alloc] initWithFilename:@"Your File" withFileType:@"plist" withLineItems:resourceLineItems]];	
		
	[_uploadingView removeFromSuperview];
	
	_uploadedView = [[OLUploadedView alloc] initWithFrame:CPRectMake(0,0,400,160) withController:self withFileName:@"Your File"];
	[_uploadedView setCenter:CPPointMake([_contentView center].x, 75)];
	
	[_contentView addSubview:_uploadedView];
}

- (void)downloadFile:(id)sender
{
	window.open(_fileName);
}

@end