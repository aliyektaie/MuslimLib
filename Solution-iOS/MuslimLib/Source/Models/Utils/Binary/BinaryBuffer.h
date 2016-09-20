//
//  BinaryBuffer.h
//  MemoreX
//
//  Created by Yektaie on 2/5/15.
//  Copyright (c) 2015 Yektaie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ByteArray.h"

@class DateTime;

typedef enum {
    EncodingUTF8,
    EncodingUnicode,
} Encoding;

@interface BinaryBuffer : NSObject

// Constructors
- (instancetype)initWithLength: (NSInteger)length;
- (instancetype)initWithBuffer: (ByteArray*)buffer;

// Public Properties
@property (assign, nonatomic) NSInteger beginIndex;
@property (strong, nonatomic) ByteArray* buffer;
@property (assign, nonatomic) NSInteger endIndex;
@property (assign, nonatomic) NSInteger readIndex;
@property (assign, nonatomic) BOOL readOnly;
@property (assign, nonatomic) NSInteger writeIndex;

// Public Methods
- (void)appendBoolean: (BOOL)value;
- (void)appendByte: (char)valueToAdd;
- (void)appendChar: (char)value;
- (void)appendInteger: (int)value;
- (void)appendByteArray: (ByteArray*)array;
- (void)appendShortArray: (NSArray*)value;
- (void)appendIntegerArray: (NSArray*)value;
- (void)appendStringArray: (NSArray*)value;
- (void)appendShort: (short)value;
- (void)appendLong: (long)value;
- (void)appendFloat: (CGFloat)value;
- (void)appendString: (NSString*)value;
- (void)appendDate: (DateTime*)date;

- (BOOL)readBoolean;
- (Byte)readByte;
- (ByteArray*)readByteArray;
- (char)readChar;
- (CGFloat)readFloat;
- (int)readInt;
- (NSArray*)readIntArray;
- (long)readLong;
- (short)readShort;
- (NSArray*)readShortArray;
- (NSString*)readString;
- (NSArray*)readStringArray;
- (DateTime*)readDate;
- (int)read24BitInt;

- (void)reset;
- (void)seekWithDistance: (NSInteger)distance;
- (BOOL)canRead;

// Static Methods
+ (NSInteger)getBooleanSerializedLength;
+ (NSInteger)getByteSerializedLength;
+ (NSInteger)getCharSerializedLength;
+ (NSInteger)getShortSerializedLength;
+ (NSInteger)getIntegerSerializedLength;
+ (NSInteger)getStringSerializedLength: (NSString*)value;
+ (NSInteger)getByteArraySerializedLengthWithValue: (ByteArray*)value;

@end