//
//  SetLanguageSegue.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/10/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "SetLanguageSegue.h"
#import "Settings.h"
#import "LanguageStrings.h"

@implementation SetLanguageSegue

- (void)perform {
    [Settings setLanguageFileName:self.identifier];
    [((UIViewController*)self.sourceViewController).navigationController popViewControllerAnimated:YES];
}

@end
