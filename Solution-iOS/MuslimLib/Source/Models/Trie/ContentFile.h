//
//  ContentFile.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ByteArray.h"
#import "Guid.h"
#import "ITrieIndexValue.h"

typedef enum : int {
    ContentFileTypeBinary = 4,
} ContentFileType;

@interface ContentFile : NSObject <ITrieIndexValue>

@property (strong, nonatomic) NSString* internalContentPath;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) ByteArray* binaryContent;
@property (assign, nonatomic) ContentFileType type;
@property (strong, nonatomic) Guid* ID;
@property (strong, nonatomic) NSString* title;

- (void)load:(ByteArray*)array;
@end
