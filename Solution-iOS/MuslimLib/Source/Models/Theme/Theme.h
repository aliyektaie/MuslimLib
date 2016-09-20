//
//  Theme.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/5/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Theme : NSObject

+ (Theme*) instance;

- (void) invalidate;

@property (strong, nonatomic) UIColor* defaultPageGradientTopColor;
@property (strong, nonatomic) UIColor* defaultPageGradientBottomColor;
@property (strong, nonatomic) UIColor* defaultSidebarGradientTopColor;
@property (strong, nonatomic) UIColor* defaultSidebarGradientBottomColor;
@property (strong, nonatomic) UIColor* lightPageGradientTopColor;
@property (strong, nonatomic) UIColor* lightPageGradientBottomColor;
@property (strong, nonatomic) UIColor* navigationBarTintColor;
@property (strong, nonatomic) UIColor* sidebarItemTextColor;
@property (strong, nonatomic) UIColor* defaultTextColor;
@property (strong, nonatomic) UIColor* lightTextColor;
@property (strong, nonatomic) UIColor* defaultFlashCardTextColor;
@property (strong, nonatomic) UIColor* sidebarMyAccountBackgroundColor;
@property (strong, nonatomic) UIColor* editTextColor;

@end
