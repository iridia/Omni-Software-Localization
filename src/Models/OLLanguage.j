@import <Foundation/CPObject.j>

@implementation OLLanguage : CPObject
{
	CPString    name            @accessors(readonly);
	CPString    languageCode    @accessors(readonly);
}

+ (OLLanguage)languageFromLProj:(CPString)lproj
{
    return [self languageFromTitle:[lproj stringByReplacingOccurrencesOfString:@".lproj" withString:@""]];
}

+ (OLLanguage)languageFromTitle:(CPString)title
{
    if(![languageMapping objectForKey:title])
    {
        return [[OLLanguage alloc] initWithName:title];
    }

    return [languageMapping objectForKey:title];
}

+ (CPArray)allLanguages
{
    return [CPArray arrayWithArray:[languageMapping allValues]];
}

- (id)initWithName:(CPString)aName
{
    return [self initWithName:aName languageCode:[SHORT_NAME objectForKey:aName]];
}

- (id)initWithName:(CPString)aName languageCode:(CPString)aLanguageCode
{
    if (self = [super init])
    {
        name = aName;
        languageCode = aLanguageCode;
    }
    return self;
}

- (BOOL)equals:(OLLanguage)otherLanguage
{
	return [name isEqualToString:[otherLanguage name]];
}

- (CPString)shortName
{
    CPLog.warn(@"[OLLanguage shortName] has been changed to [OLLanguage languageCode]. Please change this call.");
    
    return [self languageCode];
}

- (OLLanguage)clone
{
    return [[OLLanguage alloc] initWithName:[self name]];
}

@end


var OLLanguageNameKey = @"OLLanguageNameKey";
var OLLanguageLanguageCodeKey = @"OLLanguageLanguageCodeKey";

@implementation OLLanguage (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super init])
    {
        name = [aCoder decodeObjectForKey:OLLanguageNameKey];
        languageCode = [aCoder decodeObjectForKey:OLLanguageLanguageCodeKey];
    }
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:[self name] forKey:OLLanguageNameKey];
    [aCoder encodeObject:[self languageCode] forKey:OLLanguageLanguageCodeKey];
}

@end

var SHORT_NAME = [CPDictionary dictionary];
[SHORT_NAME setObject:@"af_ZA" forKey:@"Afrikaans (South Africa)"];
[SHORT_NAME setObject:@"am_ET" forKey:@"Amharic"];
[SHORT_NAME setObject:@"be_BY" forKey:@"Belarusian"];
[SHORT_NAME setObject:@"bg_BG" forKey:@"Bulgarian"];
[SHORT_NAME setObject:@"ca_ES" forKey:@"Catalan (Spain)"];
[SHORT_NAME setObject:@"cs_CZ" forKey:@"Czech"];
[SHORT_NAME setObject:@"da" forKey:@"Danish"];
[SHORT_NAME setObject:@"da_DK" forKey:@"Danish (Denmark)"];
[SHORT_NAME setObject:@"de_AT" forKey:@"German (Austria)"];
[SHORT_NAME setObject:@"de_CH" forKey:@"German (Swiss)"];
[SHORT_NAME setObject:@"de_DE" forKey:"German (Germany)"];
[SHORT_NAME setObject:@"de" forKey:@"German"];
[SHORT_NAME setObject:@"el_GR" forKey:@"Greek"];
[SHORT_NAME setObject:@"en_AU" forKey:@"English (Australia)"];
[SHORT_NAME setObject:@"en_CA" forKey:@"English (Canada)"];
[SHORT_NAME setObject:@"en_GB" forKey:@"English (Great Britain)"];
[SHORT_NAME setObject:@"en_IE" forKey:@"English (Ireland)"];
[SHORT_NAME setObject:@"en_NZ" forKey:@"English (New Zealand)"];
[SHORT_NAME setObject:@"en_US" forKey:@"English (United States)"];
[SHORT_NAME setObject:@"en" forKey:@"English"];
[SHORT_NAME setObject:@"es_ES" forKey:@"Spanish (Spain)"];
[SHORT_NAME setObject:@"et_EE" forKey:@"Estonian"];
[SHORT_NAME setObject:@"eu_ES" forKey:@"Basque (Spain)"];
[SHORT_NAME setObject:@"fi" forKey:@"Finnish"];
[SHORT_NAME setObject:@"fi_FI" forKey:@"Finnish (Finland)"];
[SHORT_NAME setObject:@"fr_BE" forKey:@"French (Belgian)"];
[SHORT_NAME setObject:@"fr_CA" forKey:@"French (Canada)"];
[SHORT_NAME setObject:@"fr_CH" forKey:@"French (Switzerland)"];
[SHORT_NAME setObject:@"fr_FR" forKey:@"French (France)"];
[SHORT_NAME setObject:@"fr" forKey:@"French"];
[SHORT_NAME setObject:@"he_IL" forKey:@"Hebrew"];
[SHORT_NAME setObject:@"hi_IN" forKey:@"Hindi"];
[SHORT_NAME setObject:@"hr_HR" forKey:@"Croatian"];
[SHORT_NAME setObject:@"hu_HU" forKey:@"Hungarian"];
[SHORT_NAME setObject:@"hy_AM" forKey:@"Armenian"];
[SHORT_NAME setObject:@"is_IS" forKey:@"Icelandic"];
[SHORT_NAME setObject:@"it_CH" forKey:@"Italian (Switzerland)"];
[SHORT_NAME setObject:@"it_IT" forKey:@"Italian (Italy)"];
[SHORT_NAME setObject:@"ja_JP" forKey:@"Japanese"];
[SHORT_NAME setObject:@"kk_KZ" forKey:@"Kazakh"];
[SHORT_NAME setObject:@"ko" forKey:@"Korean"];
[SHORT_NAME setObject:@"ko_KR" forKey:@"Korean (Korea)"];
[SHORT_NAME setObject:@"lt_LT" forKey:@"Lithuanian"];
[SHORT_NAME setObject:@"nl_BE" forKey:@"Dutch (Belgium)"];
[SHORT_NAME setObject:@"nl_NL" forKey:@"Dutch (Netherlands)"];
[SHORT_NAME setObject:@"nl" forKey:@"Dutch"];
[SHORT_NAME setObject:@"no" forKey:@"Norwegian"];
[SHORT_NAME setObject:@"no_NO" forKey:@"Norwegian (Norway)"];
[SHORT_NAME setObject:@"pl" forKey:@"Polish"];
[SHORT_NAME setObject:@"pl_PL" forKey:@"Polish (Poland)"];
[SHORT_NAME setObject:@"pt_BR" forKey:@"Portuguese (Brazil)"];
[SHORT_NAME setObject:@"pt_PT" forKey:@"Portuguese (Portugal)"];
[SHORT_NAME setObject:@"pt" forKey:@"Portuguese"];
[SHORT_NAME setObject:@"ro_RO" forKey:@"Romanian"];
[SHORT_NAME setObject:@"ru" forKey:@"Russian"];
[SHORT_NAME setObject:@"ru_RU" forKey:@"Russian (Russia)"];
[SHORT_NAME setObject:@"sk_SK" forKey:@"Slovak"];
[SHORT_NAME setObject:@"sl_SI" forKey:@"Slovenian"];
[SHORT_NAME setObject:@"sr_YU" forKey:@"Serbian"];
[SHORT_NAME setObject:@"sv" forKey:@"Swedish"];
[SHORT_NAME setObject:@"sv_SE" forKey:@"Swedish (Sweden)"];
[SHORT_NAME setObject:@"tr_TR" forKey:@"Turkish"];
[SHORT_NAME setObject:@"uk_UR" forKey:@"Ukranian"];
[SHORT_NAME setObject:@"zh_CN" forKey:@"Chinese (Simplified)"];
[SHORT_NAME setObject:@"zh_HK" forKey:@"Chinese (Hong Kong)"];
[SHORT_NAME setObject:@"zh_TW" forKey:@"Chinese (Traditional)"];
[SHORT_NAME setObject:@"zh" forKey:@"Chinese (China)"];

var languageMapping = [CPDictionary dictionary];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Afrikaans (South Africa)"] forKey:@"af_ZA"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Amharic"] forKey:@"am_ET"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Belarusian"] forKey:@"be_BY"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Bulgarian"] forKey:@"bg_BG"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Catalan (Spain)"] forKey:@"ca_ES"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Czech"] forKey:@"cs_CZ"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Danish"] forKey:@"da"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Danish"] forKey:@"da_DK"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"German (Austria)"] forKey:@"de_AT"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"German (Swiss)"] forKey:@"de_CH"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"German (Germany)"] forKey:"de_DE"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"German"] forKey:@"de"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Greek"] forKey:@"el_GR"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"English (Australia)"] forKey:@"en_AU"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"English (Canada)"] forKey:@"en_CA"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"English (Great Britain)"] forKey:@"en_GB"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"English (Ireland)"] forKey:@"en_IE"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"English (New Zealand)"] forKey:@"en_NZ"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"English (United States)"] forKey:@"en_US"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"English"] forKey:@"en"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Spanish (Spain)"] forKey:@"es_ES"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Estonian"] forKey:@"et_EE"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Basque (Spain)"] forKey:@"eu_ES"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Finnish"] forKey:@"fi"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Finnish"] forKey:@"fi_FI"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"French (Belgian)"] forKey:@"fr_BE"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"French (Canada)"] forKey:@"fr_CA"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"French (Switzerland)"] forKey:@"fr_CH"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"French (France)"] forKey:@"fr_FR"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"French"] forKey:@"fr"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Hebrew"] forKey:@"he_IL"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Hindi"] forKey:@"hi_IN"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Croatian"] forKey:@"hr_HR"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Hungarian"] forKey:@"hu_HU"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Armenian"] forKey:@"hy_AM"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Icelandic"] forKey:@"is_IS"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Italian (Switzerland)"] forKey:@"it_CH"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Italian (Italy)"] forKey:@"it_IT"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Japanese"] forKey:@"ja_JP"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Kazakh"] forKey:@"kk_KZ"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Korean"] forKey:@"ko"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Korean"] forKey:@"ko_KR"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Lithuanian"] forKey:@"lt_LT"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Dutch (Belgium)"] forKey:@"nl_BE"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Dutch (Netherlands)"] forKey:@"nl_NL"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Dutch"] forKey:@"nl"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Norwegian"] forKey:@"no"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Norwegian"] forKey:@"no_NO"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Polish"] forKey:@"pl"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Polish"] forKey:@"pl_PL"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Portuguese (Brazil)"] forKey:@"pt_BR"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Portuguese (Portugal)"] forKey:@"pt_PT"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Portuguese"] forKey:@"pt"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Romanian"] forKey:@"ro_RO"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Russian"] forKey:@"ru"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Russian"] forKey:@"ru_RU"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Slovak"] forKey:@"sk_SK"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Slovenian"] forKey:@"sl_SI"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Serbian"] forKey:@"sr_YU"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Swedish"] forKey:@"sv"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Swedish"] forKey:@"sv_SE"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Turkish"] forKey:@"tr_TR"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Ukranian"] forKey:@"uk_UR"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Chinese (Simplified)"] forKey:@"zh_CN"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Chinese (Hong Kong)"] forKey:@"zh_HK"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Chinese (Traditional)"] forKey:@"zh_TW"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Chinese (China)"] forKey:@"zh"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"English (United States)"] forKey:@"English"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"French (France)"] forKey:@"French"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Spanish (Spain)"] forKey:@"Spanish"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"German (Germany)"] forKey:@"German"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Japanese"] forKey:@"Japanese"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Italian (Italy)"] forKey:@"Italian"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Chinese (China)"] forKey:@"Chinese"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Portuguese (Portugal)"] forKey:@"Portuguese"];
[languageMapping setObject:[[OLLanguage alloc] initWithName:@"Swedish (Sweden)"] forKey:@"Swedish"];
