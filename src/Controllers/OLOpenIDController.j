@import <Foundation/CPObject.j>

var GOOGLE_URL = "https://www.google.com/accounts/o8/id";
var YAHOO_URL = "yahoo.com";

@implementation OLOpenIDController : CPObject
{
    id      delegate        @accessors;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        window.handleOpenIDResponse = function(email) {
            [OLUser findByEmail:email withCallback:function(user, isFinal)
            {            
                if (user && [[user email] isEqualToString:email])
                {
                    [delegate hasLoggedIn:user];
                    return;
                }
            
                if (isFinal)
                {
                    [delegate didSubmitRegistration:email];
                }
            }];
        }
    }
    return self;
}

- (void)loginToGoogle:(id)sender
{
    [self loginTo:GOOGLE_URL];
}

- (void)loginToYahoo:(id)sender
{
    [self loginTo:YAHOO_URL];
}

- (void)loginTo:(CPString)aURL
{
    window.open('OpenID/try_auth.php?openid_identifier='+encodeURIComponent(aURL), 'openid_popup', 'width=790,height=580');
}

@end
