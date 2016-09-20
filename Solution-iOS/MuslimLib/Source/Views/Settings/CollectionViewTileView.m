//
//  CollectionViewTileView.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/9/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "CollectionViewTileView.h"
#import "Utils.h"
#import "Theme.h"
#import "LanguageStrings.h"

@interface CollectionViewTileView() {
    NSString* language;
}

@end

@implementation CollectionViewTileView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize:@""];
    }
    
    return self;
}

- (void)initialize:(NSString*)text {
    language = [LanguageStrings instance].name;
    
    self.titleText = [UIButton buttonWithType:UIButtonTypeSystem];
    self.titleText.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleText.titleLabel.font = [Utils createDefaultFont:[Utils isTablet] ? 14 : 13];
    [self.titleText setTitle:text forState:UIControlStateNormal];
    self.titleText.tintColor = [Theme instance].defaultTextColor;
    self.titleText.titleLabel.numberOfLines = 2;
    
    self.icon = [UIButton buttonWithType:UIButtonTypeSystem];
    self.icon.tintColor = [Theme instance].defaultTextColor;
        
    [self addSubview:self.icon];
    [self addSubview:self.titleText];
    
    [self.titleText addTarget:self
                       action:@selector(onTouch:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.icon addTarget:self
                  action:@selector(onTouch:)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTouch:(id)sender {
    [self.page performSegueWithIdentifier:self.segueToPerform sender:self.page];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int HEIGHT = 40;
    int TOP_MARGIN = self.frame.size.height - HEIGHT;
    
    self.titleText.frame = CGRectMake (8, TOP_MARGIN, (float)self.frame.size.width - 16, HEIGHT - 5);
    int marginImage = 5;
    int width = TOP_MARGIN - 2 * marginImage;
    
    if (self.shouldFillImage) {
        self.icon.frame = CGRectMake (10, 10, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 20);
        self.titleText.frame = CGRectMake (10, (CGRectGetHeight(self.frame) * 0.75) - 10, CGRectGetWidth(self.frame) - 20, (float)(CGRectGetHeight(self.frame) * 0.25));
    } else {
        self.icon.frame = CGRectMake ((float)(self.frame.size.width - width) / 2, marginImage, width, width);
    }
}

- (void)setTitle:(NSString*)title {
    if (![language isEqualToString:[LanguageStrings instance].name]) {
        self.titleText.titleLabel.font = [Utils createDefaultFont:12];
        language = [LanguageStrings instance].name;
    }
    
    if (self.shouldFillImage) {
        self.titleText.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.titleText.titleLabel.font = [Utils createDefaultBoldFont:14];
    }

    [self.titleText setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(NSString*)image {
    if (self.shouldFillImage) {
        [self.icon setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    } else {
        [self.icon setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
}

@end
