//
//  MainWindowViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/13/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "MainWindowViewController.h"
#import "Theme.h"
#import "Utils.h"

@interface MainWindowViewController ()

@end

@implementation MainWindowViewController

static MainWindowViewController* _instance;

+ (MainWindowViewController*)instance {
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _instance = self;
}

- (UIColor*)getBackgroundTopColor {
    return  [Theme instance].lightPageGradientTopColor;
}

- (UIColor*)getBackgroundBottomColor {
    return  [Theme instance].lightPageGradientBottomColor;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    if ([Utils isIPhone5Size]) {
        self.layoutTitleHeight.constant = 28;
    }
}

@end
