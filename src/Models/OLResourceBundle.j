@import <Foundation/CPObject.j>

@import "OLResource.j"
@import "OLLanguage.j"

/*!
 * The OLResourceBundle represents a bundle of resources of a specific language.
 */
@implementation OLResourceBundle : CPObject
{
	OLLanguage  language   @accessors;
	CPArray     resources  @accessors;
}

+ (id)resourceBundleFromJSON:(JSON)json
{
    var someResources = [CPArray array];
    
    for (var j = 0; j < json.resources.length; j++)
    {
        var resource = [OLResource resourceFromJSON:json.resources[j]];
        [someResources addObject:resource];
    }
    
    return [[OLResourceBundle alloc] initWithResources:someResources language:[OLLanguage languageFromLProj:json.name]]
}

- (id)init
{
    return [self initWithResources:[CPArray array] language:nil];
}

- (id)initWithLanguage:(OLLanguage)aLanguage
{
	return [self initWithResources:[CPArray array] language:aLanguage];
}

- (id)initWithResources:(CPArray)someResources language:(OLLanguage)aLanguage
{
	if(self = [super init])
	{
		language = aLanguage;
		resources = someResources;
	}
	return self;
}

- (CPString)nameOfLanguage
{
    return [language name];
}

- (CPString)shortFileNameOfObjectAtIndex:(int)index
{
    return [[resources objectAtIndex:index] shortFileName];
}

- (OLResourceBundle)clone
{
    var clone = [[OLResourceBundle alloc] initWithLanguage:[language clone]];
    
    for(var i = 0; i < [resources count]; i++)
    {
        [clone insertObject:[[resources objectAtIndex:i] clone] inResourcesAtIndex:i];
    }
    
    return clone;
}

- (CPArray)comments
{
    var result = [CPArray array];
    
    for(var i = 0; i < [resources count]; i++)
    {
        [result addObjectsFromArray:[[resources objectAtIndex:i] comments]];
    }
    
    return result;
}

@end

@implementation OLResourceBundle (KVC)

- (void)insertObject:(OLResource)resource inResourcesAtIndex:(CPInteger)index
{
    [resources insertObject:resource atIndex:index];
}

- (void)replaceObjectInResourcesAtIndex:(CPInteger)index withObject:(OLResource)resource
{
    [resources replaceObjectAtIndex:index withObject:resource];
}

@end


var OLResourceBundleLanguageKey = @"OLResourceBundleLanguageKey";
var OLResourceBundleResourcesKey = @"OLResourceBundleResourcesKey";

@implementation OLResourceBundle (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        language = [aCoder decodeObjectForKey:OLResourceBundleLanguageKey];
        resources = [aCoder decodeObjectForKey:OLResourceBundleResourcesKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:[self language] forKey:OLResourceBundleLanguageKey];
    [aCoder encodeObject:[self resources] forKey:OLResourceBundleResourcesKey];
}

@end
