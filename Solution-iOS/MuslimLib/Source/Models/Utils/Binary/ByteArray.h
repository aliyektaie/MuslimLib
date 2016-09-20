//
//  ByteArray.h
//  MemoreX
//
//  Created by Yektaie on 2/6/15.
//  Copyright (c) 2015 Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByteArray : NSObject

- (instancetype)initWithLength: (NSInteger)length;
- (instancetype)initWithData: (NSData*)data;
- (instancetype)initWithBuffer: (char*)buffer andLength: (NSInteger)length;

@property (assign, nonatomic) NSInteger length;
@property (strong, nonatomic) NSMutableData* data;

- (void)setValue: (char)value atIndex: (NSInteger)index;
- (char)get: (NSInteger)index;
- (BOOL)isEqualToByteArray: (ByteArray*)array;
- (NSString*) toBase64;
+ (ByteArray*) fromBase64:(NSString*)base64;

- (char*)getData;
@end
