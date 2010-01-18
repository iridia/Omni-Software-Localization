@import <Foundation/CPObject.j>
@import "../Views/OLCreateNewBundleWindow.j"

@implementation OLResourceBundleController : CPObject
{
    CPString            projectName                 @accessors(readonly);
    CPString            ownerId                     @accessors;
    CPArray             resourceBundles             @accessors(readonly);
    CPResourceBundle    selectedResourceBundle      @accessors;
    CPView              resourcesView               @accessors;
    CPView              createNewBundleWindow         @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        createNewBundleWindow = [[OLCreateNewBundleWindow alloc] initWithContentRect:CGRectMake(0, 0, 200, 100) styleMask:CPTitledWindowMask];
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
        [self startCreateNewBundle:self];
        
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
    
    [result addObject:@"Add Language..."];
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        [result addObject:[[[resourceBundles objectAtIndex:i] language] name]];
    }
    
    return result;
}

- (void)startCreateNewBundle:(id)sender
{
    [[CPApplication sharedApplication] runModalForWindow:createNewBundleWindow];
    [createNewBundleWindow setUp:self];
}

- (CPArray)titlesOfAvailableLanguage
{
    var result = [CPArray array];
    
    for(var i = 0; i < [[self availableLanguages] count]; i++)
    {
        [result addObject:[[[self availableLanguages] objectAtIndex:i] name]];
    }
    
    return result;
}

- (CPArray)availableLanguages
{
    var result = [CPArray array];
    
    for(var i = 0; i < [[OLLanguage allLanguages] count]; i++)
    {
        var theLanguage = [[OLLanguage allLanguages] objectAtIndex:i];
        
        if(![self isLanguageAlreadyLocalized:theLanguage])
        {
            [result addObject:[[OLLanguage allLanguages] objectAtIndex:i]];
        }
    }
    
    return result;
}

- (BOOL)isLanguageAlreadyLocalized:(OLLanguage)aLanguage
{
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        if([[[resourceBundles objectAtIndex:i] language] equals:aLanguage])
        {
            return true;
        }
    }
    
    return false;
}

- (void)cancel:(id)sender
{
    [createNewBundleWindow close];
    
    [[CPApplication sharedApplication] stopModal];
}

- (void)create:(id)sender
{
    var clone = [[self defaultBundle] clone];
    
    [clone setLanguage:[[self availableLanguages] objectAtIndex:[[createNewBundleWindow popUpButton] indexOfSelectedItem]]];
    
    replaceEnglishWithNewResourceBundleName(clone, [[clone language] name]);
    [resourceBundles addObject:clone];
    [resourcesView reloadData:self];
    
    [[CPNotificationCenter defaultCenter]
        postNotificationName:@"OLProjectDidChangeNotification"
        object:clone];
        
    [self cancel:self];
}

- (void)defaultBundle
{
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        if([[[resourceBundles objectAtIndex:i] language] equals:[OLLanguage english]])
        {
            return [resourceBundles objectAtIndex:i];
        }
    }
    
    return nil;
}

@end

function replaceEnglishWithNewResourceBundleName(bundle, name)
{
    for(var i = 0; i < [[bundle resources] count]; i++)
    {
        var theResource = [[bundle resources] objectAtIndex:i];
        
        [theResource setFileName:[[theResource fileName] stringByReplacingOccurrencesOfString:@"English" withString:name]];
    }
}

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