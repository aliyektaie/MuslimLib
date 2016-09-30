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

@interface MuslimLib : NSObject

- (instancetype)init;

@property (strong, nonatomic) TrieFile* contentFile;

+ (MuslimLib*)instance;


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
- (NSArray*)getQuranVerseWordByWordTranslations:(QuranVerse*)verse;

@end

@interface VerseWordTranslation : NSObject

@property (strong, nonatomic) NSString* arabicImageLink;
@property (strong, nonatomic) NSString* translation;
@property (strong, nonatomic) NSString* transliteration;
@property (strong, nonatomic) NSString* arabicGrammar;
@property (strong, nonatomic) NSArray* syntaxAndMorphology;

@end
