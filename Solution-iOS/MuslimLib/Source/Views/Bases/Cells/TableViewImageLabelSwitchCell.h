//
//  TableViewImageLabelSwitchCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/10/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseCell.h"

@protocol IItemWithTextImageAndSelection <NSObject>

@required

- (NSString*)getTitleString;
- (UIImage*)getImage;
- (BOOL)isSelected;
- (void)setSelected:(BOOL)value;

@end

@interface TableViewImageLabelSwitchCell : BaseCell

@property (strong, nonatomic) UILabel* lblTitle;
@property (strong, nonatomic) UIImageView* icon;
@property (strong, nonatomic) UISwitch* selectedSwitch;
@property (strong, nonatomic) id<IItemWithTextImageAndSelection> model;

@end
