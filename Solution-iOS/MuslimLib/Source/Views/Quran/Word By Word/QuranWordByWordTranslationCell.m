//
//  QuranWordByWordTranslationCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/26/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranWordByWordTranslationCell.h"
#import "Settings.h"
#import "ArabicLabel.h"
#import "Utils.h"
#import "Theme.h"

#define ARABIC_WORD_WIDTH 80

@implementation QuranWordByWordTranslationCell

- (void)setup {
    self.lblArabicText = [[UILabel alloc] init];
    self.lblTransliteration = [[UILabel alloc] init];
    self.lblTranslation = [[UILabel alloc] init];
    
    self.lblArabicText.font = [UIFont fontWithName:[Settings getDefaultArabicFont] size:28];
    self.lblArabicText.textColor = [Theme instance].navigationBarTintColor;
    self.lblArabicText.textAlignment = NSTextAlignmentRight;
    
    self.lblTransliteration.font = [Utils createDefaultFont:12];
    self.lblTransliteration.textColor = [UIColor grayColor];
    self.lblTransliteration.textAlignment = NSTextAlignmentLeft;
    
    self.lblTranslation.font = [Utils createDefaultFont:14];
    self.lblTranslation.textAlignment = NSTextAlignmentJustified;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.lblArabicText];
    [self addSubview:self.lblTranslation];
    [self addSubview:self.lblTransliteration];
}

- (void)setModel:(VerseWordTranslation *)model {
    self.lblArabicText.text = model.arabicText;
    self.lblTranslation.text = model.translation;
    self.lblTransliteration.text = model.transliteration;
    
    _model = model;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    int margin = 10;
    int y_margin = 5;
    
    self.lblArabicText.frame = CGRectMake(width - ARABIC_WORD_WIDTH - 10, 0, ARABIC_WORD_WIDTH, height);
    self.lblTranslation.frame = CGRectMake(margin, y_margin, width - margin - ARABIC_WORD_WIDTH, height / 2 - y_margin * 1.5);
    self.lblTransliteration.frame = CGRectMake(margin, height / 2 + 0.5 * y_margin, width - margin - ARABIC_WORD_WIDTH, height / 2 - y_margin * 1.5);
}

@end
