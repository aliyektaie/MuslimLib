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
    self.lblArabicText = [[UIImageView alloc] init];
    self.lblTransliteration = [[UILabel alloc] init];
    self.lblTranslation = [[UILabel alloc] init];
    
    self.lblTransliteration.font = [Utils createDefaultFont:12];
    self.lblTransliteration.textColor = [UIColor grayColor];
    self.lblTransliteration.textAlignment = NSTextAlignmentLeft;
    
    self.lblTranslation.font = [Utils createDefaultFont:14];
    self.lblTranslation.textAlignment = NSTextAlignmentJustified;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.lblArabicText];
    [self addSubview:self.lblTranslation];
    [self addSubview:self.lblTransliteration];
    
    self.morphologyLabels = [[NSMutableArray alloc] init];
}

- (void)setModel:(VerseWordTranslation *)model {
    NSString* url = [NSString stringWithFormat:@"http://corpus.quran.com/wordimage?id=%@", model.arabicImageLink];
    self.lblArabicText.image = nil;
    self.tempImage = nil;
    [self.lblArabicText setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.lblArabicText.image = image;
        self.tempImage = image;
        [self setNeedsLayout];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [self setNeedsLayout];
    }];
    self.lblTranslation.text = model.translation;
    self.lblTransliteration.text = model.transliteration;
    
    while (self.morphologyLabels.count > 0) {
        UIView* view = [self.morphologyLabels objectAtIndex:0];
        [view removeFromSuperview];
        [self.morphologyLabels removeObject:view];
    }

    for (int i = 0; i < model.syntaxAndMorphology.count; i++) {
        UILabel* label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"Avenir-Medium" size:12];
        NSString* line = [model.syntaxAndMorphology objectAtIndex:i];
        NSString* text = [line substringFromIndex:[line rangeOfString:@"//"].location + 2];
        text = [text stringByReplacingOccurrencesOfString:@"//" withString:@" "];
        label.text = text;
        
        NSString* color = [line substringToIndex:[line rangeOfString:@"//"].location];
        label.textColor = [self parseColor:color];
        
        [self addSubview:label];
        [self.morphologyLabels addObject:label];
    }
    
    UILabel* label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"IRANSans" size:10.5f];
    label.textColor = [Theme instance].navigationBarTintColor;
    label.text = model.arabicGrammar;
    
    [self addSubview:label];
    [self.morphologyLabels addObject:label];

    
    _model = model;
}

- (UIColor*)parseColor:(NSString*)value {
    unsigned hex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:value];
    
    [scanner setScanLocation:0];
    [scanner scanHexInt:&hex];
    
    int top = (int)hex;
    
    int red = (top & 0x00ff0000) >> 16;
    int green = (top & 0x0000ff00) >> 8;
    int blue = (top & 0x000000ff);
    
    return [Utils colorFromRed:red Green:green Blue:blue];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    int margin = 10;
    int y_margin = 5;
    
    if (self.tempImage == nil) {
        self.lblArabicText.frame = CGRectMake(0,0,0,0);
    } else {
        CGFloat imageHeight = 65;
        CGFloat imageWidth = (imageHeight * self.tempImage.size.width) / self.tempImage.size.height;
        
        self.lblArabicText.frame = CGRectMake(width - imageWidth - 10, 5, imageWidth, imageHeight);
    }
  
    int translationPartHeight = 55;
    self.lblTranslation.frame = CGRectMake(margin, y_margin, width - margin - ARABIC_WORD_WIDTH, translationPartHeight / 2 - y_margin * 1.5);
    self.lblTransliteration.frame = CGRectMake(margin, translationPartHeight / 2 + 0.5 * y_margin, width - margin - ARABIC_WORD_WIDTH, translationPartHeight / 2 - y_margin * 1.5);
    
    for (int i = 0; i < self.morphologyLabels.count; i++) {
        UIView* label = [self.morphologyLabels objectAtIndex:i];
        label.frame = CGRectMake(10, 75 + i * HEIGHT_OF_MORPHOLOGY_LABEL, width - 20, HEIGHT_OF_MORPHOLOGY_LABEL);
    }
}

@end
