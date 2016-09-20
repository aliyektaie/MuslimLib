//
//  QuranTabViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranTabViewController.h"
#import "LanguageStrings.h"

@interface QuranTabViewController ()

@end

@implementation QuranTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString*)getTitleForLabel:(int)index {
    NSString* result = @"";

    switch (index) {
        case 0:
            result = L(@"QuranTab/Quran");
            break;
        case 1:
            result = L(@"QuranTab/Commentary");
            break;
        case 2:
            result = L(@"QuranTab/SourahList");
            break;
        case 3:
            result = L(@"QuranTab/Search");
            break;
        case 4:
            result = L(@"QuranTab/Settings");
            break;
    }

    return result;
}

@end
