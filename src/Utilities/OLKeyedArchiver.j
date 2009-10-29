@import <AppKit/CPObject.j>

/*!
 * A class that helps in the conversion from a model
 * to a JSON object.
 */
@implementation OLKeyedArchiver : CPCoder
{
	CPArray _data;
}

+ (BOOL)allowsKeyedCoding
{
	return YES;
}

+ (JSObject)archivedDataWithRootObject:(id)anObject
{
	var archiver = [[self alloc] init];
	
	[archiver encodeRootObject:anObject];
	[archiver finishEncoding];
	
	return [archiver data];
}

- (id)init
{
	if(self = [super init])
	{
		_data = {};
	}
	return self;
}

- (void)encodeRootObject:(id)rootObject
{
	[rootObject encode:self];
}

- (void)encode:(id)anObject forKey:(CPString)key
{
	_data[key] = [anObject encode:self];
}

- (void)encodeString:(CPString)aString forKey:(CPString)key
{
	_data[key] = aString;
}

- (void)encodeNumber:(CPNumber)aNumber forKey:(CPString)key
{
	_data[key] = aNumber;
}

- (void)encodeArray:(CPArray)anArray forKey:(CPString)key
{
	var encodedArray = new Array();
	
	for(var i = 0; i < [anArray count]; i++)
	{
		encodedArray[i] = [OLKeyedArchiver archivedDataWithRootObject:anArray[i]];
	}
	
	_data[key] = encodedArray;
}

- (CPString)data
{
	JSON.stringify(_data);
}

- (void)setData:(CPString)someData
{
	_data = eval('(' + someData + ')');
}

@end

@implementation OLKeyedUnarchiver : CPCoder
{
	JSObject _data;
}

+ (BOOL)allowsKeyedCoding
{
	return YES;
}

+ (void)unarchivedData:(CPString)someData
{
	var unarchiver = [[self alloc] initWithData:someData];
	
	return [archiver decode];
}

- (id)initWithData:(CPString)someData
{
	if(self = [super init])
	{
		_data = eval('(' + someData + ')');
	}
	return self;
}

- (id)decode
{
	var aClass = objj_getClass(_data[@"__class"]);
	return [[[aClass alloc] init] decode:_data];	
}

- (id)decodeObjectForKey:(CPString)key
{
	var aClass = objj_getClass(_data[key][@"__class"]);
	return [[[aClass alloc] init] decode:_data[key]];
}

- (CPString)decodeStringForKey:(CPString)key
{
	return _data[key];
}

- (CPNumber)decodeNumberForKey:(CPNumber)key
{
	return _data[key];
}

- (CPArray)decodeArrayForKey:(CPString)key
{
	var decodedArray = new Array();
	
	for(var i = 0; i < [_data[key] count]; i++)
	{
		var aClass = objj_getClass(_data[key][i]["__class"]);
		decodedArray[i] = [OLKeyedUnarchiver unarchivedData:_data[key][i] withRootObject:[[aClass alloc] init]];
	}
	
	return decodedArray;
}

@end
