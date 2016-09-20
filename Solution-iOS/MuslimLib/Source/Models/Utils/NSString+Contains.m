//
//  NSString+Contains.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/21/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString (Contains)

- (BOOL)contains:(NSString*)toSearch {
    NSRange range = [(NSString*)self rangeOfString:toSearch];

    return range.location != NSNotFound;
}

@end
