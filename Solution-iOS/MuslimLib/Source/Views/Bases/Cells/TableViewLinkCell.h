//
//  TableViewLinkCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseCell.h"

@interface TableViewLinkCell : BaseCell

@property (strong, nonatomic) UILabel* title;

- (void)setLinkText:(NSString*)title;

@end
