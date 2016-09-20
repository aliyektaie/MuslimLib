//
//  ValuePair.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VALUE_PAIR(title, value) [[ValuePair alloc] init:title withValue:value]

@interface ValuePair : NSObject

- (instancetype)init:(NSString*)title withValue:(NSString*)value;

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* value;

@end
