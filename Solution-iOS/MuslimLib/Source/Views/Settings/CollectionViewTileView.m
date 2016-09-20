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
        
    [self addSubview:self.titleText];
    [self addSubview:self.icon];
    
    [self.titleText addTarget:self
                       action:@selector(onTouch)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.icon addTarget:self
                  action:@selector(onTouch)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTouch {
    [self.page performSegueWithIdentifier:self.segueToPerform sender:self.page];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int HEIGHT = 40;
    int TOP_MARGIN = self.frame.size.height - HEIGHT;
    
    self.titleText.frame = CGRectMake (8, TOP_MARGIN, (float)self.frame.size.width - 16, HEIGHT - 5);
    int marginImage = 5;
    int width = TOP_MARGIN - 2 * marginImage;
    self.icon.frame = CGRectMake ((float)(self.frame.size.width - width) / 2, marginImage, width, width);
}

- (void)setTitle:(NSString*)title {
    if (![language isEqualToString:[LanguageStrings instance].name]) {
        self.titleText.titleLabel.font = [Utils createDefaultFont:12];
        language = [LanguageStrings instance].name;
    }
    
    [self.titleText setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(NSString*)image {
    [self.icon setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

@end
