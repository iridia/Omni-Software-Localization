@implementation CPArray (Find)

-(CPObject)findBy:(Function)isTheObject
{
	for(int i = 0; i < [self count]; i++)
	{
		if(isTheObject([self objectAtIndex:i]))
		{
			return [self objectAtIndex:i];
		}
	}
	
	return nil;
}

@end