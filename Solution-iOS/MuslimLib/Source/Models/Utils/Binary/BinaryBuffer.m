//
//  BinaryBuffer.m
//  MemoreX
//
//  Created by Yektaie on 2/5/15.
//  Copyright (c) 2015 Yektaie. All rights reserved.
//

#import "BinaryBuffer.h"
#import "ByteArray.h"
#import "DateTime.h"
#import "AppDelegate.h"

#ifndef USE_NEW_SERVER
#define USE_NEW_SERVER
#endif

@implementation BinaryBuffer
#pragma mark - Constructors
- (instancetype)initWithLength: (NSInteger)length {
    self = [super init];
    
    if (self) {
        self.writeIndex = 0;
        self.readIndex = 0;
        self.readOnly = false;
        self.beginIndex = 0;
        self.buffer = [[ByteArray alloc] initWithLength:length];
        self.endIndex = length - 1;
    }
    
    return self;
}

- (instancetype)initWithBuffer: (ByteArray*)byteArray {
    self = [super init];
    
    if (self) {
        self.readIndex = 0;
        self.beginIndex = 0;
        self.readOnly = false;
        self.buffer = byteArray;
        self.writeIndex = byteArray.length;
        self.endIndex = byteArray.length - 1;
    }
    
    return self;
}

#pragma mark - Append Methods
- (void)appendBoolean: (BOOL)value {
    if (value)
    {
        [self appendByte: 1];
    }
    else
    {
        [self appendByte: 0];
    }
    
}

- (void)appendByte: (char)valueToAdd {
    int num = 1;
    if ((self.writeIndex + num) > (self.endIndex + 1))
    {
        @throw @"Overflow in buffer";
    }
    [self.buffer setValue:valueToAdd atIndex:self.writeIndex];
    self.writeIndex++;
}

- (void)appendChar: (char)value {
    int num2 = 1;
    if ((self.writeIndex + num2) > (self.endIndex + 1))
    {
        @throw @"Overflow in buffer";
    }
    [self.buffer setValue:value atIndex:self.writeIndex];
    self.writeIndex++;
}

- (void)appendInteger: (int)value {
    int num = 4;
    if ((self.writeIndex + num) > (self.endIndex + 1))
    {
        @throw @"Overflow in buffer";
    }
    
    for (int i = 0; i < num; i++)
    {
        char c = (char) (value & 0x000000FF);
        [self.buffer setValue:c atIndex:self.writeIndex];
        self.writeIndex++;
        value = ((value >> 8) & 0x00FFFFFF);
    }
}

- (void)appendByteArray: (ByteArray*)array {
    NSInteger num = array.length + 4;
    if ((self.writeIndex + num) > (self.endIndex + 1))
    {
        @throw @"Overflow in buffer";
    }
    
    [self appendInteger: (int)array.length];
    for (int i = 0; i < (num - 4); i++)
    {
        [self.buffer setValue:[array get: i] atIndex:self.writeIndex];
        self.writeIndex++;
    }
}

- (void)appendShortArray: (NSArray*)value {
    @throw @"NotImplementedException";
}

- (void)appendIntegerArray: (NSArray*)value {
    @throw @"NotImplementedException";
}

- (void)appendStringArray: (NSArray*)value {
    @throw @"NotImplementedException";
}

- (void)appendShort: (short)value {
    int num = 2;
    if ((self.writeIndex + num) > (self.endIndex + 1))
    {
        @throw @"Overflow in buffer";
    }
    
    for (int i = 0; i < num; i++)
    {
        char c = (char) (value & 0x000000FF);
        [self.buffer setValue:c atIndex:self.writeIndex];
        self.writeIndex++;
        value = ((value >> 8) & 0x00FFFFFF);
    }
}

- (void)appendLong: (long)value {
    int num = 8;
    if ((self.writeIndex + num) > (self.endIndex + 1))
    {
        @throw @"Overflow in buffer";
    }
    
    for (int i = 0; i < num; i++)
    {
        char c = (char) (value & 0x00000000000000FF);
        [self.buffer setValue:c atIndex:self.writeIndex];
        self.writeIndex++;
        value = ((value >> 8) & 0x00FFFFFFFFFFFFFF);
    }
}

- (void)appendFloat: (CGFloat)value {
    float f = (float)value;
    float* v = &f;
    int* s = (int*)v;
    int r = *s;
    
    [self appendInteger:r];
}

- (void)appendString: (NSString*)value {
#ifdef USE_NEW_SERVER
    value = [BinaryBuffer toBase64:value];
    
    [self appendInteger:(int)[value length]];
    for (int i = 0; i < [value length]; i++) {
        [self appendByte:(char)[value characterAtIndex:i]];
    }
#else
    NSUInteger dataLength = [value lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    char *byteData = malloc( dataLength );
    NSRange range = NSMakeRange(0, [value length]);
    NSUInteger actualLength = 0;
    NSRange remain = NSMakeRange(0, [value length]);
    [value getBytes:byteData maxLength:dataLength usedLength:&actualLength encoding:NSUTF8StringEncoding options:0  range:range remainingRange:&remain];
    
    ByteArray* array = [[ByteArray alloc] initWithBuffer:byteData andLength: dataLength];
    
    [self appendByteArray: array];
#endif
}

- (void)appendDate: (DateTime*)date {
    int num = 7;
    if ((self.writeIndex + num) > (self.endIndex + 1))
    {
        @throw @"Overflow in buffer";
    }
    
    [self appendShort: date.year];
    [self appendByte: date.month];
    [self appendByte: date.day];
    [self appendByte: date.hour];
    [self appendByte: date.minute];
    [self appendByte: date.second];
}

#pragma mark - Read Methods
- (BOOL)readBoolean {
    return [self readByte] != 0;
}

- (Byte)readByte {
    Byte num = 0;
    if ((self.readIndex + 1) > self.writeIndex)
    {
        @throw @"Enf of buffer Exception";
    }
    num = [self.buffer get: self.readIndex];
    self.readIndex++;
    return num;
}

- (ByteArray*)readByteArray {
    ByteArray* array = [[ByteArray alloc] initWithLength: [self readInt]];
    
    for (int i = 0; i < array.length; i++)
    {
        [array setValue: [self.buffer get: self.readIndex] atIndex: i];
        self.readIndex++;
    }
    
    return array;
}

- (char)readChar {
    char num = 0;
    if ((self.readIndex + 1) > self.writeIndex)
    {
        @throw @"Enf of buffer Exception";
    }
    num = [self.buffer get: self.readIndex];
    self.readIndex++;
    return num;
}

- (CGFloat)readFloat {
    int temp = [self readInt];
    int* t = &temp;
    float* a = (float*)t;
    
    return *a;
}

- (int)readInt {
    NSInteger num = 0;
    int num2 = 4;
    if ((self.readIndex + num2) > self.writeIndex)
    {
        @throw @"Enf of buffer Exception";
    }
    
    for (int i = 0; i < num2; i++)
    {
        num = num << 8;
        NSInteger c = [self.buffer get:((self.readIndex + num2) - 1) - i];
        c = c & 0x000000FF;
        num = c | num;
    }
    self.readIndex += num2;
    return (int)num;
}

- (NSArray*)readIntArray {
    int count = [self readInt];
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        [result addObject:[[NSNumber alloc] initWithInt:[self readInt]]];
    }
    
    return result;
}

- (long)readLong {
    long num = 0;
    int num2 = 8;
    if ((self.readIndex + num2) > self.writeIndex)
    {
        @throw @"Enf of buffer Exception";
    }
    
    for (int i = 0; i < num2; i++)
    {
        num = num << 8;
        long c = [self.buffer get:((self.readIndex + num2) - 1) - i];
        c = c & 0x00000000000000FF;
        num = c | num;
    }
    self.readIndex += num2;
    return num;
}

- (short)readShort {
    NSInteger num = 0;
    int num2 = 2;
    if ((self.readIndex + num2) > self.writeIndex)
    {
        @throw @"Enf of buffer Exception";
    }
    
    for (int i = 0; i < num2; i++)
    {
        num = num << 8;
        NSInteger c = [self.buffer get:((self.readIndex + num2) - 1) - i];
        c = c & 0x000000FF;
        num = c | num;
    }
    self.readIndex += num2;
    return (int)num;
}

- (NSArray*)readShortArray {
    @throw @"NotImplementedException";
}

- (NSString*)readString {
#ifdef USE_NEW_SERVER
    ByteArray* array = [self readByteArray];

    NSString* result = [[NSString alloc] initWithBytes:[array getData] length:array.length encoding:NSUTF8StringEncoding];
//    int length = [self readInt];
//    char* data = malloc(length);
//    
//    for (int i = 0; i < length; i++) {
//        data[i] = [self readByte];
//    }

    return [BinaryBuffer fromBase64:result];
#else
    ByteArray* array = [self readByteArray];
    
    NSString* result = [[NSString alloc] initWithBytes:[array getData] length:array.length encoding:NSUTF8StringEncoding];
    
    return result;
#endif
}

- (NSArray*)readStringArray {
    int count = [self readInt];
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        [result addObject:[self readString]];
    }
    
    return result;
}

- (DateTime*)readDate {
    NSInteger year = [self readShort];
    NSInteger month = [self readByte];
    NSInteger day = [self readByte];
    NSInteger hour = [self readByte];
    NSInteger minute = [self readByte];
    NSInteger second = [self readByte];
    
    return [[DateTime alloc] init: year month: month day: day hour: hour minute: minute second: second];
}

- (int)read24BitInt {
    NSInteger num = 0;
    int num2 = 3;
    if ((self.readIndex + num2) > self.writeIndex)
    {
        @throw @"Enf of buffer Exception";
    }
    
    for (int i = 0; i < num2; i++)
    {
        num = num << 8;
        NSInteger c = [self.buffer get:((self.readIndex + num2) - 1) - i];
        c = c & 0x000000FF;
        num = c | num;
    }
    self.readIndex += num2;
    return (int)num;
}


#pragma mark - Seek Methods
- (void)reset {
    self.readIndex = self.beginIndex;
}

- (void)seekWithDistance: (NSInteger)distance {
    if (((self.readIndex + distance) < self.beginIndex) || ((self.readIndex + distance) > self.endIndex))
    {
        @throw @"Invalid seek distance.";
    }
    self.readIndex += distance;
}

#pragma mark - Get Serialized Length Methods
+ (NSInteger)getBooleanSerializedLength {
    return 1;
}

+ (NSInteger)getByteSerializedLength {
    return 1;
}

+ (NSInteger)getCharSerializedLength {
    return 1;
}

+ (NSInteger)getShortSerializedLength {
    return 2;
}

+ (NSInteger)getIntegerSerializedLength {
    return 4;
}

+ (NSInteger)getStringSerializedLength: (NSString*)value {
#ifdef USE_NEW_SERVER
    value = [BinaryBuffer toBase64:value];
    return 4 + [value length];
#else
    NSUInteger dataLength = [value lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    return dataLength + [BinaryBuffer getIntegerSerializedLength];
#endif
}

+ (NSInteger)getByteArraySerializedLengthWithValue: (ByteArray*)value {
    return value.length + [BinaryBuffer getIntegerSerializedLength];
}

- (BOOL)canRead {
    return (self.readIndex < self.endIndex + 1);
}

+ (NSString*)toBase64:(NSString*)value {
    NSUInteger dataLength = [value lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    char *byteData = malloc( dataLength );
    NSRange range = NSMakeRange(0, [value length]);
    NSUInteger actualLength = 0;
    NSRange remain = NSMakeRange(0, [value length]);
    [value getBytes:byteData maxLength:dataLength usedLength:&actualLength encoding:NSUTF8StringEncoding options:0  range:range remainingRange:&remain];
    
    ByteArray* array = [[ByteArray alloc] initWithBuffer:byteData andLength: dataLength];
    return [array toBase64];
}

+ (NSString*)fromBase64:(NSString*)value {
    ByteArray* buffer = [ByteArray fromBase64:value];
    NSString* result = [[NSString alloc] initWithData:buffer.data encoding:NSUTF8StringEncoding];
    
    return result;
    
}


@end
