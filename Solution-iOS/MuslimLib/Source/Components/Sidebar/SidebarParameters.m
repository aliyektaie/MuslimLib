//
//  SidebarParameters.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/25/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "SidebarParameters.h"
#import "Utils.h"
#import "LanguageStrings.h"

@implementation SidebarParameters

+ (float) sidebarWidth {
    if ([Utils isTablet]) {
        return 300.0f;
    }
    
    return 220.0f;
}

+ (BOOL) isRightToLeft {
    return [[LanguageStrings instance] isRightToLeft];
}

@end
