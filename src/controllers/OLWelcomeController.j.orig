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
    // OLResourceView _resourceView;
	OLUploadingView _uploadingView;
	OLUploadedView _uploadedView;
<<<<<<< HEAD
	CPString _fileName;
	id _delegate @accessors(property=delegate);
	SEL _finishedReadingResourceBundle;
	OLResourceBundle _bundle @accessors(property=bundle, readonly);
=======
	OLResourceBundle _bundle;	
>>>>>>> beebe8451cab8f0fe44b8cfc80b4e11471d979e9
}

- (id)initWithContentView:(CPView)contentView
{
    self = [super init];
    
	if (self)
	{
		_contentView = contentView;
		_finishedReadingResourceBundle = @selector(finishedReadingResourceBundle:);
		
        _welcomeWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(200, 100, 700, 200) styleMask:CPTitledWindowMask];
        [_welcomeWindow setTitle:@"Welcome to Omni Software Localization"];
        var welcomeWindowContentView = [_welcomeWindow contentView];
		
		_welcomeView = [[OLWelcomeView alloc] initWithFrame:CPRectMake(0,0,700,200) withController:self];
        
        // [_welcomeView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin | CPViewMinYMargin];
		
		[welcomeWindowContentView addSubview:_welcomeView];
		[[CPApplication sharedApplication] runModalForWindow:_welcomeWindow];
	}
	
	return self;
}

- (void)transitionToResourceView:(id)sender
{
    [[CPApplication sharedApplication] stopModal];
    [_welcomeWindow orderOut:self];
    
	if (_uploadingView) { [_uploadingView removeFromSuperview]; }
	if (_uploadedView) { [_uploadedView removeFromSuperview]; }
	
<<<<<<< HEAD
	var resource1LineItems = [[CPArray alloc] init];
	[resource1LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"title" withValue:@"Project OSL"]];
	[resource1LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"developer" withValue:@"developer"]];
	[resource1LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"localizer" withValue:@"localizer"]];
	[resource1LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"user" withValue:@"user"]];
	[resource1LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"community" withValue:@"community"]];
	[resource1LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"opensource" withValue:@"open source"]];
	
	var resource2LineItems = [[CPArray alloc] init];
	[resource2LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"title" withValue:@"Welcome to Project OSL!"]];
	[resource2LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"localizeButton" withValue:@"Localize"]];
	[resource2LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"uploadButton" withValue:@"Import"]];
	[resource2LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"localizeString" withValue:@"Start localizing applications from one language to another!"]];
	[resource2LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"importString" withValue:@"Import localizable files in order for them to be translated!"]];
	
	var resource3LineItems = [[CPArray alloc] init];
	[resource3LineItems addObject:[[OLLineItem alloc] initWithIdentifier:@"title" withValue:@"Resource Bundle in "]];
	
	var bundle = [[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]];
	[bundle addResource:[[OLResource alloc] initWithFilename:@"ProjectOSL" withFileType:@"xml" withLineItems:resource1LineItems]];
	[bundle addResource:[[OLResource alloc] initWithFilename:@"Welcome" withFileType:@"xml" withLineItems:resource2LineItems]];
	[bundle addResource:[[OLResource alloc] initWithFilename:@"ResourceView" withFileType:@"xml" withLineItems:resource3LineItems]];
=======
	var resourceBundleController = [[OLResourceBundleController alloc] initWithBundle:_bundle];
	_resourceView = [[OLResourceBundleView alloc] initWithFrame:[_contentView bounds] withController:resourceBundleController];
>>>>>>> beebe8451cab8f0fe44b8cfc80b4e11471d979e9
	
	_bundle = bundle;
	
	if ([_delegate respondsToSelector:_finishedReadingResourceBundle])
	{
	    [_delegate finishedReadingResourceBundle:self];
	}
}

- (void)showUploading
{	
	_uploadingView = [[OLUploadingView alloc] initWithFrame:CPRectMake(0,0,250,100) withController:self];
	[_uploadingView setCenter:CPPointMake([_contentView center].x, 45)];
	
	[_contentView addSubview:_uploadingView];
}

- (void)finishedUploadingWithResponse:(CPString)response
{
	var jsonResponse = eval('(' + response + ')');
	
	var keys = jsonResponse.plist.dict.key;
	var values = jsonResponse.plist.dict.string;
	
	_bundle = [[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]];	
	var resourceLineItems = [[CPArray alloc] init];
	
	for(var i = 0; i < [keys count]; i++)
	{
		[resource1LineItems addObject:[[OLLineItem alloc] initWithIdentifier:[keys objectAtIndex:i] withValue:[values objectAtIndex:i]]];
	}
	[_bundle addResource:[[OLResource alloc] initWithFilename:@"Your File" withFileType:@"plist" withLineItems:resourceLineItems]];
	
		
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