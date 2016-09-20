//
//  SidebarItemCell.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/24/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "SidebarItemCell.h"
#import "LanguageStrings.h"
#import "SidebarParameters.h"

@implementation SidebarItemCell

- (instancetype) init {
    self = [super init];
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    int margin = 5;
    int imagePadding = 7;
    int imageDim = 0;
    
    if ([[LanguageStrings instance] isRightToLeft]) {
        float titleWidth = (float)(self.frame.size.width - 3 * margin - imagePadding - 6);
        float titleX = 9;
        self.titleLabel.frame = CGRectMake (titleX, 0, titleWidth, (float)self.frame.size.height);
    } else {
        self.titleLabel.frame = CGRectMake (margin * 3 + imagePadding, 0, (float)([SidebarParameters sidebarWidth] - 3 * margin - imagePadding - 6), (float)self.frame.size.height);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
