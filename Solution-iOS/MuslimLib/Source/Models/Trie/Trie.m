//
//  Trie.m
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "Trie.h"

@implementation Trie

- (instancetype)initWithRoot:(TrieNode*)root withFactory:(id<IValueFactory>)factory {
    self = [super init];
    
    if (self) {
        _factory = factory;
        _rootNode = root;
    }
    
    return self;
}

- (id<ITrieIndexValue>)get:(NSString*)key
{
    TrieNode* x = [self get:self.rootNode withKey:key withIndexOnKey:0];
    
    if (x == nil)
    {
        return nil;
    }
    
    return x.value;
}

- (TrieNode*)get:(TrieNode*)currentNode withKey:(NSString*)key withIndexOnKey:(int)indexOnKey {
    if (currentNode == nil)
    {
        return nil;
    }
    
    if (indexOnKey == key.length)
    {
        return currentNode;
    }
    
    unichar c = [key characterAtIndex:indexOnKey];
    return [self get:[currentNode getNodeByCharacter:c] withKey:key withIndexOnKey:indexOnKey + 1];
}

- (BOOL)contains:(NSString*)key {
    return [self get:key] != nil;
}

@end
