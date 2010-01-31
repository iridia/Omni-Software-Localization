@import "../Controllers/OLMyProjectController.j"

@implementation OLMyProjectControllerTest : OJTestCase

- (void)setUp
{
    OSL_MAIN_VIEW_FRAME = CGRectMakeZero();
    [CPNotificationCenter setIsMocked:NO];
    [CPNotificationCenter reset];
}

- (void)tearDown
{
    OSL_MAIN_VIEW_FRAME = nil;
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