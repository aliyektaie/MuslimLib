//
//  Theme.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/5/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "Theme.h"
#import "Utils.h"
#import "Settings.h"
#import "NSString+Contains.h"

@implementation Theme

@synthesize defaultPageGradientTopColor = _defaultPageGradientTopColor;
@synthesize defaultPageGradientBottomColor = _defaultPageGradientBottomColor;
@synthesize defaultSidebarGradientTopColor = _defaultSidebarGradientTopColor;
@synthesize defaultSidebarGradientBottomColor = _defaultSidebarGradientBottomColor;
@synthesize lightPageGradientTopColor = _lightPageGradientTopColor;
@synthesize lightPageGradientBottomColor = _lightPageGradientBottomColor;
@synthesize navigationBarTintColor = _navigationBarTintColor;
@synthesize sidebarItemTextColor = _sidebarItemTextColor;
@synthesize defaultTextColor = _defaultTextColor;
@synthesize lightTextColor = _lightTextColor;
@synthesize defaultFlashCardTextColor = _defaultFlashCardTextColor;
@synthesize sidebarMyAccountBackgroundColor = _sidebarMyAccountBackgroundColor;


static Theme* _sharedInstance = nil;

+ (Theme*) instance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[Theme alloc] init];
    }

    return _sharedInstance;
}

- (instancetype) init {
    self = [super init];

    if (self) {
        NSString* path = [Settings getThemeFileName];
        NSArray* lines = [Utils readTextFileLinesFromResource:path];

        _defaultPageGradientTopColor = [self getColor:lines name: @"DefaultPageGradientTopColor"];
        _defaultPageGradientBottomColor = [self getColor:lines name: @"DefaultPageGradientBottomColor"];
        _lightPageGradientTopColor = [self getColor:lines name: @"LightPageGradientTopColor"];
        _lightPageGradientBottomColor = [self getColor:lines name: @"LightPageGradientBottomColor"];
        _navigationBarTintColor = [self getColor:lines name: @"NavigationBarTintColor"];
        _defaultSidebarGradientTopColor = [self getColor:lines name: @"DefaultSidebarGradientTopColor"];
        _defaultSidebarGradientBottomColor = [self getColor:lines name: @"DefaultSidebarGradientBottomColor"];
        _sidebarItemTextColor = [self getColor:lines name: @"SidebarItemTextColor"];
        _defaultTextColor = [self getColor:lines name: @"DefaultTextColor"];
        _lightTextColor = [self getColor:lines name: @"LightTextColor"];
        _defaultFlashCardTextColor = [self getColor:lines name: @"DefaultFlashCardTextColor"];
        _sidebarMyAccountBackgroundColor = [self getColor:lines name: @"SidebarMyAccountBackgroundColor"];
        _editTextColor = [Utils colorFromRed:255 Green:255 Blue:255];
    }

    return self;
}

- (UIColor*)getColor:(NSArray*)lines name:(NSString*)name {
    UIColor* result = [UIColor redColor];

    for (int i = 0; i < lines.count; i++) {
        NSString* line = [lines objectAtIndex:i];
        if ([line contains:name]) {
            NSString* value = [self getString:line];
            if ([value contains:@","]) {
                value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSArray* parts = [value componentsSeparatedByString:@","];

                int red = [((NSString*)[parts objectAtIndex:0]) intValue];
                int green = [((NSString*)[parts objectAtIndex:1]) intValue];
                int blue = [((NSString*)[parts objectAtIndex:2]) intValue];

                result = [Utils colorFromRed:red Green:green Blue:blue];
            } else {
                unsigned hex = 0;
                NSScanner *scanner = [NSScanner scannerWithString:value];

                [scanner setScanLocation:0];
                [scanner scanHexInt:&hex];

                int top = (int)hex;

                int red = (top & 0x00ff0000) >> 16;
                int green = (top & 0x0000ff00) >> 8;
                int blue = (top & 0x000000ff);

                result = [Utils colorFromRed:red Green:green Blue:blue];
            }

            break;
        }
    }


    return result;
}

-(NSString*) getString:(NSString*)line {
    NSRange index = [line rangeOfString:@":"];

    return [line substringFromIndex:(index.location + 1)];
}


- (void)invalidate {
    _sharedInstance = nil;
}

@end
