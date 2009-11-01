@import "OLActiveRecord.j"

@implementation OLLanguage : OLActiveRecord
{
	CPString _name @accessors(property=name, readonly);
}

- (id)initWithOId:(CPString)anOId
{
    [self initWithOId:anOId name:nil];
}

- (id)initWithOId:(CPString)anOId name:(CPString)aName
{
	if(self = [super initWithOId:anOId])
	{
		_name = aName;
	}
	return self;
}

- (BOOL)equals:(OLLanguage)otherLanguage
{
	return [_name isEqualToString:[otherLanguage name]];
}

+ (OLLanguage)english {	return [[OLLanguage alloc] initWithName:@"English"]; }
+ (OLLanguage)french {	return [[OLLanguage alloc] initWithName:@"French"]; }
+ (OLLanguage)spanish {	return [[OLLanguage alloc] initWithName:@"Spanish"]; }
+ (OLLanguage)german {	return [[OLLanguage alloc] initWithName:@"German"]; }
+ (OLLanguage)arabic {	return [[OLLanguage alloc] initWithName:@"Arabic"]; }
+ (OLLanguage)japanese {	return [[OLLanguage alloc] initWithName:@"Japanese"]; }

@end

var OLLanguageNameKey = @"OLLanguageNameKey";

@implementation OLLanguage (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aCoder decodeObjectForKey:OLLanguageNameKey];
        console.log("Decoding Language. Got:", _name);
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    console.log("Encoding Language. For:", _name);
    [aCoder encodeObject:_name forKey:OLLanguageNameKey];
}

@end
