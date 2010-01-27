@import "OLActiveRecord.j"

@implementation OLLanguage : OLActiveRecord
{
	CPString _name @accessors(property=name, readonly);
}

+ (OLLanguage)languageFromLProj:(CPString)lproj
{
    var title = [lproj stringByReplacingOccurrencesOfString:@".lproj" withString:@""];
    return [self languageFromTitle:title];
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
	if(self = [super init])
	{
		_name = aName;
	}
	return self;
}

- (BOOL)equals:(OLLanguage)otherLanguage
{
	return [_name isEqualToString:[otherLanguage name]];
}

- (OLLanguage)clone
{
    return [[OLLanguage alloc] initWithName:_name];
}

@end

var OLLanguageNameKey = @"OLLanguageNameKey";

@implementation OLLanguage (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aCoder decodeObjectForKey:OLLanguageNameKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_name forKey:OLLanguageNameKey];
}

@end

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
