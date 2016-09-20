//
//  MainWindowViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/13/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"

@interface MainWindowViewController : BaseViewController

+ (MainWindowViewController*)instance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleHeight;

@end
