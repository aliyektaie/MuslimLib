//
//  QuranSourahInfo.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/8/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranSourahInfo.h"
#import "Utils.h"
#import "LanguageStrings.h"

@implementation QuranSourahInfo

+ (QuranSourahInfo*)loadFromJSON:(NSDictionary*)json {
    QuranSourahInfo* result = [[QuranSourahInfo alloc] init];

    result.titleArabic = STRING(@"titleArabic");
    result.titleEnglish = STRING(@"titleEnglish");
    result.titleEnglishTranslation = STRING(@"titleEnglishTranslation");
    result.titleEnglishReference = STRING(@"titleEnglishReference");
    result.contentThemeEnglish = STRING(@"contentThemeEnglish");
    result.titlePersianReference = STRING(@"titlePersianReference");
    result.contentThemePersian = STRING(@"contentThemePersian");
    result.moghataatArabic = STRING(@"moghataatArabic");
    result.moghataatEnglish = STRING(@"moghataatEnglish");

    result.orderInBook = INT(@"orderInBook");
    result.orderInAlphabetic = INT(@"orderInAlphabetic");
    result.orderInReception = INT(@"orderInReception");
    result.receptionPlace = INT(@"receptionPlace");
    result.verseCount = INT(@"verseCount");
    result.wordCount = INT(@"wordCount");
    result.letterCount = INT(@"letterCount");
    result.sijdahCount = INT(@"sijdahCount");

    return result;
}

- (NSString*)getClassification {
    NSString* result = @"";

    if (self.receptionPlace == QURAN_SOURAH_RECEPTION_PLACE_MAKI) {
        result = L(@"Quran/Maki");
    } else {
        result = L(@"Quran/Madani");
    }

    return result;
}

- (NSString*)getTitleTranslation {
    NSString* result = @"";

    if ([[LanguageStrings instance].name isEqualToString:@"English"]) {
        result = self.titleEnglishTranslation;
    }

    return result;
}

- (NSString*)getTitleReference {
    NSString* result = @"";

    if ([[LanguageStrings instance].name isEqualToString:@"Persian"]) {
        result = self.titlePersianReference;
    } else if ([[LanguageStrings instance].name isEqualToString:@"English"]) {
        result = self.titleEnglishReference;
    }

    return result;
}

- (BOOL)hasContentConcepts {
    return ![[self getContentConcepts] isEqualToString:@""];
}

- (NSString*)getContentConcepts {
    NSString* result = @"";

    if ([[LanguageStrings instance].name isEqualToString:@"Persian"]) {
        result = self.contentThemePersian;
    } else if ([[LanguageStrings instance].name isEqualToString:@"English"]) {
        result = self.contentThemeEnglish;
    }

    return result;
}

- (BOOL)hasMoghataat {
    return [self.moghataatEnglish length] > 0;
}


@end
