@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Views/CPUploadButton.j"
@import "OLLoginController.j"
@import "OLUploadController.j"
@import "../Utilities/OLConstants.j"
@import "../Views/OLUploadWindow.j"

@implementation OLUploadWindowController : CPObject
{
    OLUploadWindow      uploadWindow;
    OLUploadController  uploadController;
}

- (id)init
{
    self = [super init];
    
	if (self)
	{
	    uploadWindow = [[OLUploadWindow alloc] initWithContentRect:CGRectMake(0, 0, 384, 174) styleMask:CPTitledWindowMask | CPClosableWindowMask];
	    [uploadWindow setTitle:@"New..."];
        [uploadWindow setDelegate:self];
	    
		[[CPNotificationCenter defaultCenter]
		  addObserver:self
		  selector:@selector(startUpload:)
		  name:OLUploadWindowShouldStartUploadNotification
		  object:nil];
		
		uploadController = [[OLUploadController alloc] init];
	}
	
	return self;
}

- (void)startUpload:(id)sender
{
    if(![[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to create a new project/glossary!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(startUpload:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];
    
        [[CPNotificationCenter defaultCenter]
            postNotificationName:OLLoginControllerShouldLoginNotification
            object:nil
            userInfo:userInfo];
    
        return;
    }
    
    [[CPApplication sharedApplication] runModalForWindow:uploadWindow];
}

- (void)windowWillClose:(id)window
{
	[[CPApplication sharedApplication] stopModal];
}

@end

@implementation OLUploadWindowController (UploadButtonDelegate)

- (void)uploadButton:(id)sender didChangeSelection:(CPString)selection
{   
	[sender submit];
}

- (void)uploadButtonDidBeginUpload:(id)sender
{
	[uploadWindow close];
}

- (void)uploadButton:(id)sender didFinishUploadWithData:(CPString)response
{
	[uploadController handleServerResponse:response];
}

@end
