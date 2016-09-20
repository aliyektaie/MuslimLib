//
//  QuranTranslationInfo.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/10/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranTranslationInfo.h"
#import "Settings.h"
#import "MuslimLib.h"
#import "ContentFile.h"

@implementation QuranTranslationInfo

- (NSString*)getTitleString {
    return self.title;
}

- (UIImage*)getImage {
    return [UIImage imageNamed:self.language];
}

- (BOOL)isSelected {
    return [Settings isTranslationActive:self.title];
}

- (void)setSelected:(BOOL)value {
    [Settings setTranslationActive:value title:self.title];
}

- (NSString*)getTranslation:(QuranVerse*)verse {
    MuslimLib* instance = [MuslimLib instance];
    ContentFile* file = (ContentFile*)[instance.contentFile getValue:[NSString stringWithFormat:self.pathTemplate, verse.sourahInfo.orderInBook, verse.verseNumber]];
    
    return file.content;
}

@end
