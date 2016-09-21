//
//  QuranVerseCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/12/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranVerseCell.h"
#import "Utils.h"
#import "QuranTranslationInfo.h"

#define MARGIN 10
#define BESM_HEIGHT_TO_WIDTH_RATIO 0.135
#define BESM_SOURAH_INFO_HEIGHT_NORMAL 25
#define BESM_SOURAH_INFO_HEIGHT_WITHOUT_BESM_ALLAH 50

@interface QuranVerseCell() {
}

@end

@implementation QuranVerseCell

- (void)setup {
    self.quranText = [[ArabicLabel alloc] init];
    [self addSubview:self.quranText];
    
    self.translationsLabel = @[];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);

    if (self.isBesmAllah) {
        if ([self.besmAllahSourahInfo hasBesmAllah]) {
            int besmWidth = [QuranVerseCell getBesmAllahWidth:width];
            self.besmAllahImage.frame = CGRectMake((width - besmWidth) / 2, MARGIN, besmWidth, (int)(besmWidth * BESM_HEIGHT_TO_WIDTH_RATIO));
            self.besmAllahSourahInfoLabel.frame = CGRectMake(0, 2 * MARGIN + (int)(besmWidth * BESM_HEIGHT_TO_WIDTH_RATIO), width, BESM_SOURAH_INFO_HEIGHT_NORMAL);
        } else {
            self.besmAllahSourahInfoLabel.frame = CGRectMake(0, MARGIN, width, BESM_SOURAH_INFO_HEIGHT_WITHOUT_BESM_ALLAH);
        }
    } else {
        int textHeight = [ArabicLabel getHeightForText:self.verse.text inWidth:width - 2 * MARGIN];
        self.quranText.frame = CGRectMake(MARGIN, MARGIN, CGRectGetWidth(self.frame) - 2 * MARGIN, textHeight);
        
        CGFloat currentY = textHeight + 2 * MARGIN;
        for (int i = 0; i < self.translationsLabel.count; i++) {
            currentY += MARGIN;
            UILabel* label = [self.translationsLabel objectAtIndex:i];
            
            CGSize size = [label sizeThatFits:CGSizeMake(width - 2 * MARGIN, 0)];
            label.frame = CGRectMake(MARGIN, currentY, width - 2 * MARGIN, size.height);
            
            currentY += size.height;
            if ((i % 2) == 1) {
                currentY += MARGIN;
            }
        }
    }
}

+ (int)getBesmAllahWidth:(int)width {
    int result = 0;
    
    if ([Utils isTablet]) {
        result = 300;
    } else {
        result = (int)(width * 0.7);
    }
    
    return result;
}

+ (int)getBesmAllahCellHeight:(int)width sourahInfo:(QuranSourahInfo*)info {
    if ([info hasBesmAllah]) {
        return (int)(3 * MARGIN + BESM_HEIGHT_TO_WIDTH_RATIO * [QuranVerseCell getBesmAllahWidth:width] + BESM_SOURAH_INFO_HEIGHT_NORMAL);
    } else {
        return (int)(2 * MARGIN + BESM_SOURAH_INFO_HEIGHT_WITHOUT_BESM_ALLAH);
    }
}

- (void)setIsBesmAllah:(BOOL)isBesmAllah {
    _isBesmAllah = isBesmAllah;
    
    self.backgroundColor = isBesmAllah ? [Utils colorFromRed:205 Green:195 Blue:164] : [UIColor clearColor];
    self.quranText.hidden = isBesmAllah;
    if (isBesmAllah) {
        self.translations = @[];
    }
    
    if (self.besmAllahImage == nil) {
        self.besmAllahImage = [[UIImageView alloc] init];
        self.besmAllahSourahInfoLabel = [[UILabel alloc] init];
        
        self.besmAllahImage.image = [UIImage imageNamed:@"BesmAllah"];
        self.besmAllahSourahInfoLabel.textAlignment = NSTextAlignmentCenter;
        self.besmAllahSourahInfoLabel.font = [UIFont fontWithName:@"IRANSans" size:13];

        [self addSubview:self.besmAllahImage];
        [self addSubview:self.besmAllahSourahInfoLabel];
    }

    if (isBesmAllah) {
        if ([self.besmAllahSourahInfo hasBesmAllah]) {
            self.besmAllahSourahInfoLabel.font = [UIFont fontWithName:@"IRANSans" size:13];
        } else {
            self.besmAllahSourahInfoLabel.font = [UIFont fontWithName:@"IRANSans" size:18];
        }
    }
    
    self.besmAllahSourahInfoLabel.hidden = !isBesmAllah;
    self.besmAllahImage.hidden = !isBesmAllah || ![self.besmAllahSourahInfo hasBesmAllah];
    self.besmAllahSourahInfoLabel.text = [NSString stringWithFormat:@"سوره %@", self.besmAllahSourahInfo.titleArabic];
}

- (void)setTranslations:(NSArray *)translations {
    _translations = translations;
    
    if (self.translationsLabel.count != translations.count) {
        for (int i = 0; i < self.translationsLabel.count; i++) {
            UIView* view = [self.translationsLabel objectAtIndex:i];
            [view removeFromSuperview];
        }
        
        NSMutableArray* labels = [[NSMutableArray alloc] init];
        for (int i = 0; i < translations.count; i++) {
            QuranTranslationInfo* info = [translations objectAtIndex:i];
            
            if (translations.count > 1) {
                UILabel* titleLabel = [[UILabel alloc] init];
                titleLabel.font = TRANSLATION_TITLE_LABEL_FONT(info);
                titleLabel.textColor = [Utils colorFromRed:140 Green:105 Blue:0];
                
                [self addSubview:titleLabel];
                [labels addObject:titleLabel];
            }

            UILabel* contentLabel = [[UILabel alloc] init];
            contentLabel.font = TRANSLATION_CONTENT_LABEL_FONT(info);
            contentLabel.numberOfLines = 100;
            
            [self addSubview:contentLabel];
            [labels addObject:contentLabel];
        }
        
        self.translationsLabel = labels;
    }
    
    if (translations.count == 1) {
        UILabel* contentLabel = [self.translationsLabel objectAtIndex:0];
        QuranTranslationInfo* info = [translations objectAtIndex:0];
        
        contentLabel.text = [info getTranslation:self.verse];
        contentLabel.textAlignment = [self getTextAlignment:info];
    } else {
        for (int i = 0; i < translations.count; i++) {
            UILabel* titleLabel = [self.translationsLabel objectAtIndex:i * 2];
            UILabel* contentLabel = [self.translationsLabel objectAtIndex:i * 2 + 1];
            QuranTranslationInfo* info = [translations objectAtIndex:i];
            
            titleLabel.text = info.title;
            contentLabel.text = [info getTranslation:self.verse];
            contentLabel.textAlignment = [self getTextAlignment:info];
            titleLabel.textAlignment = [self getTextAlignment:info];
        }
    }
}

- (NSTextAlignment)getTextAlignment:(QuranTranslationInfo*)info {
    NSTextAlignment result = NSTextAlignmentLeft;
    
    if ([info.language isEqualToString:@"Persian"]) {
        result = NSTextAlignmentRight;
    }
    
    return result;
}

+ (UIFont*)getTranlationTitleFont:(QuranTranslationInfo*)info {
    NSString* name = @"Avenir-Black";
    CGFloat size = 17;
    
    if ([info.language isEqualToString:@"Persian"]) {
        name = @"IRANSans-Bold";
        size = 15;
    }
    
    return [UIFont fontWithName:name size:size];
}

+ (UIFont*)getTranlationContentFont:(QuranTranslationInfo*)info {
    NSString* name = @"Avenir-Book";
    CGFloat size = 15;
    
    if ([info.language isEqualToString:@"Persian"]) {
        name = @"IRANSans";
        size = 13;
    }
    
    return [UIFont fontWithName:name size:size];
}

@end
