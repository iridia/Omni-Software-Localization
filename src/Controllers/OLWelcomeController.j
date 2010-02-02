@import <Foundation/CPObject.j>

@import "../Views/OLWelcomeView.j"

/*!
 * The OLWelcomeController is a controller for the welcome views that decides
 * on how to handle the actions that occur in those views.
 */
@implementation OLWelcomeController : CPObject
{
	CPWindow _welcomeWindow;
	OLWelcomeView _welcomeView;
	OLUploadController _uploadController @accessors(property=uploadController);
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

- (void)showWindowOnLaunchDidChange:(BOOL)shouldShowWindowOnLaunch
{
    [[CPUserDefaults standardUserDefaults] setObject:shouldShowWindowOnLaunch forKey:OLUserDefaultsShouldShowWelcomeWindowOnStartupKey];
}

@end
