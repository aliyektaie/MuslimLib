//
//  BaseTabViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseTabViewController.h"
#import "SWRevealViewController.h"
#import "SidebarParameters.h"

@interface BaseTabViewController ()

@end

@implementation BaseTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeLabels];

    self.delegate = self;
}

- (void)initializeLabels {
    for (int i = 0; i < self.viewControllers.count; i++) {
        UITabBarItem* item = [self.tabBar.items objectAtIndex:i];
        item.title = [self getTitleForLabel:i];
    }
}

- (NSString*)getTitleForLabel:(int)index {
    return @"";
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([self.revealViewController isOpen]) {
        if (![SidebarParameters isRightToLeft]) {
            [self.revealViewController revealToggleAnimated:YES];
        } else {
            [self.revealViewController rightRevealToggleAnimated:YES];
        }
    }
}

@end
