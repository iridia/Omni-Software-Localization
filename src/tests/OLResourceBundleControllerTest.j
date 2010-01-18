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

- (void)testThatOLResourceBundleControllerDoesSetToIndex0WhenNoEnglish
{
    var mockResourceBundle = moq();
    var firstResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];
    [mockResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];
    
    var resourceBundles = [firstResourceBundle, mockResourceBundle, mockResourceBundle];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [self assert:firstResourceBundle equals:[target selectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesSetToSelectedIndexWhenNotifiedOfChange
{
    var firstResourceBundle = moq();
    var secondResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];
    [secondResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];
    
    var aPopUpButton = moq();
    
    [aPopUpButton selector:@selector(indexOfSelectedItem) returns:2];
    
    var resourceBundles = [firstResourceBundle, secondResourceBundle];
    
    var target = [[OLResourceBundleController alloc] init];
    
    [target setResourceBundles:resourceBundles];
    
    [self assert:firstResourceBundle equals:[target selectedResourceBundle]];
    
    [target selectedResourceBundleDidChange:aPopUpButton];
    
    [self assert:secondResourceBundle equals:[target selectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesReturnIndexOfSelectedResourceBundle
{
    var mockResourceBundle = moq();
    var firstResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];
    [mockResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];

    var resourceBundles = [firstResourceBundle, mockResourceBundle, mockResourceBundle];

    var target = [[OLResourceBundleController alloc] init];

    [target setResourceBundles:resourceBundles];

    [self assert:1 equals:[target indexOfSelectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesReturnIndexOfSelectedResourceBundleAfterAChange
{
    var firstResourceBundle = moq();
    var secondResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];
    [secondResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];

    var aPopUpButton = moq();

    [aPopUpButton selector:@selector(indexOfSelectedItem) returns:1];

    var resourceBundles = [firstResourceBundle, secondResourceBundle];

    var target = [[OLResourceBundleController alloc] init];

    [target setResourceBundles:resourceBundles];

    [self assert:firstResourceBundle equals:[target selectedResourceBundle]];

    [target selectedResourceBundleDidChange:aPopUpButton];

    [self assert:1 equals:[target indexOfSelectedResourceBundle]];
}

- (void)testThatOLResourceBundleControllerDoesReturnTitlesOfResourceBundles
{
    var mockResourceBundle = moq();
    var firstResourceBundle = moq();
    [firstResourceBundle selector:@selector(language) returns:[OLLanguage german]];
    [mockResourceBundle selector:@selector(language) returns:[OLLanguage spanish]];

    var resourceBundles = [firstResourceBundle, mockResourceBundle, mockResourceBundle];

    var target = [[OLResourceBundleController alloc] init];

    [target setResourceBundles:resourceBundles];

    [self assert:@"German" equals:[[target titlesOfResourceBundles] objectAtIndex:1]];
    [self assert:@"Spanish" equals:[[target titlesOfResourceBundles] objectAtIndex:2]];
    [self assert:@"Spanish" equals:[[target titlesOfResourceBundles] objectAtIndex:3]];
}

@end