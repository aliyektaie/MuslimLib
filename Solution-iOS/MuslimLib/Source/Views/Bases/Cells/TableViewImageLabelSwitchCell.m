//
//  TableViewImageLabelSwitchCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/10/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "TableViewImageLabelSwitchCell.h"
#import "LanguageStrings.h"
#import "Utils.h"

@implementation TableViewImageLabelSwitchCell

- (void)setup {
    self.lblTitle = [[UILabel alloc] init];
    self.icon = [[UIImageView alloc] init];
    self.selectedSwitch = [[UISwitch alloc] init];
    
    [self addSubview:self.lblTitle];
    [self addSubview:self.icon];
    [self addSubview:self.selectedSwitch];
    
    [self.selectedSwitch addTarget: self action: @selector(flip:) forControlEvents: UIControlEventValueChanged];
    self.backgroundColor = [UIColor clearColor];
    self.lblTitle.font = [Utils createDefaultFont:15];
    self.lblTitle.textAlignment = [Utils getDefaultTextAlignment];
}

- (void) flip: (id) sender {
    [self.model setSelected:self.selectedSwitch.on];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat widthSelect = CGRectGetWidth(self.selectedSwitch.frame);
    CGFloat heightSelect = CGRectGetHeight(self.selectedSwitch.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    int MARGIN = 10;
    
    if ([[LanguageStrings instance] isRightToLeft]) {
        self.icon.frame = CGRectMake(width - height + MARGIN, MARGIN, height - 2 * MARGIN, height - 2 * MARGIN);
        self.lblTitle.frame = CGRectMake(2 * MARGIN + widthSelect, 0, width - height - 2 * MARGIN - widthSelect, height);
        self.selectedSwitch.frame = CGRectMake(MARGIN, (height - heightSelect) / 2, widthSelect, heightSelect);
    } else {
        self.icon.frame = CGRectMake(MARGIN, MARGIN, height - 2 * MARGIN, height - 2 * MARGIN);
        self.lblTitle.frame = CGRectMake(height, 0, width - height - 2 * MARGIN - widthSelect, height);
        self.selectedSwitch.frame = CGRectMake(width - widthSelect - MARGIN, (height - heightSelect) / 2, widthSelect, heightSelect);
    }
}

- (void)setModel:(id<IItemWithTextImageAndSelection>)model {
    _model = model;
    
    self.lblTitle.text = [model getTitleString];
    self.icon.image = [model getImage];
    self.selectedSwitch.on = [model isSelected];
}

@end
