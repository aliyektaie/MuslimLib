//
//  PresentViewSegue.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/16/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "PresentViewSegue.h"

@implementation PresentViewSegue

- (void)perform {
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:self.destinationViewController];
    [self.sourceViewController presentViewController:navController animated:YES completion:^{
        if ([self.destinationViewController conformsToProtocol:@protocol(IPresentedViewController)]) {
            [((id<IPresentedViewController>)self.destinationViewController) setParentViewController:self.sourceViewController];
        }
    }];
}

@end
