@import "../Controllers/OLResourceBundleController.j"

[CPNotificationCenter setIsMocked:false];

@implementation OLResourceBundleControllerTest : OJTestCase

- (void)testThatOLResourceBundleControllerDoesInitialize
{
    [self assertNotNull:[[OLResourceBundleController alloc] init]];
}

- (void)testThatOLResourceBundleControllerDoesSetListOfResourceBundles
{
    var mockResourceBundle = moq();
    [mockResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];
    
    var resourceBundles = [mockResourceBundle, mockResourceBundle, mockResourceBundle];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [self assert:resourceBundles equals:[target resourceBundles]];
}

- (void)testThatOLResourceBundleControllerDoesSetInitialResourceBundleToEnglishBundle
{
    var mockResourceBundle = moq();
    [mockResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];

    var englishBundle = moq();
    var resourceBundles = [mockResourceBundle, englishBundle, mockResourceBundle];
    
    [englishBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"English"]];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [self assert:englishBundle equals:[target selectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesSetToIndex0WhenNoEnglish
{
    var mockResourceBundle = moq();
    var firstResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];
    [mockResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];
    
    var resourceBundles = [firstResourceBundle, mockResourceBundle, mockResourceBundle];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [self assert:firstResourceBundle equals:[target selectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesSetToSelectedIndexWhenNotifiedOfChange
{
    var firstResourceBundle = moq();
    var secondResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];
    [secondResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];
    
    var resourceBundles = [firstResourceBundle, secondResourceBundle];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [self assert:firstResourceBundle equals:[target selectedResourceBundle]];
    
    [target selectResourceBundleAtIndex:2];
    
    [self assert:secondResourceBundle equals:[target selectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesReturnIndexOfSelectedResourceBundle
{
    var mockResourceBundle = moq();
    var firstResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];
    [mockResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];

    var resourceBundles = [firstResourceBundle, mockResourceBundle, mockResourceBundle];

    var target = [[OLResourceBundleController alloc] init];

    [target setResourceBundles:resourceBundles];

    [self assert:1 equals:[target indexOfSelectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesReturnIndexOfSelectedResourceBundleAfterAChange
{
    var firstResourceBundle = moq();
    var secondResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];
    [secondResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];

    var resourceBundles = [firstResourceBundle, secondResourceBundle];

    var target = [[OLResourceBundleController alloc] init];

    [target setResourceBundles:resourceBundles];

    [self assert:firstResourceBundle equals:[target selectedResourceBundle]];

    [target selectResourceBundleAtIndex:1];

    [self assert:1 equals:[target indexOfSelectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesReturnTitlesOfResourceBundles
{
    var mockResourceBundle = moq();
    var firstResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"German"]];
    [mockResourceBundle selector:@selector(language) returns:[[OLLanguage alloc] initWithName:@"Spanish"]];

    var resourceBundles = [firstResourceBundle, mockResourceBundle, mockResourceBundle];

    var target = [[OLResourceBundleController alloc] init];

    [target setResourceBundles:resourceBundles];

    [self assert:@"German" equals:[[target titlesOfResourceBundles] objectAtIndex:1]];
    [self assert:@"Spanish" equals:[[target titlesOfResourceBundles] objectAtIndex:2]];
    [self assert:@"Spanish" equals:[[target titlesOfResourceBundles] objectAtIndex:3]];
}

@end