//
//  QuranSourahListCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/8/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranSourahListCell.h"
#import "LanguageStrings.h"
#import "Utils.h"
#import "Theme.h"
#import "NSString+Contains.h"

#define ICON_DIM 50
#define ICON_TOP_OFFSET 4
#define ICON_MARGIN (65 - ICON_DIM) / 2

@implementation QuranSourahListCell

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup {
    _imgClass = [UIButton buttonWithType:UIButtonTypeSystem];
    _imgClass.tintColor = [Theme instance].navigationBarTintColor;
    [self addSubview:_imgClass];

    _lblTitlePrimary = [[UILabel alloc] init];
    [self addSubview:_lblTitlePrimary];

    _lblTitleSecondary = [[UILabel alloc] init];
    [self addSubview:_lblTitleSecondary];

    _lblVerseCount = [[UILabel alloc] init];
    [self addSubview:_lblVerseCount];

    _lblChronologicalOrder = [[UILabel alloc] init];
    [self addSubview:_lblChronologicalOrder];

    self.lblVerseCount.textAlignment = [Utils getDefaultTextAlignment];
    self.lblTitlePrimary.textAlignment = [Utils getDefaultTextAlignment];
    self.lblTitleSecondary.textAlignment = [Utils getDefaultTextAlignment];
    self.imgClass.layer.borderWidth = 1.0f;
    self.imgClass.layer.borderColor = self.imgClass.tintColor.CGColor;
    self.imgClass.layer.cornerRadius = ICON_DIM / 2;

    self.lblVerseCount.font = [Utils createDefaultFont:9];
    self.lblTitlePrimary.font = [Utils createDefaultBoldFont:[[LanguageStrings instance] getInteger:@"QuranTab/SourahList/Item/TitleFontSize"]];
    self.lblTitleSecondary.font = [Utils createDefaultFont:11];
    self.lblVerseCount.textColor = [Utils colorFromRed:170 Green:170 Blue:170];

    if (![[LanguageStrings instance] isRightToLeft]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    self.lblChronologicalOrder.backgroundColor = [Theme instance].navigationBarTintColor;
    self.lblChronologicalOrder.textColor = [UIColor whiteColor];
    self.lblChronologicalOrder.font = [Utils createDefaultBoldFont:10];
    self.lblChronologicalOrder.layer.cornerRadius = 5;
    self.lblChronologicalOrder.textAlignment = NSTextAlignmentCenter;
    self.lblChronologicalOrder.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if ([[LanguageStrings instance] isRightToLeft]) {
        self.imgClass.frame = CGRectMake(CGRectGetWidth(self.frame) - ICON_MARGIN - ICON_DIM, ICON_MARGIN - ICON_TOP_OFFSET, ICON_DIM, ICON_DIM);
        CGFloat titleWidth = CGRectGetWidth(self.frame) - 2 * ICON_MARGIN - ICON_DIM - 10;
        CGSize size = [self.lblTitlePrimary sizeThatFits:CGSizeMake(titleWidth, 0)];
        self.lblTitlePrimary.frame = CGRectMake(5, 5, titleWidth, size.height);

        self.lblVerseCount.frame = CGRectMake(5, CGRectGetHeight(self.frame) - 20, CGRectGetWidth(self.frame) - 2 * ICON_MARGIN - ICON_DIM - 10, 20);
        self.lblChronologicalOrder.frame = CGRectMake(CGRectGetWidth(self.frame)  - ICON_MARGIN - ICON_DIM + (ICON_DIM - 25) / 2, CGRectGetHeight(self.frame) - 17, 25, 15);
    } else {
        self.imgClass.frame = CGRectMake(ICON_MARGIN, ICON_MARGIN - ICON_TOP_OFFSET, ICON_DIM, ICON_DIM);
        self.lblTitlePrimary.frame = CGRectMake(2 * ICON_MARGIN + ICON_DIM, 5, CGRectGetWidth(self.frame) - 5 - (2 * ICON_MARGIN + ICON_DIM), 20);
        self.lblTitleSecondary.frame = CGRectMake(2 * ICON_MARGIN + ICON_DIM, 5, CGRectGetWidth(self.frame) - 5 - (2 * ICON_MARGIN + ICON_DIM) - 25, 55);
        self.lblVerseCount.frame = CGRectMake(2 * ICON_MARGIN + ICON_DIM, CGRectGetHeight(self.frame) - 20, CGRectGetWidth(self.frame) - 5 - (2 * ICON_MARGIN + ICON_DIM), 20);
        self.lblChronologicalOrder.frame = CGRectMake((2 * ICON_MARGIN + ICON_DIM - 25) / 2, CGRectGetHeight(self.frame) - 17, 25, 15);
    }
}

- (void)setModel:(QuranSourahInfo*)model {
    self.info = model;

    UIImage* image = model.receptionPlace == QURAN_SOURAH_RECEPTION_PLACE_MAKI ? [UIImage imageNamed:@"QuranSourahMaki"] : [UIImage imageNamed:@"QuranSourahMadani"];
    [self.imgClass setImage:image forState:UIControlStateNormal];

    [self setTitle];

    NSString* secondaryTitle = model.titleEnglishTranslation;
    self.lblTitleSecondary.text = secondaryTitle;

    NSString* verseCount = L(@"QuranTab/SourahList/Item/VerseCount");
    self.lblVerseCount.text = [NSString stringWithFormat:verseCount, [Utils formatNumber:model.verseCount]];

    self.lblChronologicalOrder.text = [Utils formatNumber:model.orderInReception];
}

- (void)setTitle {
    NSString* primaryTitle = L(@"QuranTab/SourahList/Item/PrimaryTitle");
    primaryTitle = [primaryTitle stringByReplacingOccurrencesOfString:@"$englishName" withString:self.info.titleEnglish];
    primaryTitle = [primaryTitle stringByReplacingOccurrencesOfString:@"$arabicName" withString:self.info.titleArabic];
    primaryTitle = [primaryTitle stringByReplacingOccurrencesOfString:@"$order" withString:[Utils formatNumber:self.info.orderInBook]];

    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:primaryTitle];

    UIFont* normalFont = [Utils createDefaultBoldFont:[[LanguageStrings instance] getInteger:@"QuranTab/SourahList/Item/TitleFontSize"]];
    [text addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, primaryTitle.length)];

    if ([primaryTitle contains:@"["]) {
        int start = (int)[primaryTitle rangeOfString:@"["].location + 1;
        NSRange range = NSMakeRange(start, primaryTitle.length - start - 1);
        [text addAttribute:NSFontAttributeName value:[Utils createDefaultArabicBoldFont:[[LanguageStrings instance] getInteger:@"QuranTab/SourahList/Item/TitleFontSize"]] range:range];
    }

    self.lblTitlePrimary.attributedText = text;
}

@end
