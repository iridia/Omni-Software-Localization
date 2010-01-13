@import <Foundation/CPObject.j>

var __createURLConnectionFunction = nil;

@implementation OLURLConnectionFactory : CPObject

+ (CPURLConnection)createConnectionWithRequest:(CPURLRequest)request delegate:(id)delegate
{
    if(__createURLConnectionFunction == nil)
    {
        return [CPURLConnection connectionWithRequest:request delegate:delegate];
    }

    return __createURLConnectionFunction(request, delegate);
}

+ (CPURLConnection)setConnectionFactoryMethod:(Function)builderMethodWithTwoArguments
{
    __createURLConnectionFunction = builderMethodWithTwoArguments;
}

@end
