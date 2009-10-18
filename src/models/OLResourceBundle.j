 @implementation OLResourceBundle : CPObject
 {
 	OLLanguage _language @accessors(property=language, readonly);
 	OLResourceBundle _baseBundle @accessors(property=baseBundle);
 	CPArray _resources @accessors(property=resources, readonly);
 }
 
 - (id)initWithResources:(CPArray)someResources ofLanguage:(OLLanguage)aLanguage
 {
 	if(self = [super init])
 	{
 		_language = aLanguage;
 		_resources = someResources;
 	}
 	return self;
 }
 
 - (id)initWithLanguage:(OLLanguage)aLanguage
 {
 	if(self = [super init])
 	{
 		_language = aLanguage;
 		_resources = [[CPArray alloc] init];
 	}
 }
 
 - (void)addResource:(OLResource)aResource
 {
 	[_resources addObject:aResource];
 }
 
 @end
 