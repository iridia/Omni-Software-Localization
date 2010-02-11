@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Views/CPUploadButton.j"
@import "OLLoginController.j"
@import "OLUploadController.j"

var uploadURL = @"Upload/upload.php";

@implementation OLUploadWindowController : CPObject
{
    CPWindow            uploadWindow;
    OLUploadController  uploadController;
}

- (id)init
{
    self = [super init];
    
	if (self)
	{
        uploadWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 100) styleMask:CPTitledWindowMask | CPClosableWindowMask];
        [uploadWindow setTitle:@"New..."];
        [uploadWindow setDelegate:self];
        
        var uploadWindowContentView = [uploadWindow contentView];
        var bounds = [uploadWindowContentView bounds];
		
		var uploadView = [[CPView alloc] initWithFrame:[uploadWindowContentView bounds]];
		
		var projectView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bounds) / 2.0, CGRectGetHeight(bounds))];
		
		var projectText = [[CPTextField alloc] initWithFrame:CGRectMake(10.0, 10.0, CGRectGetWidth([projectView bounds]) - 20.0, CGRectGetHeight([projectView bounds]) - 20.0 - 32.0)];
		[projectText setStringValue:@"Select and Upload an application (.app)"];
		[projectText setFont:[CPFont boldSystemFontOfSize:12.0]];
		[projectText setLineBreakMode:CPLineBreakByWordWrapping];
		[projectText setAlignment:CPCenterTextAlignment];
		
		[projectView addSubview:projectText];
		
		var projectButton = [[UploadButton alloc] initWithFrame:CGRectMakeZero()];
		[projectButton setTitle:@"New Project"];
		[projectButton sizeToFit];
		[projectButton setDelegate:self];
		[projectButton setURL:uploadURL];
		[projectButton setCenter:CPMakePoint(CGRectGetWidth([projectView bounds]) / 2.0, CGRectGetHeight([projectView bounds]) - 32.0)];
		
		[projectView addSubview:projectButton];

		[uploadView addSubview:projectView];

		
		var glossaryView = [[CPView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) / 2.0, 0, CGRectGetWidth(bounds) / 2.0, CGRectGetHeight(bounds))];
		
		var glossaryText = [[CPTextField alloc] initWithFrame:CGRectMake(10.0, 10.0, CGRectGetWidth([projectView bounds]) - 20.0, CGRectGetHeight([projectView bounds]) - 20.0 - 32.0)];
		[glossaryText setStringValue:@"Select and Upload a glossary (.strings)"];
		[glossaryText setFont:[CPFont boldSystemFontOfSize:12.0]];
		[glossaryText setLineBreakMode:CPLineBreakByWordWrapping];
		[glossaryText setAlignment:CPCenterTextAlignment];
		
		[glossaryView addSubview:glossaryText];
		
		var glossaryButton = [[UploadButton alloc] initWithFrame:CGRectMakeZero()];
		[glossaryButton setTitle:@"New Glossary"];
		[glossaryButton sizeToFit];
		[glossaryButton setDelegate:self];
		[glossaryButton setURL:uploadURL];
		[glossaryButton setCenter:CPMakePoint(CGRectGetWidth([glossaryView bounds]) / 2.0, CGRectGetHeight([glossaryView bounds]) - 32.0)];
		
		[glossaryView addSubview:glossaryButton];

		[uploadView addSubview:glossaryView];
		
		[[CPNotificationCenter defaultCenter]
		  addObserver:self
		  selector:@selector(startUpload:)
		  name:@"OLUploadShouldStartNotification"
		  object:nil];
        
		[uploadWindowContentView addSubview:uploadView];
		
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
