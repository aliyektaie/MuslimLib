//
//  TableViewInfoCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "TableViewInfoCell.h"
#import "Utils.h"
#import "LanguageStrings.h"

#define MARGIN 15
#define Y_MARGIN 10

@implementation TableViewInfoCell

- (void)setup {
    _title = [[UILabel alloc] init];
    [self addSubview:_title];

    _value = [[UILabel alloc] init];
    [self addSubview:_value];

    _title.textAlignment = [Utils getDefaultTextAlignment];
    _value.textAlignment = [Utils getDefaultCounterTextAlignment];

    _title.font = [Utils createDefaultFont:14];
    _value.font = [Utils createDefaultFont:14];
    _value.textColor = [UIColor grayColor];
    _value.numberOfLines = 100;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSignleLineProperty];


    if (self.singleLine) {
        self.title.textAlignment = [Utils getDefaultTextAlignment];
        self.value.textAlignment = [Utils getDefaultCounterTextAlignment];

        self.title.frame = CGRectMake(MARGIN, 0, CGRectGetWidth(self.frame) - 2 * MARGIN, CGRectGetHeight(self.frame));
        self.value.frame = CGRectMake(MARGIN, 0, CGRectGetWidth(self.frame) - 2 * MARGIN, CGRectGetHeight(self.frame));
    } else {
        self.title.textAlignment = [Utils getDefaultTextAlignment];
        self.value.textAlignment = [Utils getDefaultTextAlignment];

        CGSize sizeTitle = [self.title sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - 2 * MARGIN, 0)];
        self.title.frame = CGRectMake(MARGIN, Y_MARGIN, CGRectGetWidth(self.frame) - 2 * MARGIN, sizeTitle.height);

        CGSize sizeValue = [self.value sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - 2 * MARGIN, 0)];
        self.value.frame = CGRectMake(MARGIN, 2 * Y_MARGIN + sizeTitle.height, CGRectGetWidth(self.frame) - 2 * MARGIN, sizeValue.height);
    }
}

- (CGFloat)getHeight:(ValuePair*)value {
    self.title.text = L(value.title);
    self.value.text = value.value;

    [self setSignleLineProperty];

    if (self.singleLine) {
        return 46;
    }

    CGSize sizeTitle = [self.title sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - 2 * MARGIN, 0)];
    CGSize sizeValue = [self.value sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - 2 * MARGIN, 0)];

    return 3 * Y_MARGIN + sizeValue.height + sizeTitle.height;
}

- (void)setModel:(ValuePair *)model {
    _model = model;

    self.title.text = L(model.title);
    self.value.text = model.value;
}

- (void)setSignleLineProperty {
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);

    CGSize sizeTitle = [self.title sizeThatFits:CGSizeMake(0, height / 2)];
    CGSize sizeValue = [self.value sizeThatFits:CGSizeMake(0, height / 2)];

    if (sizeTitle.width + sizeValue.width < 0.7 * width) {
        self.singleLine = YES;
    } else {
        self.singleLine = NO;
    }
}

@end
