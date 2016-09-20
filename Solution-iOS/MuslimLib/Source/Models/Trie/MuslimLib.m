//
//  MuslimLib.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/8/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "MuslimLib.h"
#import "ContentFileValueFactory.h"
#import "LanguageStrings.h"
#import "QuranVerseInPageIndex.h"
#import "Settings.h"

@interface MuslimLib () {
    NSMutableArray* _quranVersePageIndex;
    NSMutableArray* _quranSourahs;

    NSMutableArray* _quranPagesCache;
}

@end

@implementation MuslimLib

static MuslimLib* _instance;

#pragma mark - General Methods
+ (MuslimLib*)instance {
    if (_instance == nil) {
        _instance = [[MuslimLib alloc] init];
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"db"];
        id<IValueFactory> factory = [[ContentFileValueFactory alloc] init];
        _contentFile = [[TrieFile alloc] initWithPath:path withFactory:factory];

        _quranPagesCache = [[NSMutableArray alloc] init];
    }

    return self;
}

- (id)loadJSON:(NSString*)json {
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                 options:0
                 error:&error];

    return object;
}

#pragma mark - Sourah List Methods

- (NSArray*)getSourahList {
    if (_quranSourahs != nil) {
        return _quranSourahs;
    }

    ContentFile* file = (ContentFile*)[self.contentFile getValue:QURAN_SOURAH_LIST_PATH];
    NSArray* json = [self loadJSON:file.content];
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:114];

    for (int i = 0; i < json.count; i++) {
        NSDictionary* entry = [json objectAtIndex:i];
        [result addObject:[QuranSourahInfo loadFromJSON:entry]];
    }

    _quranSourahs = result;

    return result;
}

- (QuranSourahInfo*)getSourahInfo:(int)sourahNumber {
    [self getSourahList];

    return [_quranSourahs objectAtIndex:sourahNumber - 1];
}

- (NSString*)getSourahArticle:(QuranSourahInfo*)info {
    NSMutableString* html = [[NSMutableString alloc] init];

    [html appendString:@"<html><header>"];
    [html appendString:@"<style>"];

    [html appendFormat:@"body { font-family: %@ ; direction: %@}", [[LanguageStrings instance] get:@"DefaultFont"], [[LanguageStrings instance] isRightToLeft] ? @"rtl" : @"ltr"];
    [html appendString:@"</style>"];
    [html appendString:@"</header><body>"];

    NSString* path = [NSString stringWithFormat:@"/Content/Quran/Sourah/Summary/%@/%d", [LanguageStrings instance].name, info.orderInBook];
    ContentFile* file = (ContentFile*)[self.contentFile getValue:path];
    NSDictionary* json = [self loadJSON:file.content];
    NSArray* sections = [json objectForKey:@"sections"];

    for (int i = 0; i < sections.count; i++) {
        NSDictionary* section = [sections objectAtIndex:i];

        NSString* header = [section objectForKey:@"header"];
        [html appendFormat:@"<h1>%@</h1>", header];

        NSArray* paragraphs = [section objectForKey:@"paragraphs"];
        for (int j = 0; j < paragraphs.count; j++) {
            [html appendString:[paragraphs objectAtIndex:j]];
        }

        NSString* content = [section objectForKey:@"content"];
        if (content != nil) {
            [html appendString:content];
        }
    }


    [html appendString:@"</body></html>"];

    return html;
}

#pragma mark - Quran Pages Methods

- (NSArray*)loadQuranVersesInPageIndex {
    NSMutableArray* result = _quranVersePageIndex;

    if (result == nil) {
        result = [[NSMutableArray alloc] init];
        NSString* indexContent = ((ContentFile*)[self.contentFile getValue:QURAN_SOURAH_PAGE_INDEX_PATH]).content;
        NSArray* lines = [indexContent componentsSeparatedByString:@"\r\n"];

        for (int i = 0; i < lines.count; i++) {
            NSString* index = [[lines objectAtIndex:i] stringByReplacingOccurrencesOfString:@"-" withString:@":"];
            NSArray* parts = [index componentsSeparatedByString:@":"];

            QuranVerseInPageIndex* entry = [[QuranVerseInPageIndex alloc] init];

            entry.beginPageChapter = [[parts objectAtIndex:0] intValue];
            entry.beginPageVerse = [[parts objectAtIndex:1] intValue];
            entry.endPageChapter = [[parts objectAtIndex:2] intValue];
            entry.endPageVerse = [[parts objectAtIndex:3] intValue];

            [result addObject:entry];
        }


        _quranVersePageIndex = result;
    }

    return result;
}

- (NSArray*)getQuranVersesForPage:(int)page {
    [self getSourahList];

    NSMutableArray* result = [[NSMutableArray alloc] init];

    if ([self hasQuranPageInCache:page]) {
        result = (NSMutableArray*)[self getCachedQuranPage:page];
        [self setQuranPageCache:page content:result];

        return result;
    } else {
        ContentFile* file = (ContentFile*)[self.contentFile getValue:[NSString stringWithFormat:@"/QP%d", page]];
        NSArray* json = [self loadJSON:file.content];

        for (int i = 0; i < json.count; i++) {
            NSDictionary* verseInfo = [json objectAtIndex:i];

            QuranVerse* verseObject = [[QuranVerse alloc] init];
            verseObject.text = [self removeQuranSpecialChars:[verseInfo objectForKey:@"verseText"]];
            int value = [[verseInfo objectForKey:@"chapterNumber"] intValue];
            verseObject.sourahInfo = [_quranSourahs objectAtIndex:value - 1];
            value = [[verseInfo objectForKey:@"verseNumber"] intValue];
            verseObject.verseNumber = value;

            [result addObject:verseObject];
        }

        [self setQuranPageCache:page content:result];
    }

    return result;
}

- (BOOL)hasQuranPageInCache:(int)page {
    return [CacheUtils hasCacheEntry:_quranPagesCache withTitle:[NSString stringWithFormat:@"p%d", page]];
}

- (NSArray*)getCachedQuranPage:(int)page {
    return (NSArray*)[CacheUtils getCachedContent:_quranPagesCache withTitle:[NSString stringWithFormat:@"p%d", page]];
}

- (void)setQuranPageCache:(int)page content:(NSArray*)content {
    [CacheUtils setContentCache:[NSString stringWithFormat:@"p%d", page] content:content inCache:_quranPagesCache];
}

- (QuranVerse*)getQuranVerse:(int)verse inSourah:(int)sourah {
    NSString* text = ((ContentFile*)[self.contentFile getValue:[NSString stringWithFormat:@"/Q%d:%d", sourah, verse]]).content;

    QuranVerse* verseObject = [[QuranVerse alloc] init];
    verseObject.text = [self removeQuranSpecialChars:text];
    verseObject.sourahInfo = [_quranSourahs objectAtIndex:sourah - 1];
    verseObject.verseNumber = verse;

    return verseObject;
}

- (NSString*)getQuranPageFirstSourahName:(int)page {
    [self loadQuranVersesInPageIndex];
    [self getSourahList];

    QuranVerseInPageIndex* index = [_quranVersePageIndex objectAtIndex:page - 1];
    QuranSourahInfo* sourah = [_quranSourahs objectAtIndex:index.beginPageChapter - 1];

    return sourah.titleArabic;
    
}

- (int)getQuranSourahPage:(int)sourah {
    [self loadQuranVersesInPageIndex];
    int result = 0;

    for (int i = 0; i < _quranVersePageIndex.count; i++) {
        QuranVerseInPageIndex* index = [_quranVersePageIndex objectAtIndex:i];
        if (index.beginPageChapter <= sourah && index.endPageChapter >= sourah) {
            result = i + 1;
            break;
        }
    }

    return result;
}

- (NSArray*)getQuranPageSourahs:(int)page {
    [self loadQuranVersesInPageIndex];
    [self getSourahList];

    QuranVerseInPageIndex* index = [_quranVersePageIndex objectAtIndex:page - 1];
    NSMutableArray* result = [[NSMutableArray alloc] init];

    for (int i = index.beginPageChapter; i <= index.endPageChapter; i++) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        QuranSourahInfo* sourah = [_quranSourahs objectAtIndex:i - 1];

        [dic setObject:[self getSourahTitle:sourah] forKey:@"title"];
        if (i == index.beginPageChapter) {
            [dic setObject:[NSString stringWithFormat:@"%d", index.beginPageVerse] forKey:@"from"];
        } else {
            [dic setObject:@"1" forKey:@"from"];
        }

        if (i == index.endPageChapter) {
            [dic setObject:[NSString stringWithFormat:@"%d", index.endPageVerse] forKey:@"to"];
        } else {
            [dic setObject:[NSString stringWithFormat:@"%d", sourah.verseCount] forKey:@"to"];
        }

        [result addObject:dic];
    }

    return result;
}

- (NSString*)getSourahTitle:(QuranSourahInfo*)info {
    if ([[LanguageStrings instance] isRightToLeft]) {
        return info.titleArabic;
    }

    return info.titleEnglish;
}


- (int)getQuranJuzFromPage:(int)page {
    int result = 1;

    if (page >= 582) {
        result = 30;
    } else if (page >= 562) {
        result = 29;
    } else if (page >= 542) {
        result = 28;
    } else if (page >= 522) {
        result = 26;
    } else if (page >= 502) {
        result = 26;
    } else if (page >= 482) {
        result = 25;
    } else if (page >= 462) {
        result = 24;
    } else if (page >= 442) {
        result = 23;
    } else if (page >= 422) {
        result = 22;
    } else if (page >= 402) {
        result = 21;
    } else if (page >= 382) {
        result = 20;
    } else if (page >= 362) {
        result = 19;
    } else if (page >= 342) {
        result = 18;
    } else if (page >= 322) {
        result = 17;
    } else if (page >= 302) {
        result = 16;
    } else if (page >= 282) {
        result = 15;
    } else if (page >= 262) {
        result = 14;
    } else if (page >= 242) {
        result = 13;
    } else if (page >= 222) {
        result = 12;
    } else if (page >= 202) {
        result = 11;
    } else if (page >= 182) {
        result = 10;
    } else if (page >= 162) {
        result = 9;
    } else if (page >= 142) {
        result = 8;
    } else if (page >= 122) {
        result = 7;
    } else if (page >= 102) {
        result = 6;
    } else if (page >= 82) {
        result = 5;
    } else if (page >= 62) {
        result = 4;
    } else if (page >= 42) {
        result = 3;
    } else if (page >= 22) {
        result = 2;
    } else if (page >= 1) {
        result = 1;
    }

    return result;

}

- (NSString*)removeQuranSpecialChars:(NSString*)aya {
    if ([Settings shouldRemoveSpecialCharsForQuran]) {
        aya = [self removeQuranSpecialCharsForce:aya];
    }
    
    return aya;
}

- (NSString*)removeQuranSpecialCharsForce:(NSString*)aya {
    NSArray* specialChars = @[@"ٓ",
                              @"ۭ",
                              @"۟",
                              @"ۢ",
                              @"ۥ",
                              @"ۦ",
                              @"ـ",
                              @"ۜ",
                              @"۠",
                              @"۪",
                              @"۫",
                              @"ۨ",
                              @"۬",
                              @"ۣ",
                              ];
    
    for (int i = 0; i < specialChars.count; i++) {
        NSString* rep = [specialChars objectAtIndex:i];
        aya = [aya stringByReplacingOccurrencesOfString:rep withString:@""];
    }
    
    aya = [aya stringByReplacingOccurrencesOfString:@"ٱ" withString:@"ا"];
    
    return aya;
}

#pragma mark - Translations
- (NSArray*)getQuranAvailableTranslations {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    ContentFile* file = (ContentFile*)[self.contentFile getValue:@"/Quran/Translations/Index"];
    NSString* content = file.content;
    NSArray* lines = [content componentsSeparatedByString:@"\r\n"];
    
    for (int i = 0; i < lines.count / 3; i++) {
        QuranTranslationInfo* info = [[QuranTranslationInfo alloc] init];
        
        info.title = [lines objectAtIndex:i * 3];
        info.pathTemplate = [lines objectAtIndex:i * 3 + 1];
        info.language = [lines objectAtIndex:i * 3 + 2];
        
        [result addObject:info];
    }
    
    return result;
}
@end
