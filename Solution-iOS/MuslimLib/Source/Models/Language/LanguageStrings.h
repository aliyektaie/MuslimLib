//
//  LanguageStrings.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define L(x) [[LanguageStrings instance] get:x]

@interface LanguageStrings : NSObject

+ (LanguageStrings*) instance;
- (instancetype)init;
- (NSString*)get:(NSString*)name;
- (int)getInteger:(NSString*)name;
- (int)getBoolean:(NSString*)name;
- (BOOL)isRightToLeft;
- (BOOL)shouldChangeNavigationControllerTitleFont;
- (BOOL)shouldChangeTabItemTitleFont;
- (float)getTabItemTitleFontSize;
- (BOOL)usePersianDigits;
+ (void)invalidate;

@property (strong, nonatomic) NSString* name;

@end
