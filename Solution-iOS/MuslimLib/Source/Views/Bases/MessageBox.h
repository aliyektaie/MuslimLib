//
//  MessageBox.h
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/29/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ MESSAGEBOX_ACTION)();
typedef void (^ MESSAGEBOX_ASK_ACTION)(BOOL result);

@interface MessageBox : NSObject <UIAlertViewDelegate>
+ (void)show:(NSString*)message withTitle:(NSString*)title;
- (void)show:(NSString*)message withTitle:(NSString*)title withAction:(MESSAGEBOX_ACTION)action;
- (void)askYesNo:(NSString*)message withTitle:(NSString*)title withAction:(MESSAGEBOX_ASK_ACTION)action;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
