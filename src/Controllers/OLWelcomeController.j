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
        [_welcomeWindow setTitle:[CPString stringWithFormat:@"Welcome to %s", [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"]]];
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

- (void)showWindowOnLaunchDidChange:(BOOL)shouldShowWindowOnLaunch
{
    [[CPUserDefaults standardUserDefaults] setObject:shouldShowWindowOnLaunch forKey:OLUserDefaultsShouldShowWelcomeWindowOnStartupKey];
}

- (void)showNewProject:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"OLUploadShouldStartNotification" object:self];
}

@end
