//
//  QuranViewOptionsViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/22/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainQuranViewController.h"

@interface QuranViewOptionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgOthmanTaha;
@property (weak, nonatomic) IBOutlet UIImageView *imgTranslation;
@property (weak, nonatomic) IBOutlet UIImageView *imgArabic;

@property (weak, nonatomic) IBOutlet UILabel *titleOthmanTaha;
@property (weak, nonatomic) IBOutlet UILabel *titleTranslation;
@property (weak, nonatomic) IBOutlet UILabel *titleArabic;

@property (weak, nonatomic) UIViewController *translationsSettingsPage;
@property (weak, nonatomic) MainQuranViewController *parentPage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightTitleOthmanTaha;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightTitleTranslation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightTitleArabic;
@property (weak, nonatomic) IBOutlet UIButton *cmdTranslationSettings;
@end
