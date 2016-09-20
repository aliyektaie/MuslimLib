//
//  TrieNode.m
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "TrieNode.h"
#import "BinaryBuffer.h"
#import "LazyLoadTrieNodeInfo.h"

#define ITrieIndexValueDefinition 4

@interface TrieNode() {
    RandomAccessFile* _file;
    id<IValueFactory> _factory;
}

@end

@implementation TrieNode

- (instancetype)initWithFactory:(id<IValueFactory>)factory withFile:(RandomAccessFile*)file {
    self = [super init];
    
    if (self) {
        _nodes = [[NSMutableDictionary alloc] init];
        
        _factory = factory;
        _file = file;
    }
    
    return self;
}

+ (TrieNode*) loadWithData:(ByteArray*)array withFile:(RandomAccessFile*)file withFactory:(id<IValueFactory>)factory {
    TrieNode* result = [[TrieNode alloc] initWithFactory:factory withFile:file];
    BinaryBuffer* buffer = [[BinaryBuffer alloc] initWithBuffer:array];
    int header = [buffer readByte];
    
    int childCount = [buffer readShort];
    for (int i = 0; i < childCount; i++)
    {
        unichar c = (unichar)[buffer readShort];
        int offset = [buffer readInt];
        int length = [buffer read24BitInt];
        
        LazyLoadTrieNodeInfo* info = [[LazyLoadTrieNodeInfo alloc] init];
        info.key = c;
        info.length = length;
        info.offset = offset;
        
        NSString* key = [NSString stringWithFormat: @"%C", c];
        [result.nodes setObject:info forKey:key];
    }
    
    if ((header & ITrieIndexValueDefinition) != 0)
    {
        ByteArray* temp = [buffer readByteArray];
        char* _key;
        int _keyLength;
        
        _keyLength = 4;
        _key = (char*)alloca(_keyLength);
        _key[0] = 0xEB;
        _key[1] = 29;
        _key[2] = 71;
        _key[3] = 39;
        
        char* data = [temp getData];
        for (int i = 0; i < temp.length; i++)
        {
            data[i] = (char)(data[i] ^ _key[i % _keyLength]);
        }
        
        id<ITrieIndexValue> value = [factory createNew];
        [value load:temp];
        
        result.value = value;
    }
    
    return result;
}

- (TrieNode*)getNodeByCharacter:(unichar) c
{
    NSString* key = [NSString stringWithFormat: @"%C", c];
    NSObject* v = [self.nodes objectForKey:key];
    
    if (v == nil)
    {
        return nil;
    }
    
    if ([v isKindOfClass:[TrieNode class]])
    {
        return (TrieNode*)v;
    }
    
    LazyLoadTrieNodeInfo* info = (LazyLoadTrieNodeInfo*)v;
    ByteArray* array = [_file read:info.length withOffset:info.offset];
    
    [self.nodes setObject:[TrieNode loadWithData:array withFile:_file withFactory:_factory] forKey:key];
    
    return [self getNodeByCharacter:c];
}
@end
