//
//  BaseCell.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString*)identifier;
- (void)setup;
@end
