//
//  QuranPageIndexCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/16/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"


@interface QuranPageIndexCell : BaseCell

@property (strong, nonatomic) UILabel* pageNumber;
@property (strong, nonatomic) UILabel* juz;
@property (strong, nonatomic) UILabel* sourah;

@property (assign, nonatomic) int page;

@end
