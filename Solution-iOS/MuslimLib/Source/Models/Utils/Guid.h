//
//  Guid.h
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/29/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryBuffer.h"

@interface Guid : NSObject

- (instancetype) initWithString:(NSString*)value;
- (instancetype) initWithByteArray:(ByteArray*)value;

+ (Guid*)newGuid;
+ (Guid*)empty;

- (ByteArray*)toByteArray;
- (BOOL)isEmpty;

- (BOOL)isEqual:(id)object;
@end
