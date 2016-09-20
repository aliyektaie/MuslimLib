//
//  LightCollectionViewTileView.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/10/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "LightCollectionViewTileView.h"
#import "Utils.h"
#import "Theme.h"

@implementation LightCollectionViewTileView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize:@""];
    }
    
    return self;
}

- (void)initialize:(NSString*)text {
    self.titleText = [UIButton buttonWithType:UIButtonTypeSystem];
    self.titleText.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleText.titleLabel.font = [Utils createDefaultFont:[Utils isTablet] ? 14 : 12];
    [self.titleText setTitle:text forState:UIControlStateNormal];
    self.tintColor = [Theme instance].lightTextColor;
    self.titleText.titleLabel.numberOfLines = 2;
    
    self.icon = [UIButton buttonWithType:UIButtonTypeCustom];
    
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
    [self.titleText setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(NSString*)image {
    [self.icon setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)addBorderForImage {
    self.icon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.icon.layer.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
}

@end