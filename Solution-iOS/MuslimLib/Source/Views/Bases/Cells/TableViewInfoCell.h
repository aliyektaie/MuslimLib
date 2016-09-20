//
//  TableViewInfoCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseCell.h"
#import "ValuePair.h"

@interface TableViewInfoCell : BaseCell

@property (strong, nonatomic) UILabel* title;
@property (strong, nonatomic) UILabel* value;
@property (assign, nonatomic) BOOL singleLine;

@property (strong, nonatomic) ValuePair* model;

- (CGFloat)getHeight:(ValuePair*)value;
- (void)setSignleLineProperty;

@end
