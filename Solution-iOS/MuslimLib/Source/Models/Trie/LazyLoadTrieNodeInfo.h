//
//  LazyLoadTrieNodeInfo.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LazyLoadTrieNodeInfo : NSObject

@property (assign, nonatomic) unichar key;
@property (assign, nonatomic) int offset;
@property (assign, nonatomic) int length;

@end
