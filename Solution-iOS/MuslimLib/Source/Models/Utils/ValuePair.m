//
//  ValuePair.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "ValuePair.h"

@implementation ValuePair

- (instancetype)init:(NSString*)title withValue:(NSString*)value {
    self = [super init];

    if (self) {
        _value = value;
        _title = title;
    }

    return self;
}

@end
