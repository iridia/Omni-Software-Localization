@import <Foundation/CPObject.j>
@import "../views/OLWelcomeView.j"
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
        _welcomeWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 700, 325) styleMask:CPTitledWindowMask];
        [_welcomeWindow setTitle:@"Welcome to Omni Software Localization"];
        var welcomeWindowContentView = [_welcomeWindow contentView];
		
		_welcomeView = [[OLWelcomeView alloc] initWithFrame:CPRectMake(0, 0, 700, 325)];
		[_welcomeView setDelegate:self];
        
		[welcomeWindowContentView addSubview:_welcomeView];
		
        [[CPApplication sharedApplication] runModalForWindow:_welcomeWindow];
	}
	
	return self;
}

- (void)closeWelcomeWindow:(id)sender
{
    [[CPApplication sharedApplication] stopModal];
	[_welcomeWindow orderOut:self];
}

- (void)transitionToResourceList:(id)sender
{	
    [self closeWelcomeWindow:self];
	[_delegate sidebarSendMessage:@selector(selectResources)];
}

- (void)showUploading
{
    [self closeWelcomeWindow:self];
}

- (void)finishedUploadingWithResponse:(CPString)response
{
	response = response.replace("<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">", "");
	response = response.replace("\n</pre>", "");
	
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
