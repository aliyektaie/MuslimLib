//
//  RandomAccessFile.m
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "RandomAccessFile.h"
#import "BinaryBuffer.h"

@interface RandomAccessFile() {
    NSString* _path;
    NSFileHandle* _handle;
}

@end

@implementation RandomAccessFile

- (instancetype)init:(NSString*)path {
    self = [super init];
    
    if (self) {
        _path = path;
        _handle = [NSFileHandle fileHandleForReadingAtPath:_path];
    }
    
    return self;
}

- (ByteArray*)read:(int) length withOffset:(int)offset {
    [_handle seekToFileOffset:offset];
    NSData* data = [_handle readDataOfLength:length];
    
    return [[ByteArray alloc] initWithData:data];
}

- (int)readInt:(int)offset {
    ByteArray* array = [self read:4 withOffset:offset];
    BinaryBuffer* buffer = [[BinaryBuffer alloc] initWithBuffer:array];
    
    return [buffer readInt];
}

- (ByteArray*)readAllFile {
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:_path error:NULL];
    int fileSize = (int)[attributes fileSize]; // in bytes
    
    return [self read:fileSize withOffset:0];
}

- (ByteArray*)readAllFileFrom:(int)index {
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:_path error:NULL];
    int fileSize = (int)[attributes fileSize] - index; // in bytes
    
    return [self read:fileSize withOffset:index];
}

@end
