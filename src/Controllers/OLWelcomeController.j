@import <Foundation/CPObject.j>

@import "../Views/OLWelcomeView.j"


/*!
 * The OLWelcomeController is a controller for the welcome views that decides
 * on how to handle the actions that occur in those views.
 */
@implementation OLWelcomeController : CPObject
{
	CPWindow            welcomeWindow;
	OLWelcomeView       welcomeView;
}

- (id)init
{
    self = [super init];
    
	if (self)
	{
        welcomeWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 700, 325) styleMask:CPTitledWindowMask];
        [welcomeWindow setTitle:[CPString stringWithFormat:@"Welcome to %s", [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"]]];
        var welcomeWindowContentView = [welcomeWindow contentView];
		
		welcomeView = [[OLWelcomeView alloc] initWithFrame:CPRectMake(0, 0, 700, 325)];
		[welcomeView setDelegate:self];
        
		[welcomeWindowContentView addSubview:welcomeView];
		
        [[CPApplication sharedApplication] runModalForWindow:welcomeWindow];
	}
	
	return self;
}

- (void)closeWelcomeWindow:(id)sender
{
    [[CPApplication sharedApplication] stopModal];
	[welcomeWindow orderOut:self];
}

- (void)showWindowOnLaunchDidChange:(BOOL)shouldShowWindowOnLaunch
{
    [[CPUserDefaults standardUserDefaults] setObject:shouldShowWindowOnLaunch forKey:OLUserDefaultsShouldShowWelcomeWindowOnStartupKey];
}

- (void)showNewProject:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:OLUploadWindowShouldStartUploadNotification object:self];
}

@end
