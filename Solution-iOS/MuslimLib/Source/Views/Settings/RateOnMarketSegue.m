//
//  RateOnMarketSegue.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/11/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "RateOnMarketSegue.h"
#import "MessageBox.h"
#import "LanguageStrings.h"

@implementation RateOnMarketSegue

- (void)perform {
    NSURL* url = [self getURL];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (NSURL*)getURL {
    int YOUR_APP_STORE_ID = 1068583572;
    
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
    
    return [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, YOUR_APP_STORE_ID]]; // Would contain the right link
}

@end
