@import <Foundation/CPObject.j>
@import "../Utilities/OLUserSessionManager.j"
@import "../Views/OLCreateBundleWindowController.j"
@import "../Views/OLDeleteBundleWindowController.j"

@import "OLResourceController.j"
@import "OLProjectController.j"

@implementation OLResourceBundleController : CPObject
{
    CPString                        projectName                     @accessors(readonly);
    CPArray                         resourceBundles                 @accessors(readonly);
    CPResourceBundle                selectedResourceBundle          @accessors;
    OLCreateBundleWindowController  createBundleWindowController    @accessors;
    OLDeleteBundleWindowController  deleteBundleWindowController    @accessors;
    
    OLResourceController            resourceController              @accessors(readonly);
}

- (id)init
{
    if(self = [super init])
    {
        createBundleWindowController = [[OLCreateBundleWindowController alloc] init];
        [createBundleWindowController setDelegate:self];
        
        deleteBundleWindowController = [[OLDeleteBundleWindowController alloc] init];
        [deleteBundleWindowController setDelegate:self];
        
        resourceController = [[OLResourceController alloc] init];
        [self addObserver:resourceController forKeyPath:@"selectedResourceBundle" options:CPKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)voteUp
{
    [resourceController voteUp];
}

- (void)voteDown
{
    [resourceController voteDown];
}

- (int)numberOfVotesForSelectedResource
{
    return [resourceController numberOfVotesForSelectedResource];
}

- (int)numberOfResources
{
    return [[selectedResourceBundle resources] count];
}

- (int)numberOfLineItems
{
    return [resourceController numberOfLineItems];
}

- (OLLineItem)lineItemAtIndex:(int)index
{
    return [resourceController lineItemAtIndex:index];
}

- (CPString)resourceNameAtIndex:(int)index
{
    return [[[selectedResourceBundle resources] objectAtIndex:index] fileName];
}

- (void)selectResourceBundleAtIndex:(int)index
{
    if(index === 0)
    {
        [self startCreateNewBundle:self];
        
        return;
    }
    
    [self setSelectedResourceBundle:[resourceBundles objectAtIndex:(index - 1)]];
}

- (void)selectResourceAtIndex:(int)index
{
    [resourceController selectResourceAtIndex:index];
}

- (void)selectLineItemAtIndex:(int)index
{
    [resourceController selectLineItemAtIndex:index];
}

- (void)setResourceBundles:(CPArray)someResourceBundles
{
    resourceBundles = someResourceBundles;
    [self resetCurrentBundle];
}

- (void)resetCurrentBundle
{    
    if(![self defaultBundle])
    {
        [self setSelectedResourceBundle:[resourceBundles objectAtIndex:0]];
    }
    else
    {
        [self setSelectedResourceBundle:[self defaultBundle]];
    }
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
    if([[self availableLanguages] count] > 0)
    {
        [createBundleWindowController reloadData];
        [createBundleWindowController showWindowAsSheet:self];
    }
    else
    {
        var alert = [[CPAlert alloc] init];
        [alert setTitle:@"No languages available!"];
        [alert setMessageText:@"You cannot add a language to this project because all possible languages are already added!"];
        [alert setAlertStyle:CPWarningAlertStyle];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    }
}

- (void)startDeleteBundle:(id)sender
{
    if([resourceBundles count] > 1)
    {
        [deleteBundleWindowController reloadData];
        [deleteBundleWindowController showWindowAsSheet:self];
    }
    else
    {
        var alert = [[CPAlert alloc] init];
        [alert setTitle:@"No languages available!"];
        [alert setMessageText:@"You cannot delete a language from this project because there are no languages to delete!"];
        [alert setAlertStyle:CPWarningAlertStyle];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    }
}

- (CPArray)titlesOfAvailableLanguage
{
    var result = [CPArray array];
    
    for(var i = 0; i < [[self availableLanguages] count]; i++)
    {
        [result addObject:[[[self availableLanguages] objectAtIndex:i] name]];
    }
    
    return [result sortedArrayUsingFunction:
        function(earlyLanguages,laterLanguages,context)
        {
            return [earlyLanguages compare: laterLanguages];
        };
    ];
}

- (CPArray)titlesOfLocalizedLanguages
{
    var result = [CPArray array];
    
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        [result addObject:[[[resourceBundles objectAtIndex:i] language] name]];
    }
    
    return result;
}

- (CPArray)availableLanguages
{
    var result = [CPArray array];
    var allLanguages = [OLLanguage allLanguages];
    for(var i = 0; i < [allLanguages count]; i++)
    {
        var theLanguage = [allLanguages objectAtIndex:i];
        
        if(![self isLanguageAlreadyLocalized:theLanguage] && ![theLanguage equals:[[OLLanguage alloc] initWithName:@"English"]])
        {
            [result addObject:[allLanguages objectAtIndex:i]];
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

- (void)defaultBundle
{
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        if([[[resourceBundles objectAtIndex:i] language] equals:[[OLLanguage alloc] initWithName:@"English (United States)"]] ||
           [[[resourceBundles objectAtIndex:i] language] equals:[[OLLanguage alloc] initWithName:@"English"]])
        {
            return [resourceBundles objectAtIndex:i];
        }
    }
    
    return nil;
}

@end

@implementation OLResourceBundleController (BundleCreationAndDeletionDelegate)

- (CPArray)availableLanguagesForSelectedProject
{
    return [self titlesOfAvailableLanguage];
}

- (CPArray)languagesForSelectedProject
{
    return [self titlesOfLocalizedLanguages];
}

- (void)shouldCreateBundleForLanguage:(CPString)aLanguage
{
    var clone = [[self defaultBundle] clone];
    [clone setLanguage:[OLLanguage languageFromTitle:aLanguage]];
    
    replaceEnglishWithNewResourceBundleName(clone, [[clone language] shortName]);
    [resourceBundles addObject:clone];
    
    [self setSelectedResourceBundle:clone];
    
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLProjectDidChangeNotification
        object:nil];
}

- (void)shouldDeleteBundleForLanguage:(int)indexOfBundleToDelete
{
    var bundleToDelete = [resourceBundles objectAtIndex:indexOfBundleToDelete];
    [resourceBundles removeObjectAtIndex:indexOfBundleToDelete];
    
    if(selectedResourceBundle === bundleToDelete)
    {
        [self resetCurrentBundle];
    }
    
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLProjectDidChangeNotification
        object:nil];
}

- (void)didEndSheet:(CPWindow)sheet returnCode:(int)returnCode contextInfo:(id)contextInfo
{
    [sheet orderOut:self];
}

- (void)nextLineItem
{
    [resourceController nextLineItem];
}

- (void)previousLineItem
{
    [resourceController previousLineItem];
}

- (void)addCommentForSelectedLineItem:(CPString)value
{
    [resourceController addCommentForSelectedLineItem:value];
}

- (void)setValueForSelectedLineItem:(CPString)value
{
    [resourceController setValueForSelectedLineItem:value];
}

- (CPString)titleOfSelectedResource
{
    return [resourceController titleOfSelectedResource];
}

- (CPString)commentForSelectedLineItem
{
    return [resourceController commentForSelectedLineItem];
}

- (CPArray)commentsForSelectedLineItem
{
    return [resourceController commentsForSelectedLineItem];
}

- (CPString)valueForSelectedLineItem
{
    return [resourceController valueForSelectedLineItem];
}

- (CPString)englishValueForSelectedLineItem
{
    var identifier = [resourceController identifierForSelectedLineItem];
    
    var englishBundle = [self defaultBundle];
    
    for(var i = 0; i < [[englishBundle resources] count]; i++)
    {
        var resource = [[englishBundle resources] objectAtIndex:i];
        for(var j = 0; j < [[resource lineItems] count]; j++)
        {
            var lineItem = [[resource lineItems] objectAtIndex:j];
            if([[lineItem identifier] isEqualToString:identifier])
            {
                return [lineItem value];
            }
        }
    }
    
    return "ERROR";
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
            projectName = [[object selectedProject] name];
            [self setResourceBundles:[[object selectedProject] resourceBundles]];
            [self resetCurrentBundle];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end