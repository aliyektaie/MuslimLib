//
//  ShowQuranSpecialCharsViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/10/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "ShowQuranSpecialCharsViewController.h"
#import "LanguageStrings.h"
#import "Theme.h"
#import "Utils.h"
#import "Settings.h"
#import "ArabicLabel.h"
#import "MuslimLib.h"

#define EXAMPLE_TEXT @"مَّا لَهُم بِهِۦ مِنْ عِلْمٍۢ وَلَا لِءَابَآئِهِمْ ۚ كَبُرَتْ كَلِمَةًۭ تَخْرُجُ مِنْ أَفْوَٰهِهِمْ ۚ إِن يَقُولُونَ إِلَّا كَذِبًۭا"


@interface ShowQuranSpecialCharsViewController ()

@end

@implementation ShowQuranSpecialCharsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = L(@"SettingsPage/Settings/Quran/SpecialChars");
    self.descriptionLabel.text = L(@"SelectSpecialArabicChars/Description");
    self.descriptionLabel.textColor = [Theme instance].defaultTextColor;
    self.descriptionLabel.font = [Utils createDefaultFont:14];
    self.descriptionLabel.textAlignment = [Utils getDefaultTextAlignment];
    
    self.segmentSelector.tintColor = [Theme instance].defaultTextColor;
    
    self.exampleFont.textColor = [Theme instance].defaultTextColor;
    
    if ([Settings shouldRemoveSpecialCharsForQuran]) {
        self.segmentSelector.selectedSegmentIndex = 1;
    } else {
        self.segmentSelector.selectedSegmentIndex = 0;
    }
    
    [self onValueChanged:nil];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    CGSize size = [self.descriptionLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.descriptionLabel.frame), 0)];
    self.layoutDescriptionHeight.constant = size.height;
}

- (BOOL)hasSidebarButton {
    return NO;
}

- (IBAction)onValueChanged:(id)sender {
    switch (self.segmentSelector.selectedSegmentIndex) {
        case 0:
            [Settings setShouldRemoveSpecialCharsForQuran:NO];
            break;
        case 1:
            [Settings setShouldRemoveSpecialCharsForQuran:YES];
            break;
    }
    
    NSString* text = EXAMPLE_TEXT;
    if ([Settings shouldRemoveSpecialCharsForQuran]) {
        text = [[MuslimLib instance] removeQuranSpecialCharsForce:text];
    }

    self.exampleFont.text = text;
    self.exampleFont.font = [UIFont fontWithName:@"Scheherazade-Regular" size:25];
}

@end
