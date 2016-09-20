//
//  BaseTabViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabViewController : UITabBarController <UITabBarControllerDelegate>

- (NSString*)getTitleForLabel:(int)index;

@end
