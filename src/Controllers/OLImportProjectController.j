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
        importProjectWindow = [[OLImportProjectWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 200) 
                styleMask:CPTitledWindowMask | CPClosableWindowMask];
        [importProjectWindow setDelegate:self];
    }
    return self;
}

- (void)startImport:(OLProject)aProject
{
    project = aProject;
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
                postNotificationName:@"OLMyProjectsShouldReloadNotification"
                object:self];
	    }];
	}
}

- (CPArray)titlesOfLanguages
{
    result = [CPArray array];
    
    for(var i = 0; i < [[project resourceBundles] count]; i++)
    {
        var resourceBundle = [[project resourceBundles] objectAtIndex:i];
        
        [result addObject:[[resourceBundle language] name]];
    }
    
    return result;
}

@end
