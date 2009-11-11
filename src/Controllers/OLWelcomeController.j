@import <Foundation/CPObject.j>
@import "../views/OLWelcomeView.j"
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
	OLResourceBundle _bundle @accessors(property=bundle, readonly);

	CPWindow _welcomeWindow;
	OLWelcomeView _welcomeView;

	id _delegate @accessors(property=delegate);
}

- (id)init
{
    self = [super init];
    
	if (self)
	{
        _welcomeWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 700, 250) styleMask:CPTitledWindowMask];
        [_welcomeWindow setTitle:@"Welcome to Omni Software Localization"];
        var welcomeWindowContentView = [_welcomeWindow contentView];
		
		_welcomeView = [[OLWelcomeView alloc] initWithFrame:CPRectMake(0,0,700,250)];
		[_welcomeView setDelegate:self];
        
		[welcomeWindowContentView addSubview:_welcomeView];
		
        [[CPApplication sharedApplication] runModalForWindow:_welcomeWindow];
	}
	
	return self;
}

- (void)transitionToResourceList:(id)sender
{
	[[CPApplication sharedApplication] stopModal];
	[_welcomeWindow orderOut:self];
	
	[_delegate sidebarSendMessage:@selector(selectResources)];
}

- (void)showUploading
{
    [[CPApplication sharedApplication] stopModal];
    [_welcomeWindow orderOut:self];
}

- (void)finishedUploadingWithResponse:(CPString)response
{
	console.log(response);
	
	var jsonResponse = eval('(' + response + ')');
	
	console.log(jsonResponse);
	
	var language = [OLLanguage english];
	
	_bundle = [[OLResourceBundle alloc] initWithLanguage:language];
	
	var resourceLineItems = [[CPArray alloc] init];
	
	var fileName = jsonResponse.fileName;
	var fileType = jsonResponse.fileType;
	var lineItemKeys = jsonResponse.dict.key;
	var lineItemStrings = jsonResponse.dict.string;	
	
	for(var i = 0; i < [lineItemKeys count]; i++)
	{
		[resourceLineItems addObject:[[OLLineItem alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i]]];
	}

	var resource = [[OLResource alloc] initWithFileName:fileName fileType:fileType lineItems:resourceLineItems];

    [_bundle insertObject:resource inResourcesAtIndex:0];

	[_bundle save];
}

@end