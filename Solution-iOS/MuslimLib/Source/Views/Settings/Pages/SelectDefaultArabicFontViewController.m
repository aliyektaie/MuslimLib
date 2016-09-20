//
//  SelectDefaultArabicFontViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/5/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "SelectDefaultArabicFontViewController.h"
#import "LanguageStrings.h"
#import "Theme.h"
#import "Utils.h"
#import "Settings.h"
#import "ArabicLabel.h"

@implementation SelectDefaultArabicFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = L(@"SettingsPage/Settings/DefaultFont");
    self.descriptionLabel.text = L(@"SelectDefaultArabicFontPage/Description");
    self.descriptionLabel.textColor = [Theme instance].defaultTextColor;
    self.descriptionLabel.font = [Utils createDefaultFont:14];
    self.descriptionLabel.textAlignment = [Utils getDefaultTextAlignment];

    self.segmentSelector.tintColor = [Theme instance].defaultTextColor;

    self.exampleFont.textColor = [Theme instance].defaultTextColor;

    NSString* defaultFont = [Settings getDefaultArabicFont];

    if ([defaultFont isEqualToString:@"Scheherazade-Regular"]) {
        self.segmentSelector.selectedSegmentIndex = 0;
    } else if ([defaultFont isEqualToString:@"Al_Mushaf"]) {
        self.segmentSelector.selectedSegmentIndex = 1;
    } else if ([defaultFont isEqualToString:@"KFGQPCUthmanTahaNaskh"]) {
        self.segmentSelector.selectedSegmentIndex = 2;
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
    NSString* fontName = @"";

    switch (self.segmentSelector.selectedSegmentIndex) {
        case 0:
            fontName = @"Scheherazade-Regular";
            break;
        case 1:
            fontName = @"Al_Mushaf";
            break;
        case 2:
            fontName = @"KFGQPCUthmanTahaNaskh";
            break;
    }

    [Settings setDefaultArabicFont:fontName];
    [ArabicLabel invalidateQuranFont];
    self.exampleFont.font = [UIFont fontWithName:fontName size:[self getFontSize]];
}

- (int)getFontSize {
    int result = 25;
    
    NSString* defaultFont = [Settings getDefaultArabicFont];
    if ([defaultFont isEqualToString:@"Scheherazade-Regular"]) {
        result = (int)(result * 1.0);
    } else if ([defaultFont isEqualToString:@"Al_Mushaf"]) {
        result = (int)(result * 0.95);
    } else if ([defaultFont isEqualToString:@"KFGQPCUthmanTahaNaskh"]) {
        result = (int)(result * 0.8);
    }
    
    return result;
}

@end
