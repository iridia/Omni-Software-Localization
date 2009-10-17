@implementation OLLanguage : CPObject
{
	CPString _name @accessors(property=name, readonly);
}

- (id)initWithName:(CPString)aName
{
	if(self = [super init])
	{
		_name = aName;
	}
	return self;
}

+ (OLLanguage)english {	return [[OLLanguage alloc] initWithName:@"English"]; }
+ (OLLanguage)french {	return [[OLLanguage alloc] initWithName:@"French"]; }
+ (OLLanguage)spanish {	return [[OLLanguage alloc] initWithName:@"Spanish"]; }
+ (OLLanguage)german {	return [[OLLanguage alloc] initWithName:@"German"]; }
+ (OLLanguage)arabic {	return [[OLLanguage alloc] initWithName:@"Arabic"]; }
+ (OLLanguage)japanese {	return [[OLLanguage alloc] initWithName:@"Japanese"]; }

@end
