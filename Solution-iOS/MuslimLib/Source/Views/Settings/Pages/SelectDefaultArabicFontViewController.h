//
//  SelectDefaultArabicFontViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/5/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SelectDefaultArabicFontViewController : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutDescriptionHeight;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentSelector;
@property (weak, nonatomic) IBOutlet UILabel *exampleFont;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
