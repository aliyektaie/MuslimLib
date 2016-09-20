//
//  ContentFileValueFactory.m
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "ContentFileValueFactory.h"

@implementation ContentFileValueFactory

- (id<ITrieIndexValue>)createNew {
    return [[ContentFile alloc] init];
}

@end
