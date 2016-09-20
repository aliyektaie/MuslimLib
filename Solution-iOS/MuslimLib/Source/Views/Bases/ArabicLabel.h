//
//  ArabicLabel.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArabicLabel : UIView

@property (strong, nonatomic) NSString* text;

+ (int)getHeightForText:(NSString*)text inWidth:(int)width;
+ (void)invalidateQuranFont;

@end

@interface TempFloatContainer : NSObject

@property (assign, nonatomic) CGFloat value;

@end
