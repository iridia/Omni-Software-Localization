@import <Foundation/CPObject.j>

@implementation OLResourceBundleController : CPObject
{
    CPString            ownerId                     @accessors;
    CPArray             resourceBundles             @accessors(readonly);
    CPResourceBundle    selectedResourceBundle      @accessors;
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
            [self setSelectedResourceBundle:[resourceBundles objectAtIndex:i]];
        }
    }
    
    if(!found)
    {
        [self setSelectedResourceBundle:[resourceBundles objectAtIndex:0]];
    }
}

- (void)selectedResourceBundleDidChange:(CPPopUpButton)aButton
{
    if([aButton indexOfSelectedItem] === 0)
    {
        [[CPNotificationCenter defaultCenter]
            postNotificationName:@"OLResourceBundleShouldBeCreated"
            object:self];
        
        return;
    }
    
    [self setSelectedResourceBundle:[resourceBundles objectAtIndex:[aButton indexOfSelectedItem]-1]];
}

- (CPNumber)indexOfSelectedResourceBundle
{
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        if(selectedResourceBundle === [resourceBundles objectAtIndex:i])
        {
            return i+1;
        }
    }
    
    return -1;
}

- (CPArray)titlesOfResourceBundles
{
    var result = [CPArray array];
    
    [result addObject:"Add Language..."];
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
            ownerId = [[object selectedProject] userIdentifier]
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