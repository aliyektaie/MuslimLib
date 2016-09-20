//
//  SidebarCell.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/24/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "SidebarCell.h"
#import "Utils.h"
#import "Theme.h"

@implementation SidebarCell

@synthesize titleLabel = _titleLabel;
@synthesize defaultFont = _defaultFont;
@synthesize model = _model;

- (instancetype) init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SIDEBAR_CELL_IDENTIFIER];
    
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [[Theme instance] sidebarItemTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.defaultFont = self.titleLabel.font;
        self.titleLabel.font = [Utils createDefaultFont:[Utils isTablet] ? 17 : 15];

        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (void) setCellModel:(SidebarItem*)m_model {
    self.model = m_model;
    
    self.titleLabel.text = self.model.title;
    self.titleLabel.textAlignment = [Utils getDefaultTextAlignment];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
