//
//  SidebarCell.h
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/24/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarItem.h"

#define SIDEBAR_CELL_IDENTIFIER @"sidebar_cell_identifier"

@interface SidebarCell : UITableViewCell

- (instancetype) init;

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) SidebarItem* model;
@property (strong, nonatomic) UIFont* defaultFont;

- (void) setCellModel:(SidebarItem*)model;

@end
