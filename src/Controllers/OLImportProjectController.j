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
    }
    return self;
}

- (void)startImport:(OLProject)aProject
{
    project = aProject;
    [[CPApplication sharedApplication] runModalForWindow:importProjectWindow];
}

@end
