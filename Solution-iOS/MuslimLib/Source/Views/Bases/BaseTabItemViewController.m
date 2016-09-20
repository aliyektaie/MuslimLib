//
//  BaseTabItemViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseTabItemViewController.h"
#import "LanguageStrings.h"
#import "SWRevealViewController.h"
#import "SidebarParameters.h"
#import "Theme.h"

@interface BaseTabItemViewController () {
    BOOL alreadyAddedGuestures;
}

@end

@implementation BaseTabItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];

    if ([[LanguageStrings instance] isRightToLeft]) {
        [self initializeSidebar:self.rightSidebarButton];
        self.rightSidebarButton.tintColor = [Theme instance].navigationBarTintColor;
        self.leftSidebarButton.tintColor = [UIColor clearColor];
    } else {
        [self initializeSidebar:self.leftSidebarButton];
        self.leftSidebarButton.tintColor = [Theme instance].navigationBarTintColor;
        self.rightSidebarButton.tintColor = [UIColor clearColor];
    }

}

- (void)setupNavigationBar {
    self.rightSidebarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SidebarImage"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(rightRevealToggle:)];
    self.leftSidebarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SidebarImage"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];

    self.navigationItem.rightBarButtonItem = self.rightSidebarButton;
    self.navigationItem.leftBarButtonItem = self.leftSidebarButton;
}

- (void) initializeSidebar:(UIBarButtonItem*)sidebarButton {
    sidebarButton.tintColor = [Theme instance].navigationBarTintColor;

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [sidebarButton setTarget: self.revealViewController];

        if ([SidebarParameters isRightToLeft]) {
            [sidebarButton setAction: @selector( rightRevealToggle: )];
        } else {
            [sidebarButton setAction: @selector( revealToggle: )];
        }

        if (!alreadyAddedGuestures) {
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];

            alreadyAddedGuestures = YES;
        }
    }
}


@end
