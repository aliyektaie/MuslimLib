//
//  PresentViewSegue.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/16/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPresentedViewController <NSObject>

- (void)setParentViewController:(UIViewController*)controller;

@end

@interface PresentViewSegue : UIStoryboardSegue

@end
