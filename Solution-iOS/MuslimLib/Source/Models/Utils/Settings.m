//
//  Settings.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "Settings.h"

@implementation Settings

+ (void)setLanguageFileName: (NSString*)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"LANGUAGE_FILE_NAME"];

    [defaults synchronize];
}

+ (NSString*)getLanguageFileName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* result = (NSString*)[defaults objectForKey:@"LANGUAGE_FILE_NAME"];

    if (result == nil) {
        return DEFAULT_LANGUAGE;
    }

    return result;
}

+ (void)setThemeFileName: (NSString*)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"THEME_FILE_NAME"];

    [defaults synchronize];
}

+ (NSString*)getThemeFileName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* result = (NSString*)[defaults objectForKey:@"THEME_FILE_NAME"];

    if (result == nil) {
        result = DEFAULT_THEME;
    }

    return result;
}

+ (void)setLastViewedQuranPage: (int)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d", value] forKey:@"LAST_QURAN_PAGE_VIEW"];

    [defaults synchronize];
}

+ (int)getLastViewedQuranPage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* result = (NSString*)[defaults objectForKey:@"LAST_QURAN_PAGE_VIEW"];

    if (result == nil) {
        result = @"1";
    }

    return [result intValue];
}

+ (void)setLastViewedQuranMode: (int)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d", value] forKey:@"LAST_QURAN_PAGE_MODE"];

    [defaults synchronize];
}

+ (int)getLastViewedQuranMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* result = (NSString*)[defaults objectForKey:@"LAST_QURAN_PAGE_MODE"];

    if (result == nil) {
        result = @"0";
    }

    return [result intValue];
}

+ (void)setDefaultArabicFont: (NSString*)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:@"DEFAULT_ARABIC_FONT"];

    [defaults synchronize];
}

+ (NSString*)getDefaultArabicFont {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* result = (NSString*)[defaults objectForKey:@"DEFAULT_ARABIC_FONT"];

    if (result == nil) {
        return @"Scheherazade-Regular";
    }

    return result;
}

+ (void)setShouldRemoveSpecialCharsForQuran: (BOOL)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value ? @"true" : @"false" forKey:@"SHOULD_REMOVE_SPECIAL_CHARS"];
    
    [defaults synchronize];
}

+ (BOOL)shouldRemoveSpecialCharsForQuran {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* result = (NSString*)[defaults objectForKey:@"SHOULD_REMOVE_SPECIAL_CHARS"];
    
    if (result == nil) {
        result = @"true";
    }
    
    return [result isEqualToString:@"true"];
}

+ (void)setTranslationActive: (BOOL)value title:(NSString*)title {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value ? @"true" : @"false" forKey:[NSString stringWithFormat:@"QURAN_TRANLATION_ACTIVE_%@", title]];
    
    [defaults synchronize];
}

+ (BOOL)isTranslationActive:(NSString*)title {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* result = (NSString*)[defaults objectForKey:[NSString stringWithFormat:@"QURAN_TRANLATION_ACTIVE_%@", title]];
    
    if (result == nil) {
        result = @"false";
    }
    
    return [result isEqualToString:@"true"];
}



@end
