//
//  SidebarItem.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/23/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "SidebarItem.h"

@implementation SidebarItem

@synthesize title = _title;
@synthesize segue = _segue;

- (instancetype) initWithTitle: (NSString*)title Segue:(NSString*)segue {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.segue = segue;
    }
    
    return self;
}

@end
