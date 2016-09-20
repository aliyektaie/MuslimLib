//
//  LazyLoadTrieNodeInfo.m
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "LazyLoadTrieNodeInfo.h"

@implementation LazyLoadTrieNodeInfo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _key = ' ';
        _offset = 0;
        _length = 0;
    }
    
    return self;
}

@end
