//
//  SidebarItemSegue.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/28/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "SidebarItemSegue.h"
#import "SWRevealViewController.h"
#import "SidebarParameters.h"
#import "LanguageStrings.h"
#import "MainWindowViewController.h"
#import "Utils.h"

@implementation SidebarItemSegue

- (void) perform {
        UIViewController* src = self.sourceViewController;
        UIViewController* dest = self.destinationViewController;

//        if ([Utils isTablet] && ([dest isKindOfClass:[MyAccountPage class]] || [dest isKindOfClass:[AboutPage class]])) {
//            UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:dest];
//            navController.modalPresentationStyle = UIModalPresentationFormSheet;
//            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//
//            [src presentViewController:navController animated:YES completion:nil];
//        } else {
            [[MainWindowViewController instance].navigationController pushViewController:self.destinationViewController animated:YES];
//        }

        if ([SidebarParameters isRightToLeft]) {
            [src.revealViewController rightRevealToggle:nil];
        } else {
            [src.revealViewController revealToggle:nil];
        }
}

@end
