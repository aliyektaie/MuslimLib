//
//  Trie.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IValueFactory.h"
#import "TrieNode.h"

@interface Trie : NSObject

- (instancetype)initWithRoot:(TrieNode*)root withFactory:(id<IValueFactory>)factory;

@property (strong, nonatomic) id<IValueFactory> factory;
@property (strong, nonatomic) TrieNode* rootNode;

- (id<ITrieIndexValue>)get:(NSString*)key;
- (TrieNode*)get:(TrieNode*)currentNode withKey:(NSString*)key withIndexOnKey:(int)indexOnKey;
- (BOOL)contains:(NSString*)key;

@end
