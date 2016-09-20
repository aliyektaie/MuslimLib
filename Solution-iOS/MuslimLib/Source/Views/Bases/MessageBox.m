//
//  MessageBox.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/29/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "MessageBox.h"
#import <UIKit/UIKit.h>
#import "LanguageStrings.h"

@interface MessageBox() {
    MESSAGEBOX_ACTION finishAction;
    MESSAGEBOX_ASK_ACTION finishAskAction;
}

@end

@implementation MessageBox

+ (void)show:(NSString*)message withTitle:(NSString*)title {
    UIAlertView* view = [[UIAlertView alloc] init];
    view.title = title;
    view.message = message;
    [view addButtonWithTitle:[[LanguageStrings instance] get:@"Ok"]];
    
    [view show];
}

- (void)show:(NSString*)message withTitle:(NSString*)title withAction:(MESSAGEBOX_ACTION)action {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:[[LanguageStrings instance] get:@"Ok"]
                                          otherButtonTitles:nil];
    

    finishAction = action;
    finishAskAction = nil;
    
    [view show];
}

- (void)askYesNo:(NSString*)message withTitle:(NSString*)title withAction:(MESSAGEBOX_ASK_ACTION)action {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:[[LanguageStrings instance] get:@"No"]
                                         otherButtonTitles:[[LanguageStrings instance] get:@"Yes"], nil];
    
    
    finishAction = nil;
    finishAskAction = action;
    
    [view show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (finishAction != nil) {
        finishAction();
    }
    
    if (finishAskAction != nil) {
        finishAskAction(buttonIndex == 1);
    }
}
@end
