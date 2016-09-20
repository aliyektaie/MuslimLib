//
//  TableViewLinkCell.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "TableViewLinkCell.h"
#import "Utils.h"
#import "LanguageStrings.h"
#import "Theme.h"

#define MARGIN 15

@implementation TableViewLinkCell

- (void)setup {
    _title = [[UILabel alloc] init];
    [self addSubview:_title];

    _title.textAlignment = [Utils getDefaultTextAlignment];

    _title.font = [Utils createDefaultFont:14];
    _title.textColor = [Utils colorFromRed:51 Green:102 Blue:187];

    if (![[LanguageStrings instance] isRightToLeft]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.title.frame = CGRectMake(MARGIN, 0, CGRectGetWidth(self.frame) - 2 * MARGIN, CGRectGetHeight(self.frame));
}


- (void)setLinkText:(NSString*)title {
    self.title.text = title;
}
@end
