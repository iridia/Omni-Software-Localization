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

- (void)testThatOLResourceBundleControllerDoesGetCommentsForSelectedLineItem
{
    [self assertGetFromResourceController:@selector(commentsForSelectedLineItem)];
}

- (void)testThatOLResourceBundleControllerDoesGetCommentForSelectedLineItem
{
    [self assertGetFromResourceController:@selector(commentForSelectedLineItem)];
}

- (void)testThatOLResourceBundleControllerDoesGetValueForSelectedLineItem
{
    [self assertGetFromResourceController:@selector(valueForSelectedLineItem)];
}

- (void)testThatOLResourceBundleControllerDoesGetSetValueForSelectedLineItem
{
    [self assertGetFromResourceController:@selector(setValueForSelectedLineItem:)];
}

- (void)testThatOLResourceBundleControllerDoesGetAddCommentForSelectedLineItem
{
    [self assertGetFromResourceController:@selector(addCommentForSelectedLineItem:)];
}

- (void)testThatOLResourceBundleControllerDoesMoveToNextLineItem
{
    [self assertGetFromResourceController:@selector(nextLineItem)];
}

- (void)testThatOLResourceBundleControllerDoesMoveToPreviousLineItem
{
    [self assertGetFromResourceController:@selector(previousLineItem)];
}

- (void)testThatOLResourceBundleControllerDoesSelectLineItemAtIndex
{
    [self assertGetFromResourceController:@selector(selectLineItemAtIndex:)];
}

- (void)testThatOLResourceBundleControllerDoesSelectResourceAtIndex
{
    [self assertGetFromResourceController:@selector(selectResourceAtIndex:)];
}

- (void)testThatOLResourceBundleControllerDoesGetTitleOfSelectedResource
{
    [self assertGetFromResourceController:@selector(titleOfSelectedResource)];
}

- (void)testThatOLResourceBundleControllerDoesVoteUp
{
    [self assertGetFromResourceController:@selector(voteUp)];
}

- (void)testThatOLResourceBundleControllerDoesVoteDown
{
    [self assertGetFromResourceController:@selector(voteDown)];
}

- (void)testThatOLResourceBundleControllerDoesGetNumberOfVotes
{
    [self assertGetFromResourceController:@selector(numberOfVotesForSelectedResource)];
}

- (void)testThatOLResourceBundleControllerDoesGetLineItemAtIndex
{
    [self assertGetFromResourceController:@selector(lineItemAtIndex:)];
}

- (void)testThatOLResourceBundleControllerDoesHaveCreateBundleWindowController
{
    var target = [[OLResourceBundleController alloc] init];
    [self assertSettersAndGettersFor:"createBundleWindowController" on:target];
}

- (void)testThatOLResourceBundleControllerDoesHaveCreateBundleWindowController
{
    var target = [[OLResourceBundleController alloc] init];
    [self assertSettersAndGettersFor:"deleteBundleWindowController" on:target];
}

- (void)testThatOLResourceBundleControllerDoesGetResourceNameAtIndex
{
    var firstResourceBundle = moq();
    var resource = [[OLResource alloc] init];
    [resource setFileName:@"Test"];
    [firstResourceBundle selector:@selector(resources) returns:[resource]];
    
    var target = [[OLResourceBundleController alloc] init];
    
    target.selectedResourceBundle = firstResourceBundle;
    
    [self assert:"Test" equals:[target resourceNameAtIndex:0]];
}

// CPAlert throws window.screen error
// - (void)testThatOLResourceBundleControllerDoesStartDeleteBundleSheet
// {
//     var target = [[OLResourceBundleController alloc] init];
//     
//     [target startDeleteBundle:nil];
//     
//     [self assertTrue:YES];
// }
// 
// - (void)testThatOLResourceBundleControllerDoesStartCreateBundleSheet
// {
//     var target = [[OLResourceBundleController alloc] init];
//     
//     [target startCreateNewBundle:nil];
//     
//     [self assertTrue:YES];
// }

- (void)testThatOLResourceBundleControllerDoesNotHaveAlreadyLocalizedLanguageWhenNoResourceBundles
{
    var target = [[OLResourceBundleController alloc] init];
    
    [self assert:NO equals:[target isLanguageAlreadyLocalized:[[OLLanguage alloc] initWithName:@"English"]]];
}

- (void)assertGetFromResourceController:(SEL)selector
{
    var resourceController = moq([[OLResourceController alloc] init]);

    var target = [[OLResourceBundleController alloc] init];

    target.resourceController = resourceController;

    [resourceController selector:selector times:1];

    [target performSelector:selector];

    [resourceController verifyThatAllExpectationsHaveBeenMet];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}

@end