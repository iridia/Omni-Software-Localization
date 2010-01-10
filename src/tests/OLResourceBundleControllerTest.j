@import "../Controllers/OLResourceBundleController.j"

[CPNotificationCenter setIsMocked:false];

@implementation OLResourceBundleControllerTest : OJTestCase

- (void)testThatOLResourceBundleControllerDoesInitialize
{
    [self assertNotNull:[[OLResourceBundleController alloc] init]];
}

- (void)testThatOLResourceBundleControllerDoesRegisterNotificationOnInitialize
{
    var target = [[OLResourceBundleController alloc] init];
    [self assert:target registered:@"OLResourceBundleDidChangeNotification"];
}

- (void)testThatOLResourceBundleControllerDoesSetListOfResourceBundles
{
    var mockResourceBundle = moq();
    [mockResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];
    
    var resourceBundles = [mockResourceBundle, mockResourceBundle, mockResourceBundle];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [self assert:resourceBundles equals:[target resourceBundles]];
}

- (void)testThatOLResourceBundleControllerDoesSetInitialResourceBundleToEnglishBundle
{
    var mockResourceBundle = moq();
    [mockResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];

    var englishBundle = moq();
    var resourceBundles = [mockResourceBundle, englishBundle, mockResourceBundle];
    
    [englishBundle selector:@selector(language) returns:[OLLanguage english]];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [self assert:englishBundle equals:[target selectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesSetCurrentResourceBundleAccordingToNotification
{
    var mockResourceBundle = moq();
    [mockResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];

    var englishBundle = moq();
    var resourceBundles = [mockResourceBundle, englishBundle, mockResourceBundle];

    [englishBundle selector:@selector(language) returns:[OLLanguage english]];
 
    var value = moq();   
    [value selector:@selector(selectedResourceBundleIndex) returns:2];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [[CPNotificationCenter defaultCenter]
        postNotificationName:@"OLResourceBundleDidChangeNotification"
        object:value];
    
    [self assert:[[target resourceBundles] objectAtIndex:2] equals:[target selectedResourceBundle]];
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