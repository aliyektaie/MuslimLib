//
//  RandomAccessFile.h
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ByteArray.h"

@interface RandomAccessFile : NSObject

- (instancetype)init:(NSString*)path;

- (ByteArray*)read:(int) length withOffset:(int)offset;
- (int)readInt:(int)offset;
- (ByteArray*)readAllFile;
- (ByteArray*)readAllFileFrom:(int)index;

@end
