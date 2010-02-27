/*
 * CPUserDefaults.j
 * AppKit
 *
 * Created by Nicholas Small.
 * Copyright 2009, 280 North, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import <Foundation/CPObject.j>


CPArgumentDomain = @"CPArgumentDomain";
CPApplicationDomain = @"CPApplicationDomain";
CPGlobalDomain = @"CPGlobalDomain";
CPLocaleDomain = @"CPLocaleDomain";
CPRegistrationDomain = @"CPRegistrationDomain";

CPUserDefaultsStoreCookie = @"CPUserDefaultsStoreCookie";
CPUserDefaultsStore280N = @"CPUserDefaultsStore280N";
CPUserDefaultsStoreCustom = @"CPUserDefaultsStoreCustom";

var StandardUserDefaults;

/*!
    @ingroup appkit
    @class CPUserDefaults
    
    CPUserDefaults provides a way of storing a list of user preferences. Everything you store must be CPCoding compliant because it is stored as CPData.
    
    Unlike in Cocoa, CPUserDefaults is per-host by default because it stores its data in a cookie. You need to be aware that if the host does not accept
    cookies or if they delete their cookies, your defaults will be erased.
    
    You can prevent this using the same method you use to store per-user defaults: write your defaults out to a persistent store. Hooks are provided for this.
*/
@implementation CPUserDefaults : CPObject
{
    CPUserDefaultsStore     store               @accessors;
    
    CPCookie                _globalCookie;
    CPCookie                _applicationCookie;
    CPDate                  _lastFlushTime;
    BOOL                    _needsFlush;
    CPTimer                 _flushTimer;
    
    CPDictionary            _domains;
    
    CPDictionary            _searchList;
    BOOL                    _searchListNeedsReload;
    
    id                      delegate            @accessors;
}

/*!
    Returns the shared defaults object.
*/
+ (id)standardUserDefaults
{
    if (!StandardUserDefaults)
        StandardUserDefaults = [[CPUserDefaults alloc] init];
    
    return StandardUserDefaults;
}

/*!
    Synchronizes any changes made to the shared user defaults object and releases it from memory.
    A subsequent invocation of standardUserDefaults creates a new shared user defaults object with the standard search list.
*/
+ (void)resetStandardUserDefaults
{
    if (StandardUserDefaults)
        [StandardUserDefaults synchronize];
    
    StandardUserDefaults = nil;
    
    if ([[self delegate] respondsToSelector:@selector(userDefaultsDidReset)])
    {
        [[self delegate] userDefaultsDidReset];
    }    
}

/*
    @ignore
*/
- (id)init
{
    self = [super init];
    
    if (self)
    {
        store = CPUserDefaultsStoreCookie;
        _domains = [CPDictionary dictionary];
        
        [self _setupArgumentsDomain];
        
        _globalCookie = [[CPCookie alloc] initWithName:CPGlobalDomain];
        _applicationCookie = [[CPCookie alloc] initWithName:[[[CPBundle mainBundle] infoDictionary] objectForKey:@"CPBundleIdentifier"] || CPApplicationDomain];
        
        // Restore Global Settings
        var value = [_globalCookie value];
        if (value)
        {
            var globalDomain = [CPKeyedUnarchiver unarchiveObjectWithData:[CPData dataWithString:decodeURIComponent(value)]];
            [_domains setObject:globalDomain forKey:CPGlobalDomain];
        }
        
        // Restore Application Settings
        var value = [_applicationCookie value];
        if (value)
        {
            var appDomain = [CPKeyedUnarchiver unarchiveObjectWithData:[CPData dataWithString:decodeURIComponent(value)]];
            [_domains setObject:appDomain forKey:CPApplicationDomain];
        }
        
        _searchListNeedsReload = YES;
        
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(userDidChange:)
            name:OLUserSessionManagerUserDidChangeNotification
            object:nil];
    }
    
    return self;
}

- (CPDictionary)persistentStoreForDomain:(CPString)aDomain
{
    
}

/*
    @ignore
*/
- (void)_setupArgumentsDomain
{
    var args = [CPApp namedArguments],
        keys = [args allKeys],
        count = [keys count];
    
    for (var i = 0; i < count; i++)
    {
        var key = keys[i];
        [self setObject:[args objectForKey:key] forKey:key inDomain:CPArgumentDomain];
    }
}

/*!
    Return a default value. The order of domains in the search list is: CPRegistrationDomain, CPGlobalDomain, CPApplicationDomain, CPArgumentDomain.
    Calling this method may cause the search list to be recreated if any new values have recently been set. Be aware of the performance ramifications.
*/
- (id)objectForKey:(CPString)aKey
{
    if (_searchListNeedsReload)
        [self _reloadSearchList];
    
    return [_searchList objectForKey:aKey];
}

/*!
    Set a default value in your application domain.
*/
- (void)setObject:(id)anObject forKey:(CPString)aKey
{
    [self setObject:anObject forKey:aKey inDomain:CPApplicationDomain];
}

/*!
    Return a default value from a specific domain. If you know
    which domain you'd like to use you should always use this method
    because it doesn't have to hit the search list.
*/
- (id)objectForKey:(CPString)aKey inDomain:(CPString)aDomain
{
    var domain = [_domains objectForKey:aDomain];
    
    if (!domain)
        return nil;
    
    return [domain objectForKey:aKey];
}

/*!
    Set a default value in the domain you pass in. If the domain is CPApplicationDomain or CPGlobalDomain,
    the defaults store will eventually be persisted. You can call -forceFlush to force a persist.
*/
- (void)setObject:(id)anObject forKey:(CPString)aKey inDomain:(CPString)aDomain
{
    if (!aKey || !aDomain)
        return;
    
    var domain = [_domains objectForKey:aDomain];
    
    if (!domain)
    {
        domain = [CPDictionary dictionary];
        [_domains setObject:domain forKey:aDomain];
    }
    
    [domain setObject:anObject forKey:aKey];
    
    if (aDomain === CPGlobalDomain || aDomain === CPApplicationDomain)
    {
        _needsFlush = YES;
        [self synchronizeIfNeeded];
    }
    
    _searchListNeedsReload = YES;
}

/*!
    Removes the value of the specified default key in the standard application domain.
    Removing a default has no effect on the value returned by the objectForKey: method if the same key exists in a domain that precedes the standard application domain in the search list.
*/
- (void)removeObjectForKey:(CPString)aKey
{
    [self removeObjectForKey:aKey inDomain:CPApplicationDomain];
}

/*!
    Removes the value of the specified default key in the specified domain.
*/
- (void)removeObjectForKey:(CPString)aKey inDomain:(CPString)aDomain
{
    if (!aKey || !aDomain)
        return;
    
    var domain = [_domains objectForKey:aDomain];
    
    if (!domain)
        return;
    
    [domain removeObjectForKey:aKey];
    
    if (aDomain === CPGlobalDomain || aDomain === CPApplicationDomain)
    {
        _needsFlush = YES;
        [self synchronizeIfNeeded];
    }
    
    _searchListNeedsReload = YES;
}

/*!
    Adds the contents the specified dictionary to the registration domain.
    
    If there is no registration domain, one is created using the specified dictionary, and CPRegistrationDomain is added to the end of the search list.
    The contents of the registration domain are not written to disk; you need to call this method each time your application starts. You can place a plist file in the application's Resources directory and call registerDefaultsWithContentsOfFile:
    
    @param aDictionary The dictionary of keys and values you want to register.
*/    
- (void)registerDefaults:(CPDictionary)aDictionary
{
    var keys = [aDictionary allKeys],
        count = [keys count];
    
    for (var i = 0; i < count; i++)
    {
        var key = keys[i];
        [self setObject:[aDictionary objectForKey:key] forKey:key inDomain:CPRegistrationDomain];
    }
}

/*!
    This is just a convenience method to load a plist resource and register all the values it contains as defaults.
    
    NOTE: This sends a synchronous request. If you don't want to do that, create a dictionary any way you want (including loading a plist)
    and pass it to -registerDefaults:
*/
- (void)registerDefaultsFromContentsOfFile:(CPURL)aURL
{
    var contents = [CPURLConnection sendSynchronousRequest:[CPURLRequest requestWithURL:aURL] returningResponse:nil error:nil],
        data = [CPData dataWithString:[contents string]],
        plist = [data plistObject];
    
    [self registerDefaults:plist];
}

/*
    @ignore
*/
- (void)_reloadSearchList
{
    _searchListNeedsReload = NO;
    
    var dicts = [CPRegistrationDomain, CPGlobalDomain, CPApplicationDomain, CPArgumentDomain],
        count = [dicts count];
    
    _searchList = [CPDictionary dictionary];
    
    for (var i = 0; i < count; i++)
    {
        var domain = [_domains objectForKey:dicts[i]];
        
        if (!domain)
            continue;
        
        var keys = [domain allKeys],
            keysCount = [keys count];
        
        for (var j = 0; j < keysCount; j++)
        {
            var key = keys[j];
            [_searchList setObject:[domain objectForKey:key] forKey:key];
        }
    }
}

// Synchronization
/*!
    Write out the defaults database only if needed. Default: 2000ms interval.
*/
- (void)synchronizeIfNeeded
{
    if (_flushTimer)
        window.clearTimeout(_flushTimer);
    
    if (!_needsFlush)
        return;
    
    if ([[self delegate] respondsToSelector:@selector(userDefaultsShouldSynchronizeData)])
    {
        [[self delegate] userDefaultsShouldSynchronizeData];
    }
    
    _flushTimer = window.setTimeout(function(){[self synchronize];}, 2000);
}

/*!
    Force write out of defaults database immediately.
*/
- (void)synchronize
{
    if (!_needsFlush)
        return;
    
    var globalDomain = [_domains objectForKey:CPGlobalDomain];
    if (globalDomain)
    {
        var expires = [CPDate dateWithTimeIntervalSinceNow:(30*24*60*60)]; // 30 days is the default
        if ([[self delegate] respondsToSelector:@selector(userDefaultsExpirationDateForDomain:)])
        {
            expires = [[self delegate] userDefaultsExpirationDateForDomain:CPGlobalDomain]
        }
        
        var data = [CPKeyedArchiver archivedDataWithRootObject:globalDomain];
        [_globalCookie setValue:encodeURIComponent([data string]) expires:expires domain:@"http://cappuccino.org"];
        
        // notifiy our delegate that we synchronized
        if ([[self delegate] respondsToSelector:@selector(userDefaultsDidSynchronizeDataForDomain:)])
        {
            [[self delegate] userDefaultsDidSynchronizeDataForDomain:CPGlobalDomain]
        }
    }
    
    var appDomain = [_domains objectForKey:CPApplicationDomain];
    if (appDomain)
    {
        var expires = [CPDate dateWithTimeIntervalSinceNow:(30*24*60*60)]; // 30 days is the default
        if ([[self delegate] respondsToSelector:@selector(userDefaultsExpirationDateForDomain:)])
        {
            expires = [[self delegate] userDefaultsExpirationDateForDomain:CPApplicationDomain]
        }
        
        var data = [CPKeyedArchiver archivedDataWithRootObject:appDomain];
        [_applicationCookie setValue:encodeURIComponent([data string]) expires:expires domain:nil];
        
        // notifiy our delegate that we synchronized
        if ([[self delegate] respondsToSelector:@selector(userDefaultsDidSynchronizeDataForDomain:)])
        {
            [[self delegate] userDefaultsDidSynchronizeDataForDomain:CPApplicationDomain]
        }
    }
    
    _needsFlush = NO;
}

// Value accessors

/*!
    Returns the Boolean value associated with the specified key.
*/
- (BOOL)boolForKey:(CPString)aKey
{
    var value = [self objectForKey:aKey];
    if ([value respondsToSelector:@selector(boolValue)])
        return [value boolValue]
    
    return value;
}

/*!
    Returns the floating-point value associated with the specified key.
*/
- (float)floatForKey:(CPString)aKey
{
    var value = [self objectForKey:aKey];
    if ([value respondsToSelector:@selector(floatValue)])
        return [value floatValue];
    
    return value;
}

/*!
    Returns the double value associated with the specified key.
*/
- (double)doubleForKey:(CPString)aKey
{
    var value = [self objectForKey:aKey];
    if ([value respondsToSelector:@selector(doubleValue)])
        return [value doubleValue];
    
    return value;
}

/*!
    Returns the integer value associated with the specified key.
*/
- (int)integerForKey:(CPString)aKey
{
    var value = [self objectForKey:aKey];
    if ([value respondsToSelector:@selector(intValue)])
        return [value intValue];
    
    return value;
}

- (void)userDidChange:(CPNotification)notification
{
    var user = [[OLUserSessionManager defaultSessionManager] userIdentifier];

    [[CPUserDefaults standardUserDefaults] setObject:user forKey:OLUserDefaultsLoggedInUserIdentifierKey];
}

@end
