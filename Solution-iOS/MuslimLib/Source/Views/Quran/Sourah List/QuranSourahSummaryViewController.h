//
//  QuranSourahSummaryViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"
#import "QuranSourahInfo.h"

@interface QuranSourahSummaryViewController : BaseViewController <UIWebViewDelegate>

+ (QuranSourahSummaryViewController*)create:(QuranSourahInfo*)model;

@property (strong, nonatomic) QuranSourahInfo* sourahInfo;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
