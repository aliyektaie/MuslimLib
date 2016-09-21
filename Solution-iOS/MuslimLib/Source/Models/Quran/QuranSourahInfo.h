//
//  QuranSourahInfo.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/8/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QURAN_SOURAH_RECEPTION_PLACE_MAKI 1
#define QURAN_SOURAH_RECEPTION_PLACE_MADANI 2

@interface QuranSourahInfo : NSObject

@property (strong, nonatomic) NSString* titleArabic;
@property (strong, nonatomic) NSString* titleEnglish;
@property (strong, nonatomic) NSString* titleEnglishTranslation;
@property (strong, nonatomic) NSString* titleEnglishReference;
@property (strong, nonatomic) NSString* contentThemeEnglish;
@property (strong, nonatomic) NSString* titlePersianReference;
@property (strong, nonatomic) NSString* contentThemePersian;
@property (strong, nonatomic) NSString* moghataatEnglish;
@property (strong, nonatomic) NSString* moghataatArabic;

@property (assign, nonatomic) int wordCount;
@property (assign, nonatomic) int letterCount;
@property (assign, nonatomic) int sijdahCount;
@property (assign, nonatomic) int orderInBook;
@property (assign, nonatomic) int orderInAlphabetic;
@property (assign, nonatomic) int orderInReception;
@property (assign, nonatomic) int receptionPlace;
@property (assign, nonatomic) int verseCount;

+ (QuranSourahInfo*)loadFromJSON:(NSDictionary*)json;

- (NSString*)getClassification;
- (NSString*)getTitleTranslation;
- (NSString*)getTitleReference;
- (BOOL)hasContentConcepts;
- (NSString*)getContentConcepts;
- (BOOL)hasMoghataat;
- (BOOL)hasBesmAllah;

@end
