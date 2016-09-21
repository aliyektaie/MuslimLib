//
//  QuranVerseCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/12/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseCell.h"
#import "QuranVerse.h"
#import "ArabicLabel.h"
#import "QuranTranslationInfo.h"

#define TRANSLATION_TITLE_LABEL_FONT(x) [QuranVerseCell getTranlationTitleFont:x]
#define TRANSLATION_CONTENT_LABEL_FONT(x) [QuranVerseCell getTranlationContentFont:x]

@interface QuranVerseCell : BaseCell

@property (strong, nonatomic) NSArray* translations;
@property (strong, nonatomic) NSArray* translationsLabel;
@property (strong, nonatomic) ArabicLabel* quranText;
@property (strong, nonatomic) UIImageView* besmAllahImage;
@property (strong, nonatomic) UILabel* besmAllahSourahInfoLabel;
@property (strong, nonatomic) QuranVerse* verse;

@property (assign, nonatomic) BOOL isBesmAllah;
@property (assign, nonatomic) QuranSourahInfo* besmAllahSourahInfo;


+ (UIFont*)getTranlationTitleFont:(QuranTranslationInfo*)info;
+ (UIFont*)getTranlationContentFont:(QuranTranslationInfo*)info;
+ (int)getBesmAllahWidth:(int)width;
+ (int)getBesmAllahCellHeight:(int)width sourahInfo:(QuranSourahInfo*)info;


@end
