//
//  ContentFile.m
//  TipBasedApp
//
//  Created by Mohammad Ali Yektaie on 8/17/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "ContentFile.h"
#import "BinaryBuffer.h"

#define ContentFileFieldContent 0x0001
#define ContentFileFieldBinaryContent 0x0002
#define ContentFileFieldType 0x0004
#define ContentFileFieldID 0x0008
#define ContentFileFieldTitle 0x0020


@implementation ContentFile

- (void)load:(ByteArray*)array {
    BinaryBuffer* buffer = [[BinaryBuffer alloc] initWithBuffer:array];
    
    int header = [buffer readInt];
    
    self.type = (ContentFileType)[buffer readByte];
    
    if ((header & ContentFileFieldID) != 0)
        self.ID = [[Guid alloc] initWithString:[buffer readString]];
    else
        self.ID = [Guid empty];
    
    if ((header & ContentFileFieldTitle) != 0)
        self.title = [buffer readString];
    else
        self.title = @"";
    
    if ((header & ContentFileFieldContent) != 0)
        self.content = [buffer readString];
    
    if ((header & ContentFileFieldBinaryContent) != 0)
        self.binaryContent = [buffer readByteArray];
}

@end
