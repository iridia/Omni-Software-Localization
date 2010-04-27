@import "../Controllers/OLImportProjectController.j"
@import "../Models/OLLanguage.j"
@import "utilities/OJTestCase+ArrayAsserts.j"

_DOMElement = moq();
_DOMElement.appendChild = function(){return moq();};


@implementation OLImportProjectControllerTest : OJTestCase

- (void)testThatOLImportProjectControllerDoesInitialize
{
    var target = [[OLImportProjectController alloc] init];
    
    [self assertNotNull:target];
}

- (void)testThatOLImportProjectControllerDoesHandleServerResponse
{
    var target = [[OLImportProjectController alloc] init];
    
    [target handleServerResponse:"{\"fileType\":\"test\"}"];
}

- (void)testThatOLImportProjectControllerDoesReturnTitlesOfLanguages
{
    var target = [[OLImportProjectController alloc] init];
    
    [self assert:0 equals:[[target titlesOfLanguages] count]];
}

- (void)testThatOLImportProjectControllerDoesReturnTitlesOfFiles
{
    var target = [[OLImportProjectController alloc] init];
    
    [self assert:0 equals:[[target titlesOfFiles] count]];
}

// runModalForWindow: throws error
// - (void)testThatOLImportProjectControllerDoesStartImport
// {
//     var tempCPPlatformWindow = CPPlatformWindow;
//     try
//     {
//         var target = [[OLImportProjectController alloc] init];
//     
//         var project = moq();
//     
//         [target startImport:project];
//     
//         [self assert:project equals:[target project]];
//     }
//     finally
//     {
//         CPPlatformWindow = tempCPPlatformWindow;
//     }
// }
// 
// - (void)testThatOLImportProjectControllerDoesReturnTitlesOfLanguages
// {   
//     var target = [[OLImportProjectController alloc] init];
//     
//     var project = moq();
//     var resourceBundle1 = moq();
//     var resourceBundle2 = moq();
//     var language1 = [[OLLanguage alloc] initWithName:@"English"];
//     var language2 = [[OLLanguage alloc] initWithName:@"French"];
//     
//     [project selector:@selector(resourceBundles) returns:[resourceBundle1, resourceBundle2]];
//     [resourceBundle1 selector:@selector(language) returns:language1];
//     [resourceBundle2 selector:@selector(language) returns:language2];
//     
//     [target startImport:project];
//     
//     [self assert:[target titlesOfLanguages] contains:@"English"];
//     [self assert:[target titlesOfLanguages] contains:@"French"];
// }

@end