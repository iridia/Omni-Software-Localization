@import "../Controllers/OLMyProjectController.j"

@implementation OLMyProjectControllerTest : OJTestCase

- (void)setUp
{
    OSL_MAIN_VIEW_FRAME = CGRectMakeZero();
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
    OSL_MAIN_VIEW_FRAME = nil;
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
    
    [self assert:target registered:"CPLanguageShouldAddLanguageNotification"];
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