//
//  TrieFile.m
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "TrieFile.h"
#import "RandomAccessFile.h"
#import "BinaryBuffer.h"

@implementation TrieFile

- (instancetype)initWithPath:(NSString*)path withFactory:(id<IValueFactory>)factory {
    self = [super init];
    
    if (self) {
        _factory = factory;
        RandomAccessFile* file = [[RandomAccessFile alloc] init:path];
        
        int headerLength = [file readInt:5];
        int rootLength = [file readInt:9];
        
        ByteArray* rootNodeSerialized = [file read:rootLength withOffset:headerLength];
        TrieNode* node = [TrieNode loadWithData:rootNodeSerialized withFile:file withFactory:factory];
        _trie = [[Trie alloc] initWithRoot:node withFactory:factory];
        
        _revision = [file readInt:1];
        
        BinaryBuffer* buffer = [[BinaryBuffer alloc] initWithBuffer:[file read:headerLength withOffset:0]];
        buffer.readIndex = 13;
        _title = [buffer readString];
    }
    
    return self;
}

- (id<ITrieIndexValue>)getValue:(NSString*) key
{
    id<ITrieIndexValue> result = nil;
    
    result = [self.trie get:key];
    
    return result;
}

- (BOOL)contains:(NSString*) key
{
    return [self.trie contains:key];
}


@end
