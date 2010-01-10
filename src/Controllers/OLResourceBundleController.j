@import <Foundation/CPObject.j>

@implementation OLResourceBundleController : CPObject
{
    CPArray             resourceBundles             @accessors(readonly);
    CPResourceBundle    selectedResourceBundle      @accessors(readonly);
    CPView              resourcesView               @accessors;
    CPString            projectName                 @accessors(readonly);
}

- (id)init
{
    if(self = [super init])
    {
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

- (void)selectedResourceBundleDidChange:(CPPopUpButton)aButton
{
    selectedResourceBundle = [resourceBundles objectAtIndex:[aButton indexOfSelectedItem]];
}

- (CPNumber)indexOfSelectedResourceBundle
{
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        if(selectedResourceBundle === [resourceBundles objectAtIndex:i])
        {
            return i;
        }
    }
    
    return -1;
}

- (CPArray)titlesOfResourceBundles
{
    var result = [CPArray array];
    
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        [result addObject:[[[resourceBundles objectAtIndex:i] language] name]];
    }
    
    return result;
}

@end

@implementation OLResourceBundleController (OLResourceBundleControllerKVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"selectedProject":
            projectName = [[object selectedProject] name];
            [self setResourceBundles:[[object selectedProject] resourceBundles]];
			[resourcesView reloadData:self];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end