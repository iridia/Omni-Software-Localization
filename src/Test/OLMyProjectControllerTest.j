@import <AppKit/AppKit.j>
@import "../Controllers/OLMyProjectController.j"
@import "utilities/Observer.j"
@import "utilities/CPNotificationCenter+MockDefaultCenter.j"

[CPApplication sharedApplication];
_DOMElement = moq();
_DOMElement.appendChild = function(){return moq();};

@implementation OLMyProjectControllerTest : OJTestCase

- (void)setUp
{
    [CPNotificationCenter setIsMocked:NO];
    [CPNotificationCenter reset];
    urlConnection = moq();
    [OLURLConnectionFactory setConnectionFactoryMethod:function(request, delegate)
    {
        return [urlConnection createConnectionWithRequest:request delegate:delegate];
    }];
}

- (void)tearDown
{
    [OLURLConnectionFactory setConnectionFactoryMethod:nil];
}

- (void)testThatOLMyProjectControllerDoesInitialize
{
    [self assertNotNull:[[OLMyProjectController alloc] init]];
}

- (void)testThatOLProjectControllerDoesRegisterForImportNotification
{
    var target = [[OLMyProjectController alloc] init];

    [self assert:target registered:@"OLProjectShouldImportNotification"];
}

- (void)testThatOLMyProjectControllerDoesRegisterForParseServerResponseNotification
{
    var target = [[OLMyProjectController alloc] init];

    [self assert:target registered:@"OLUploadControllerDidParseServerResponse"];
}

- (void)testThatOLMyProjectControllerDoesRegisterForOutlineViewSelectionDidChangeNotification
{
    var target = [[OLMyProjectController alloc] init];

    [self assert:target registered:CPOutlineViewSelectionDidChangeNotification];
}

- (void)testThatOLMyProjectControllerDoesRegisterForOLProjectDidChangeNotification
{
    var target = [[OLMyProjectController alloc] init];
    
    [self assert:target registered:@"OLProjectDidChangeNotification"];
}

- (void)testThatOLMyProjectControllerDoesRegisterForOLProjectShouldReloadMyProjectsNotification
{
    var target = [[OLMyProjectController alloc] init];
    
    [self assert:target registered:OLProjectShouldReloadMyProjectsNotification];
}


- (void)testThatOLMyProjectControllerDoesRegisterForOLUserSessionManagerUserDidChangeNotification
{
    var target = [[OLMyProjectController alloc] init];
    
    [self assert:target registered:OLUserSessionManagerUserDidChangeNotification];
}


- (void)testThatOLMyProjectControllerDoesRegisterForOLLineItemSelectedLineItemIndexDidChangeNotification
{
    var target = [[OLMyProjectController alloc] init];
    
    [self assert:target registered:OLLineItemSelectedLineItemIndexDidChangeNotification];
}

- (void)testThatOLMyProjectControllerDoesRegisterForCPLanguageShouldAddLanguageNotification
{
    var target = [[OLMyProjectController alloc] init];
    
    [self assert:target registered:OLProjectShouldCreateBundleNotification];
}

- (void)testThatOLMyProjectControllerDoesRegisterForCPLanguageShouldDeleteLanguageNotification
{
    var target = [[OLMyProjectController alloc] init];

    [self assert:target registered:OLProjectShouldDeleteBundleNotification];
}

- (void)testThatOLMyProjectControllerDoesRegisterForOLProjectShouldDownloadNotification
{
    var target = [[OLMyProjectController alloc] init];

    [self assert:target registered:"OLProjectShouldDownloadNotification"];
}

- (void)testThatOLMyProjectControllerDoesRegisterForCPMessageShouldBroadcastNotification
{
    var target = [[OLMyProjectController alloc] init];

    [self assert:target registered:OLProjectShouldBroadcastMessage];
}

- (void)testThatOLMyProjectControllerDoesRegisterForOLProjectShouldImportNotification
{
    var target = [[OLMyProjectController alloc] init];

    [self assert:target registered:"OLProjectShouldImportNotification"];
}

- (void)testThatOLMyProjectControllerDoesRespondToStartImport
{
    var importProjectController = moq();
    var target = [[OLMyProjectController alloc] init];
    
    target.importProjectController = importProjectController;
    
    [importProjectController selector:@selector(startImport:) times:1];

    [target startImport:moq()];
    
    [importProjectController verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLMyProjectControllerDoesSendNotificationWhenReceivingShouldBroadcastNotification
{
    var observer = [[Observer alloc] init];
    var selectedProject = moq();
    var target = [[OLMyProjectController alloc] init];

    target.selectedProject = selectedProject;
    
    [observer startObserving:OLMessageControllerShouldShowBroadcastViewNotification];

    [target createBroadcastMessage:moq()];
    
    [observer didObserve:OLMessageControllerShouldShowBroadcastViewNotification];
}

- (void)testThatOLMyProjectControllerDoesLoadProjects
{
    var user = moq();
    [user selector:@selector(userIdentifier) returns:@"12345"];
    [[OLUserSessionManager defaultSessionManager] setUser:user];

    var tempProject = OLProject;
    try
    {
        OLProject = moq();

        [OLProject selector:@selector(findByUserIdentifier:withCallback:) times:1];

        var target = [[OLMyProjectController alloc] init];

        [target loadProjects];

        [OLProject verifyThatAllExpectationsHaveBeenMet];
    } 
    finally 
    {
        OLProject = tempProject;
    }
}

- (void)assert:(id)target registered:(CPString)aNotification
{
    var names = [[CPNotificationCenter defaultCenter]._namedRegistries keyEnumerator];

    while (name = [names nextObject])
    {
        if([name isEqualToString:aNotification])
        {
            var registry = [[CPNotificationCenter defaultCenter]._namedRegistries objectForKey:name];
            var objects = [registry._objectObservers keyEnumerator];
            while(object = [objects nextObject])
            {
                var observers = [registry._objectObservers objectForKey:object];
                for(var i = 0; i < [observers count]; i++)
                {
                    if(target === [observers[i] observer])
                    {
                        return;
                    }
                }
            }
        }
    }

    [self fail:@"Target <"+[target description]+"> was not registered with <"+aNotification+">"];
}

@end