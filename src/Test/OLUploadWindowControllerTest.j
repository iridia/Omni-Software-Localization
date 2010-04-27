@implementation OLUploadWindowControllerTest : OJTestCase

- (void)testThatOLUploadWindowControllerDoesInitialize
{
    [self assertNotNull:[[OLUploadWindowController alloc] init]];
}

// - (void)testThatOLUploadWindowControllerDoesStartUpload
// {
//     var target = [[OLUploadWindowController alloc] init];
//     
//     [target startUpload:nil];
// }

- (void)testThatOLUploadWindowControllerDoesSubmitWhenUserSelectsFile
{
    var target = [[OLUploadWindowController alloc] init];
    
    var button = moq([[UploadButton alloc] initWithFrame:CGRectMakeZero()]);
    [button selector:@selector(submit) times:1];
    
    [target uploadButton:button didChangeSelection:nil];
    
    [button verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLUploadWindowControllerDoesCloseWindowWhenUploadBegins
{
    var target = [[OLUploadWindowController alloc] init];
    
    var uploadWindow = target.uploadWindow = moq(target.uploadWindow);
    
    [uploadWindow selector:@selector(close) times:1];

    [target uploadButtonDidBeginUpload:nil];

    [uploadWindow verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLUploadWindowControllerDoesGiveResponseToUploadController
{
    var target = [[OLUploadWindowController alloc] init];
    
    var uploadController = target.uploadController = moq(target.uploadController);
    var response = "{\"fileType\":\"test\"}";
    
    [uploadController selector:@selector(handleServerResponse:) times:1 arguments:[response]];

    [target uploadButton:nil didFinishUploadWithData:response];

    [uploadController verifyThatAllExpectationsHaveBeenMet];
}

@end