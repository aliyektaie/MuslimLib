//
//  QuranPageIndexCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/16/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranPageIndexCell.h"
#import "Utils.h"
#import "Theme.h"
#import "LanguageStrings.h"
#import "MuslimLib.h"

#define MARGIN 5
#define X_MARGIN 10

@implementation QuranPageIndexCell

- (void)setup {
    _pageNumber = [[UILabel alloc] init];
    _pageNumber.font = [UIFont fontWithName:@"Avenir-Medium" size:17];
    _pageNumber.textColor = [Theme instance].navigationBarTintColor;
    _pageNumber.textAlignment = NSTextAlignmentCenter;

    [self addSubview:_pageNumber];
    
    _juz = [[UILabel alloc] init];
    _juz.font = [Utils createDefaultFont:12];
    _juz.textAlignment = [Utils getDefaultTextAlignment];

    [self addSubview:_juz];

    _sourah = [[UILabel alloc] init];
    _sourah.font = [Utils createDefaultFont:15];
    _sourah.textColor = [Theme instance].navigationBarTintColor;
    _sourah.textAlignment = [Utils getDefaultTextAlignment];

    [self addSubview:_sourah];


}

- (void)layoutSubviews {
    [super layoutSubviews];

    if ([[LanguageStrings instance] isRightToLeft]) {
        self.pageNumber.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame) - X_MARGIN, MARGIN, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame) - 2 * MARGIN);
        self.sourah.frame = CGRectMake(MARGIN, MARGIN, CGRectGetWidth(self.frame) - (X_MARGIN + 2 * MARGIN + CGRectGetHeight(self.frame)), CGRectGetHeight(self.frame) / 2);
        self.juz.frame = CGRectMake(MARGIN, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame) - (X_MARGIN + 2 * MARGIN + CGRectGetHeight(self.frame)), CGRectGetHeight(self.frame) / 2);
    } else {
        self.pageNumber.frame = CGRectMake(X_MARGIN, MARGIN, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame) - 2 * MARGIN);
        self.sourah.frame = CGRectMake(X_MARGIN + MARGIN + CGRectGetHeight(self.frame), MARGIN, CGRectGetWidth(self.frame) - (X_MARGIN + 2 * MARGIN + CGRectGetHeight(self.frame)), CGRectGetHeight(self.frame) / 2);
        self.juz.frame = CGRectMake(X_MARGIN + MARGIN + CGRectGetHeight(self.frame), CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame) - (X_MARGIN + 2 * MARGIN + CGRectGetHeight(self.frame)), CGRectGetHeight(self.frame) / 2);
    }
}

- (void)setPage:(int)page {
    _page = page;
    int juzNumber = [[MuslimLib instance] getQuranJuzFromPage:page];
    NSArray* sourahs = [[MuslimLib instance] getQuranPageSourahs:page];

    self.pageNumber.text = [NSString stringWithFormat:@"﴾%@﴿", [Utils formatNumber:page]];
    self.juz.text = [NSString stringWithFormat:L(@"QuranTab/SelectQuranPage/JuzText"), [Utils formatNumber:juzNumber]];
    self.sourah.text = [self getSourahText:sourahs];

    if (page % 2 == 0) {
        self.backgroundColor = [Theme instance].lightPageGradientTopColor;
    } else {
        self.backgroundColor = [Theme instance].lightPageGradientBottomColor;
    }
}

- (NSString*)getSourahText:(NSArray*)list {
    NSMutableString* result = [[NSMutableString alloc] init];

    for (int i = 0; i < list.count; i++) {
        if (i > 0) {
            [result appendString:@" - "];
        }

        NSDictionary* dic = [list objectAtIndex:i];
        NSString* from = [Utils formatNumber:[[dic objectForKey:@"from"] intValue]];
        NSString* to = [Utils formatNumber:[[dic objectForKey:@"to"] intValue]];
        if ([from isEqualToString:to]) {
            [result appendFormat:@"%@ [%@]", [dic objectForKey:@"title"], from];
        } else {
            [result appendFormat:@"%@ [%@ - %@]", [dic objectForKey:@"title"], from, to];
        }
    }

    return result;
}

@end
