//
//  LanguageStrings.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "LanguageStrings.h"
#import "Utils.h"
#import "Settings.h"

@interface LanguageStrings () {
    NSMutableDictionary* strings;
}

@end


@implementation LanguageStrings

static LanguageStrings* sharedInstance = nil;

+ (LanguageStrings*)instance {
    if (sharedInstance == nil) {
        sharedInstance = [[LanguageStrings alloc] init];
    }

    return sharedInstance;
}

+ (void)invalidate {
    sharedInstance = nil;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        NSArray* lines = [Utils readTextFileLinesFromResource:[Settings getLanguageFileName]];
        strings = [[NSMutableDictionary alloc] init];

        for (int i = 0; i < lines.count; i++) {
            if (![self isCommandLine:[lines objectAtIndex:i]]) {
                NSString* _id = [self getID:[lines objectAtIndex:i]];
                NSString* _value = [self getString :[lines objectAtIndex:i]];

                [strings setObject:_value forKey:_id];
            }
        }

        _name = [self get:@"Language"];
    }

    return self;
}

-(NSString*) getID:(NSString*)line {
    NSRange index = [line rangeOfString:@":"];

    return [line substringToIndex:(index.location)];
}

-(NSString*) getString:(NSString*)line {
    NSRange index = [line rangeOfString:@":"];

    return [[line substringFromIndex:(index.location + 1)] stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\r\n"];
}

- (BOOL) isCommandLine:(NSString*)line {
    if (line.length == 0) {
        return YES;
    }
    
    NSRange indexOfComment = [line rangeOfString:@"//"];
    NSRange indexOfCollon = [line rangeOfString:@":"];

    return  indexOfComment.location == 0 && indexOfCollon.location == NSNotFound;
}

- (NSString*)get:(NSString*)name {
    NSString* result = [strings objectForKey:name];

    return result;
}

- (int)getInteger:(NSString*)name {
    NSString* result = [strings objectForKey:name];

    return [result intValue];
}

- (int)getBoolean:(NSString*)name {
    NSString* result = [strings objectForKey:name];

    return [result isEqualToString:@"true"];
}

- (BOOL)isRightToLeft {
    NSString* value = [strings objectForKey:@"Direction"];

    return [value isEqualToString:@"rtl"];
}

- (BOOL)usePersianDigits {
    NSString* value = [strings objectForKey:@"UsePersianDigits"];

    return [value isEqualToString:@"true"];
}

- (BOOL)shouldChangeNavigationControllerTitleFont {
    NSString* value = [strings objectForKey:@"ChangeNavigationControllerTitleFont"];

    return [value isEqualToString:@"true"];
}

- (BOOL)shouldChangeTabItemTitleFont {
    NSString* value = [strings objectForKey:@"ChangeTabBarItemTitleFont"];

    return [value isEqualToString:@"true"];
}

- (float)getTabItemTitleFontSize {
    NSString* value = [strings objectForKey:@"TabBarItemTitleFontSize"];

    return [value intValue];
}
@end
