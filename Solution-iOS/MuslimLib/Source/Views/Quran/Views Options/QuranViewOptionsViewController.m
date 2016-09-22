//
//  QuranViewOptionsViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/22/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranViewOptionsViewController.h"
#import "LanguageStrings.h"
#import "Utils.h"
#import <STPopup/STPopup.h>

@interface QuranViewOptionsViewController ()

@end

@implementation QuranViewOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = L(@"QuranTab/ReadQuran/ViewsModeTitle");
    
    [self setupImageBorder:self.imgArabic];
    [self setupImageBorder:self.imgTranslation];
    [self setupImageBorder:self.imgOthmanTaha];
    
    [self setupTitle:self.titleOthmanTaha text:L(@"QuranTab/ReadQuran/ViewModes/Page")];
    [self setupTitle:self.titleTranslation text:L(@"QuranTab/ReadQuran/ViewModes/QuranAndTranslation")];
    [self setupTitle:self.titleArabic text:L(@"QuranTab/ReadQuran/ViewModes/QuranOnly")];

    [self.cmdTranslationSettings setTitle:L(@"SettingsPage/Settings/Quran/Translations") forState:UIControlStateNormal];
    if ([[LanguageStrings instance] isRightToLeft]) {
        self.cmdTranslationSettings.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    } else {
        self.cmdTranslationSettings.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    self.cmdTranslationSettings.titleLabel.font = [Utils createDefaultFont:15];

    [self.titleArabic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setArabicMode)]];
    [self.imgArabic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setArabicMode)]];
    
    [self.titleTranslation addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTranslationMode)]];
    [self.imgTranslation addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTranslationMode)]];
    
    [self.titleOthmanTaha addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setBookMode)]];
    [self.imgOthmanTaha addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setBookMode)]];
    
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateTitleLabel:self.titleOthmanTaha layout:self.layoutHeightTitleOthmanTaha];
    [self updateTitleLabel:self.titleTranslation layout:self.layoutHeightTitleTranslation];
    [self updateTitleLabel:self.titleArabic layout:self.layoutHeightTitleArabic];
}

- (void)setupImageBorder:(UIImageView*)image {
    image.layer.borderWidth = 1;
    image.layer.borderColor = [UIColor grayColor].CGColor;
    image.userInteractionEnabled = YES;
}

- (void)setupTitle:(UILabel*)label text:(NSString*)text {
    label.numberOfLines = 3;
    label.text = text;
    label.textAlignment = [Utils getDefaultTextAlignment];
    label.font = [Utils createDefaultBoldFont:17];
    label.userInteractionEnabled = YES;
}

- (void)updateTitleLabel:(UILabel*)label layout:(NSLayoutConstraint*)layout {
    CGSize size = [label sizeThatFits:CGSizeMake(CGRectGetWidth(label.frame), 0)];
    layout.constant = size.height;
}

- (IBAction)onSettingsTranslations:(id)sender {
    [self performSegueWithIdentifier:@"s_ShowTranslationsSettings" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"s_ShowTranslationsSettings"]) {
        UIViewController* destination = segue.destinationViewController;
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:L(@"Close") style:UIBarButtonItemStylePlain target:self action:@selector(onTranslationSettingsPageClosed:)];
        [button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [Utils createDefaultFont:16], NSFontAttributeName,
                                               nil]
                                     forState:UIControlStateNormal];
        self.translationsSettingsPage = destination;
        destination.navigationItem.rightBarButtonItem = button;
    }
}

- (void)onTranslationSettingsPageClosed:(id)sender {
    [self.translationsSettingsPage dismissViewControllerAnimated:YES completion:nil];
    [self.parentPage updateTranslationChange];
    
    if (self.parentPage.mode == MODE_ARABIC_ONLY ||
        self.parentPage.mode == MODE_ARABIC_AND_TRANSLATION) {
        
        [self.parentPage setupReadingMode];
    }
}

- (void)setBookMode {
    self.parentPage.mode = MODE_BOOK;
    [self.parentPage setupBookMode];
    
    [self.popupController dismiss];
}

- (void)setArabicMode {
    self.parentPage.mode = MODE_ARABIC_ONLY;
    [self.parentPage setupReadingMode];
    
    [self.popupController dismiss];
}

- (void)setTranslationMode {
    self.parentPage.mode = MODE_ARABIC_AND_TRANSLATION;
    [self.parentPage setupReadingMode];
    
    [self.popupController dismiss];
}

@end
