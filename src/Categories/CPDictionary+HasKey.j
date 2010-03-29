@implementation CPDictionary (HasKey)

- (BOOL)hasKey:(CPString)keyAsString
{
    return [[self allKeys] containsObject:keyAsString];
}
@end