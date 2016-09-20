//
//  TrieFile.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trie.h"

@interface TrieFile : NSObject

- (instancetype)initWithPath:(NSString*)path withFactory:(id<IValueFactory>)factory;

@property (strong, nonatomic) Trie* trie;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) id<IValueFactory> factory;
@property (assign, nonatomic) int revision;

- (BOOL)contains:(NSString*) key;
- (id<ITrieIndexValue>)getValue:(NSString*) key;

@end
