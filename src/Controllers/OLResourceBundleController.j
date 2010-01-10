@import <Foundation/CPObject.j>

@implementation OLResourceBundleController : CPObject
{
    CPArray             resourceBundles             @accessors(readonly);
    CPResourceBundle    selectedResourceBundle      @accessors(readonly);
}

- (id)init
{
    if(self = [super init])
    {
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(didReceiveOLResourceBundleDidChangeNotification:)
            name:@"OLResourceBundleDidChangeNotification"
            object:nil];
    }
    return self;
}

- (void)setResourceBundles:(CPArray)someResourceBundles
{
    resourceBundles = someResourceBundles;
    [self resetCurrentBundle];
}

- (void)resetCurrentBundle
{
    var found = false;
    
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        if([[OLLanguage english] equals:[[resourceBundles objectAtIndex:i] language]])
        {
            found = true;
            selectedResourceBundle = [resourceBundles objectAtIndex:i];
        }
    }
    
    if(!found)
    {
        selectedResourceBundle = [resourceBundles objectAtIndex:0];
    }
}

- (void)didReceiveOLResourceBundleDidChangeNotification:(CPNotification)aNotification
{
    var view = [aNotification object];
    
    selectedResourceBundle = [resourceBundles objectAtIndex:[view selectedResourceBundleIndex]];
}

@end
