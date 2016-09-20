//
//  ByteArray.m
//  MemoreX
//
//  Created by Yektaie on 2/6/15.
//  Copyright (c) 2015 Yektaie. All rights reserved.
//

#import "ByteArray.h"

@interface ByteArray()

@end

@implementation ByteArray

@synthesize length;

- (char*)getData {
    return (char*)self.data.bytes;
}

- (instancetype)initWithLength: (NSInteger)arrayLength {
    self = [super init];
    
    if (self) {
        length = arrayLength;
        _data = [[NSMutableData alloc] initWithCapacity:arrayLength];
        _data.length = length;
    }
    
    return self;
}

- (instancetype)initWithData: (NSData*)_data_n {
    self = [super init];
    
    if (self) {
        length = [_data_n length];
        _data = [_data_n mutableCopy];
    }
    
    return self;
}

- (instancetype)initWithBuffer: (char*)buffer andLength: (NSInteger)arrayLength {
    self = [super init];
    
    if (self) {
        length = arrayLength;
        _data = [[NSMutableData alloc] initWithBytes:buffer length:arrayLength];
    }
    
    return self;
}

- (void)setValue: (char)value atIndex: (NSInteger)index {
    if (index < 0 || index >= self.length) {
        @throw @"IndexOutOfRangeException";
    }
    
    ((char*)self.data.bytes)[index] = value;
}

- (char)get: (NSInteger)index {
    if (index < 0 || index >= self.length) {
        @throw @"IndexOutOfRangeException";
    }
    
    return ((char*)self.data.bytes)[index];
}

- (BOOL)isEqualToByteArray: (ByteArray*)array {
    BOOL result = self.length == array.length;
    
    for (int i = 0; i < self.length && result; i++) {
        result = ((char*)self.data.bytes)[i] == [array getData][i];
    }
    
    return result;
}

- (NSString*) toBase64 {
    return [self.data base64EncodedStringWithOptions:0];
}

+ (ByteArray*) fromBase64:(NSString*)base64 {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSUInteger size = [decodedData length] / sizeof(char);
    char* array = (char*) [decodedData bytes];
    
    return [[ByteArray alloc] initWithBuffer:array andLength:size];
}
@end
