//
//  TrieNode.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomAccessFile.h"
#import "IValueFactory.h"
#import "ITrieIndexValue.h"

@interface TrieNode : NSObject

- (instancetype)initWithFactory:(id<IValueFactory>)factory withFile:(RandomAccessFile*)file;

@property (strong, nonatomic) id<ITrieIndexValue> value;
@property (strong, nonatomic) NSMutableDictionary* nodes;
@property (assign, nonatomic) int offsetInFile;

+ (TrieNode*) loadWithData:(ByteArray*)array withFile:(RandomAccessFile*)file withFactory:(id<IValueFactory>)factory;
- (TrieNode*)getNodeByCharacter:(unichar) c;
@end
