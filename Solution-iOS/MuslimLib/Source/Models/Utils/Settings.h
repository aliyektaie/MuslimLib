//
//  Settings.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_LANGUAGE @"Persian"
#define DEFAULT_THEME @"Green"

@interface Settings : NSObject

+ (void)setLanguageFileName: (NSString*)value;
+ (NSString*)getLanguageFileName;
+ (void)setThemeFileName: (NSString*)value;
+ (NSString*)getThemeFileName;

+ (void)setLastViewedQuranPage: (int)value;
+ (int)getLastViewedQuranPage;

+ (void)setLastViewedQuranMode: (int)value;
+ (int)getLastViewedQuranMode;

+ (void)setDefaultArabicFont: (NSString*)value;
+ (NSString*)getDefaultArabicFont;

+ (void)setShouldRemoveSpecialCharsForQuran: (BOOL)value;
+ (BOOL)shouldRemoveSpecialCharsForQuran;

+ (void)setTranslationActive: (BOOL)value title:(NSString*)title;
+ (BOOL)isTranslationActive:(NSString*)title;

@end
