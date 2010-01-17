@import "OLActiveRecord.j"

@implementation OLLanguage : OLActiveRecord
{
	CPString _name @accessors(property=name, readonly);
}

+ (OLLanguage)languageFromLProj:(CPString)lproj
{
    var title = [lproj stringByReplacingOccurrencesOfString:@".lproj" withString:@""];
    return [self languageFromTitle:title];
}

+ (OLLanguage)languageFromTitle:(CPString)title
{
    if(![languageMapping objectForKey:title])
    {
        return [[OLLanguage alloc] initWithName:title];
    }

    return [languageMapping objectForKey:title];
}

+ (CPArray)allLanguages
{
    return [CPArray arrayWithArray:[languageMapping allValues]];
}

+ (OLLanguage)english {	return [[OLLanguage alloc] initWithName:@"English"]; }
+ (OLLanguage)french {	return [[OLLanguage alloc] initWithName:@"French"]; }
+ (OLLanguage)spanish {	return [[OLLanguage alloc] initWithName:@"Spanish"]; }
+ (OLLanguage)german {	return [[OLLanguage alloc] initWithName:@"German"]; }
+ (OLLanguage)arabic {	return [[OLLanguage alloc] initWithName:@"Arabic"]; }
+ (OLLanguage)japanese {	return [[OLLanguage alloc] initWithName:@"Japanese"]; }

- (id)initWithName:(CPString)aName
{
	if(self = [super init])
	{
		_name = aName;
	}
	return self;
}

- (BOOL)equals:(OLLanguage)otherLanguage
{
	return [_name isEqualToString:[otherLanguage name]];
}

- (OLLanguage)clone
{
    return [[OLLanguage alloc] initWithName:_name];
}

@end

var OLLanguageNameKey = @"OLLanguageNameKey";

@implementation OLLanguage (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aCoder decodeObjectForKey:OLLanguageNameKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_name forKey:OLLanguageNameKey];
}

@end

var languageMapping = [CPDictionary dictionary];
[languageMapping setObject:[OLLanguage english] forKey:@"English"];
[languageMapping setObject:[OLLanguage french] forKey:@"French"];
[languageMapping setObject:[OLLanguage spanish] forKey:@"Spanish"];
[languageMapping setObject:[OLLanguage german] forKey:@"German"];
[languageMapping setObject:[OLLanguage arabic] forKey:@"ar"];
[languageMapping setObject:[OLLanguage japanese] forKey:@"Japanese"];