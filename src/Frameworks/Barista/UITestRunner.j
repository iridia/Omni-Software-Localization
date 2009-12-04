@import <Foundation/CPObject.j>
@import "UITestScript.j"
@import "../../Tests/Barista/Scripts/ScriptList.js"
@import "Reporting/UIReportWindow.j"
@import "../../AppController.j"
@import <AppKit/CPApplication.j>

var CPMainCibFile = "CPMainCibFile",
    CPMainCibFileHumanFriendly = "Main cib file base name";

@implementation UITestRunner : CPObject
{
	CPArray scripts;
	CPNumber currentScript;
    CPArray startupWindows;
}

+ (void)go
{
	var runner = [self defaultRunner];
	[runner start];
}

+ (void)defaultRunner
{
	return [[self alloc] init];
}

- (id)init
{
	if(self = [super init])
	{
        scripts = [CPArray array];
        currentScript = 0;
        [[CPNotificationCenter defaultCenter] addObserver:self 
            selector:@selector(applicationDidFinishLaunching:)
            name:CPApplicationDidFinishLaunchingNotification
            object:CPApp];
	}
	return self;
}

- (void)start
{
    if(currentScript == [SCRIPT_LIST count])
    {
		if(currentScript == 0)
		{
			CPApplicationMain(nil, nil);
		}
		
        [self report];
        return;
    }
	
    document.body.innerHTML = "";
    CPApp = nil;
	_CPAppBootstrapperActions = nil;
    CPApplicationMain(nil,nil);
}

- (void)run
{
    var script = [[UITestScript alloc] initWithFilename:[SCRIPT_LIST objectAtIndex:currentScript]];
    [script load];
    [script run];
    [scripts addObject:script];

    currentScript = currentScript + 1;
    [self start];
}

- (void)report
{
	[[UIReportWindow alloc] initWithScripts:scripts];
}

- (void)applicationDidFinishLaunching:(id)sender
{
	if([SCRIPT_LIST count] == 0)
	{
		return;
	}
	
	[self run];
}

@end

/*
 * 
 * This is what global variables cause. See? SEE?
 * 
 */


var _CPAppBootstrapperActions = nil;

@implementation _CPAppBootstrapper : CPObject
 
+ (void)actions
{
    return [@selector(bootstrapPlatform), @selector(loadDefaultTheme), @selector(loadMainCibFile)];
}
 
+ (void)performActions
{
    if (!_CPAppBootstrapperActions)
        _CPAppBootstrapperActions = [self actions];
 
    while (_CPAppBootstrapperActions.length)
    {
        var action = _CPAppBootstrapperActions.shift();
 
        if (objj_msgSend(self, action))
            return;
    }
 
    [CPApp run];
}
 
+ (BOOL)bootstrapPlatform
{
    return [CPPlatform bootstrap];
}
 
+ (BOOL)loadDefaultTheme
{
    var blend = [[CPThemeBlend alloc] initWithContentsOfURL:[[CPBundle bundleForClass:[CPApplication class]] pathForResource:@"Aristo.blend"]];
 
    [blend loadWithDelegate:self];
 
    return YES;
}
 
+ (void)blendDidFinishLoading:(CPBundle)aBundle
{
    [CPTheme setDefaultTheme:[CPTheme themeNamed:@"Aristo"]];
 
    [self performActions];
}
 
+ (BOOL)loadMainCibFile
{
    var mainBundle = [CPBundle mainBundle],
        mainCibFile = [mainBundle objectForInfoDictionaryKey:CPMainCibFile] || [mainBundle objectForInfoDictionaryKey:CPMainCibFileHumanFriendly];
 
    if (mainCibFile)
    {
        [mainBundle loadCibFile:mainCibFile
            externalNameTable:[CPDictionary dictionaryWithObject:CPApp forKey:CPCibOwner]
                 loadDelegate:self];
 
        return YES;
    }
 
    return NO;
}
 
+ (void)cibDidFinishLoading:(CPCib)aCib
{
    [self performActions];
}
 
@end