//
//  Guid.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/29/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "Guid.h"

@interface Guid() {
    NSString* _value;
}

@end

@implementation Guid

- (instancetype) initWithString:(NSString*)value {
    self = [super init];
    
    if (self) {
        _value = value;
    }
    
    return self;
}

+ (Guid*)empty {
    return [[Guid alloc] initWithString:@"00000000-0000-0000-0000-000000000000"];
}

- (BOOL)isEmpty {
    return [_value isEqualToString:@"00000000-0000-0000-0000-000000000000"];
}

- (instancetype) initWithByteArray:(ByteArray*)guid {
    self = [super init];
    
    if (self) {
        ByteArray* raw = [[ByteArray alloc] initWithLength:16];
        
        [raw setValue:[guid get:0] atIndex:3];
        [raw setValue:[guid get:1] atIndex:2];
        [raw setValue:[guid get:2] atIndex:1];
        [raw setValue:[guid get:3] atIndex:0];
        [raw setValue:[guid get:4] atIndex:5];
        [raw setValue:[guid get:5] atIndex:4];
        [raw setValue:[guid get:6] atIndex:7];
        [raw setValue:[guid get:7] atIndex:6];
        [raw setValue:[guid get:8] atIndex:8];
        [raw setValue:[guid get:9] atIndex:9];
        [raw setValue:[guid get:10] atIndex:10];
        [raw setValue:[guid get:11] atIndex:11];
        [raw setValue:[guid get:12] atIndex:12];
        [raw setValue:[guid get:13] atIndex:13];
        [raw setValue:[guid get:14] atIndex:14];
        [raw setValue:[guid get:15] atIndex:15];
        
        
        NSString* p1= [self getStringValue:raw start:0 length:8];
        NSString* p2= [self getStringValue:raw start:8 length:4];
        NSString* p3= [self getStringValue:raw start:12 length:4];
        NSString* p4= [self getStringValue:raw start:16 length:4];
        NSString* p5= [self getStringValue:raw start:20 length:12];
        
        _value = p1;
        _value = [_value stringByAppendingString:@"-"];
        _value = [_value stringByAppendingString:p2];
        _value = [_value stringByAppendingString:@"-"];
        _value = [_value stringByAppendingString:p3];
        _value = [_value stringByAppendingString:@"-"];
        _value = [_value stringByAppendingString:p4];
        _value = [_value stringByAppendingString:@"-"];
        _value = [_value stringByAppendingString:p5];
    }
    
    return self;
}

- (NSString*)getStringValue: (ByteArray*)raw start:(int)start length:(int)length {
    NSString* result = [self bytesToHex:raw];
    NSRange range;
    range.location = start;
    range.length = length;
    
    result = [result substringWithRange:range];
    
    return result;
}

- (NSString*) bytesToHex:(ByteArray*)bytes
{
    NSString* hexArray = @"0123456789abcdef";
    NSString* result = @"";
    NSRange range;
    range.length = 1;
    
    for ( int j = 0; j < bytes.length; j++ ) {
        int v = [bytes get:j] & 0xFF;
        
        range.location = v / 16;
        NSString* character = [hexArray substringWithRange:range];
        result = [result stringByAppendingString:character];
        
        range.location = v % 16;
        character = [hexArray substringWithRange:range];
        result = [result stringByAppendingString:character];
    }
    
    return result;
}

+ (Guid*)newGuid {
    NSString* p1 = [self getRandomString:8];
    NSString* p2 = [self getRandomString:4];
    NSString* p3 = [self getRandomString:4];
    NSString* p4 = [self getRandomString:4];
    NSString* p5 = [self getRandomString:12];
    
    NSString* g = p1;
    g = [g stringByAppendingString:@"-"];
    g = [g stringByAppendingString:p2];
    g = [g stringByAppendingString:@"-"];
    g = [g stringByAppendingString:p3];
    g = [g stringByAppendingString:@"-"];
    g = [g stringByAppendingString:p4];
    g = [g stringByAppendingString:@"-"];
    g = [g stringByAppendingString:p5];
    
    return [[Guid alloc] initWithString:g];
}

+ (NSString*)getRandomString:(int)length {
    NSString* hexArray = @"0123456789abcdef";
    NSString* result = @"";
    NSRange range;
    range.length = 1;
    
    for (int i = 0; i < length; i++) {
        range.location = arc4random() % 16;
        NSString* character = [hexArray substringWithRange:range];
        result = [result stringByAppendingString:character];
    }
    
    return result;
}

- (NSString*)description {
    return _value;
}

- (ByteArray*)toByteArray {
    ByteArray* guid = [self toRawArray];
    ByteArray* result = [[ByteArray alloc] initWithLength:16];
    
    [result setValue:[guid get:3] atIndex:0];
    [result setValue:[guid get:2] atIndex:1];
    [result setValue:[guid get:1] atIndex:2];
    [result setValue:[guid get:0] atIndex:3];
    [result setValue:[guid get:5] atIndex:4];
    [result setValue:[guid get:4] atIndex:5];
    [result setValue:[guid get:7] atIndex:6];
    [result setValue:[guid get:6] atIndex:7];
    [result setValue:[guid get:8] atIndex:8];
    [result setValue:[guid get:9] atIndex:9];
    [result setValue:[guid get:10] atIndex:10];
    [result setValue:[guid get:11] atIndex:11];
    [result setValue:[guid get:12] atIndex:12];
    [result setValue:[guid get:13] atIndex:13];
    [result setValue:[guid get:14] atIndex:14];
    [result setValue:[guid get:15] atIndex:15];
    
    return result;
}

- (ByteArray*) toRawArray {
    ByteArray* result = [[ByteArray alloc] initWithLength:16];
    NSString* s = [_value stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSRange range;
    range.length = 2;
    
    for (int i = 0; i < 16; i++) {
        range.location = i * 2;
        NSString* digit = [s substringWithRange:range];
        
        unsigned hex = 0;
        NSScanner *scanner = [NSScanner scannerWithString:digit];
        
        [scanner setScanLocation:0];
        [scanner scanHexInt:&hex];
        
        int b = (int)hex;
        [result setValue:(char)b atIndex:i];
    }
    
    return result;
}

- (BOOL)isEqual:(id)object
{
    BOOL result = [object isKindOfClass:[Guid class]];
    
    if (result) {
        Guid* g = (Guid*)object;
        result = [[g description] isEqual:[self description]];
    }
    
    return result;
}

@end
