@import <Foundation/CPObject.j>
@import "UITestScriptParser.j"

@implementation UITestScript : CPObject
{
	CPString filename @accessors;
	id delegate @accessors;
	CPArray actions;
	CPArray errors @accessors;
	CPArray successes @accessors;
}

- (id)init
{
	[CPException raise:@"UITestScript" reason:@"Filename is required!"];
}

- (id)initWithFilename:(CPString)aFilename
{
	if(self = [super init])
	{
		filename = aFilename;
		errors = [CPArray array];
		successes = [CPArray array];
	}
	return self;
}

- (void)load
{
	var req = [CPURLRequest requestWithURL:"Tests/Barista/Scripts/" + filename];
	var data = [CPURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
	actions = [UITestScriptParser parse:[data string] withDelegate:self];
}

- (void)run
{
	for(var i = 0; i < [actions count]; i++)
	{
		try
		{
			actions[i](self);
		}
		catch(ex)
		{
			[self addError:@"Couldn't run action "+i];
		}
	}
}

- (void)addError:(CPString)error
{
	[errors addObject:error];
}

- (void)addSuccess:(CPString)success
{
	[successes addObject:success];
}

@end
