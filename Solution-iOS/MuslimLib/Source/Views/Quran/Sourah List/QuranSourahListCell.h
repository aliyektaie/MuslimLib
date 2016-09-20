//
//  QuranSourahListCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/8/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuranSourahInfo.h"

@interface QuranSourahListCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString*)identifier;

@property (strong, nonatomic) UIButton* imgClass;
@property (strong, nonatomic) UILabel* lblTitlePrimary;
@property (strong, nonatomic) UILabel* lblTitleSecondary;
@property (strong, nonatomic) UILabel* lblVerseCount;
@property (strong, nonatomic) UILabel* lblChronologicalOrder;

@property (strong, nonatomic) QuranSourahInfo* info;

- (void)setModel:(QuranSourahInfo*)model;
@end
