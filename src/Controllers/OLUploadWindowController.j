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
        uploadWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 384, 174) styleMask:CPTitledWindowMask | CPClosableWindowMask];
        [uploadWindow setTitle:@"New..."];
        [uploadWindow setDelegate:self];
        
        var uploadWindowContentView = [uploadWindow contentView];
        var bounds = [uploadWindowContentView bounds];
		
		var newProjectButton = [[UploadButton alloc] initWithFrame:CGRectMake(0, 0, 360, 70)];
		var newProjectButtonImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/big-button.png"];
		var newProjectButtonImagePressed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/big-button-pressed.png"];
		[newProjectButton setImage:newProjectButtonImage];
		[newProjectButton setBordered:NO];
		[newProjectButton setAlternateImage:newProjectButtonImagePressed];
		[newProjectButton setDelegate:self];
		[newProjectButton setURL:uploadURL];
		[newProjectButton setFrameOrigin:CGPointMake(12, 12)];
		
		var projectLabel = [CPTextField labelWithTitle:@"New Project..."];
		[projectLabel setFont:[CPFont boldSystemFontOfSize:14.0]];
		[projectLabel sizeToFit];
		[projectLabel setCenter:CGPointMake([newProjectButton center].x, 32)];
		
		var projectDescriptionLabel = [CPTextField labelWithTitle:@"Create a new project by uploading a Mac OS X .app bundle"];
		[projectDescriptionLabel setFont:[CPFont boldSystemFontOfSize:12.0]];
		[projectDescriptionLabel setTextColor:[CPColor grayColor]];
		[projectDescriptionLabel sizeToFit];
		[projectDescriptionLabel setCenter:CGPointMake([newProjectButton center].x, 52)];
		
		var newGlossaryButton = [[UploadButton alloc] initWithFrame:CGRectMake(0, 0, 360, 70)];
		var newGlossaryButtonImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/big-button.png"];
		var newGlossaryButtonImagePressed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/big-button-pressed.png"];
		[newGlossaryButton setImage:newGlossaryButtonImage];
		[newGlossaryButton setBordered:NO];
		[newGlossaryButton setAlternateImage:newGlossaryButtonImagePressed];
		[newGlossaryButton setDelegate:self];
		[newGlossaryButton setURL:uploadURL];
		[newGlossaryButton setFrameOrigin:CGPointMake(12, 94)];
		
		var glossaryLabel = [CPTextField labelWithTitle:@"New Glossary..."];
		[glossaryLabel setFont:[CPFont boldSystemFontOfSize:14.0]];
		[glossaryLabel sizeToFit];
		[glossaryLabel setCenter:CGPointMake([newGlossaryButton center].x, 114)];
		
		var glossaryDescriptionLabel = [CPTextField labelWithTitle:@"Create a glossary by uploading a .strings file"];
		[glossaryDescriptionLabel setFont:[CPFont boldSystemFontOfSize:12.0]];
		[glossaryDescriptionLabel setTextColor:[CPColor grayColor]];
		[glossaryDescriptionLabel sizeToFit];
		[glossaryDescriptionLabel setCenter:CGPointMake([newGlossaryButton center].x, 134)];
		
		[uploadWindowContentView addSubview:newProjectButton];
        [uploadWindowContentView addSubview:newGlossaryButton];
        [uploadWindowContentView addSubview:projectLabel];
        [uploadWindowContentView addSubview:projectDescriptionLabel];
        [uploadWindowContentView addSubview:glossaryLabel];
        [uploadWindowContentView addSubview:glossaryDescriptionLabel];
		
		[[CPNotificationCenter defaultCenter]
		  addObserver:self
		  selector:@selector(startUpload:)
		  name:@"OLUploadShouldStartNotification"
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
