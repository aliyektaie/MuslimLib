//
//  MuslimLib.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/8/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrieFile.h"
#import "QuranSourahInfo.h"
#import "QuranVerse.h"
#import "CacheUtils.h"
#import "QuranTranslationInfo.h"

#define QURAN_SOURAH_LIST_PATH @"/Content/Quran/SourahList"
#define QURAN_SOURAH_PAGE_INDEX_PATH @"/Content/Quran/PageIndex"

#define CONTENT_QURAN @"content-quran"
#define CONTENT_QURAN_TRANSLATION @"content-quran-translation"
#define CONTENT_QURAN_MORPHOLOGY @"content-quran-morphology"

#define GET_WORD_BY_WORD_TRANSLATION_CALLBACK void (^)(NSArray* translations)


@interface MuslimLib : NSObject

- (instancetype)init;

@property (strong, nonatomic) NSMutableDictionary* contentFiles;


+ (MuslimLib*)instance;

- (TrieFile*)getContentFile:(NSString*)fileTitle;

- (NSArray*)getSourahList;
- (QuranSourahInfo*)getSourahInfo:(int)sourahNumber;
- (NSString*)getSourahArticle:(QuranSourahInfo*)info;
- (NSArray*)getQuranVersesForPage:(int)page;
- (QuranVerse*)getQuranVerse:(int)verse inSourah:(int)sourah;
- (int)getQuranJuzFromPage:(int)page;
- (NSArray*)getQuranPageSourahs:(int)page;
- (NSString*)getQuranPageFirstSourahName:(int)page;
- (int)getQuranSourahPage:(int)sourah;
- (NSString*)removeQuranSpecialCharsForce:(NSString*)aya;
- (NSArray*)getQuranAvailableTranslations;
- (void)getQuranVerseWordByWordTranslations:(QuranVerse*)verse callback:(GET_WORD_BY_WORD_TRANSLATION_CALLBACK)callback controller:(UIViewController*)controller;

@end

@interface VerseWordTranslation : NSObject

@property (strong, nonatomic) NSString* arabicImageLink;
@property (strong, nonatomic) NSString* translation;
@property (strong, nonatomic) NSString* transliteration;
@property (strong, nonatomic) NSString* arabicGrammar;
@property (strong, nonatomic) NSArray* syntaxAndMorphology;

@end
