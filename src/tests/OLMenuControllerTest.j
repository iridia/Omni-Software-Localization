@import "../Controllers/OLMenuController.j"
@import "utilities/CPNotificationCenter+MockDefaultCenter.j"

@implementation OLMenuControllerTest : OJTestCase

- (void)setUp
{
    [CPNotificationCenter setIsMocked:NO];
    _DOMElement = moq();
    _DOMElement.appendChild = function(){return moq();};
}

- (void)tearDown
{
    [CPNotificationCenter setIsMocked:YES];
}

- (void)testThatOLMenuControllerDoesInitialize
{
    [self assertNotNull:[[OLMenuController alloc] init]];
}

- (void)testThatOLMenuControllerDoesSetupNotificationForEnablingItems
{
    var target = [[OLMenuController alloc] init];
    
    [self assert:target registered:@"OLMenuShouldEnableItemsNotification"];
}

- (void)testThatOLMenuControllerDoesSetupNotificationForDisablingItems
{
    var target = [[OLMenuController alloc] init];

    [self assert:target registered:@"OLMenuShouldDisableItemsNotification"];
}

- (void)testThatOLMenuControllerDoesPostNotificationWhenCreatingANewLanguage
{
    
}

- (void)testThatOLMenuControllerDoesPostNotificationWhenDeletingALanguage
{
    
}

- (void)testThatOLMenuControllerDoesStartUploadOnNew
{
    var uploadWindowController = moq();
    
    [uploadWindowController expectSelector:@selector(startUpload:) times:1];
    
    var target = [[OLMenuController alloc] init];
    [target setUploadWindowController:uploadWindowController];
    
    [target new:self];
    
    [uploadWindowController verifyThatAllExpectationsHaveBeenMet];
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