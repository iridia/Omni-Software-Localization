@import <Foundation/CPObject.j>
@import "../Views/OLImportProjectWindow.j"

@implementation OLImportProjectController : CPObject
{
    OLProject               project                 @accessors(readonly);
    
    OLImportProjectWindow   importProjectWindow;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        importProjectWindow = [[OLImportProjectWindow alloc] initWithContentRect:CGRectMake(0, 0, 200, 180) 
                styleMask:CPTitledWindowMask | CPClosableWindowMask];
        [importProjectWindow setDelegate:self];
    }
    return self;
}

- (void)startImport:(OLProject)aProject
{
    project = aProject;
    [importProjectWindow showMain:self];
    [[CPApplication sharedApplication] runModalForWindow:importProjectWindow];
}

- (void)handleServerResponse:(CPString)aResponse
{
	aResponse = aResponse.replace("<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">", "");
	aResponse = aResponse.replace("\n</pre>", "");
	
    var jsonResponse = eval('(' + aResponse + ')');
    
	if (jsonResponse.fileType === @"zip")
	{
	    var newProject = [OLProject projectFromJSON:jsonResponse];
	    [newProject setRecordID:[project recordID]];
	    [newProject setRevision:[project revision]];
	    [newProject saveWithCallback:function(){
            [[CPNotificationCenter defaultCenter]
                postNotificationName:OLProjectShouldReloadMyProjectsNotification
                object:self];
	    }];
	}
	else if(jsonResponse.fileType === @"strings")
	{
	    var newResource = [OLResource resourceFromJSON:jsonResponse];
        var resourceBundle = [[project resourceBundles] objectAtIndex:[importProjectWindow indexOfSelectedLanguage]];
        var oldResourceIndex = [importProjectWindow indexOfSelectedFile];
	    [resourceBundle replaceObjectInResourcesAtIndex:oldResourceIndex withObject:newResource];
	    [project save];
	}
}

- (CPArray)titlesOfLanguages
{
    var result = [CPArray array];
    
    for(var i = 0; i < [[project resourceBundles] count]; i++)
    {
        var resourceBundle = [[project resourceBundles] objectAtIndex:i];
        
        [result addObject:[resourceBundle nameOfLanguage]];
    }
    
    return result;
}

- (CPArray)titlesOfFiles
{
    var result = [CPArray array];
    var resourceBundle = [[project resourceBundles] objectAtIndex:[importProjectWindow indexOfSelectedLanguage]];
    
    for(var i = 0; i < [[resourceBundle resources] count]; i++)
    {
        [result addObject:[resourceBundle shortFileNameOfObjectAtIndex:i]];
    }
    
    return result;
}

@end
