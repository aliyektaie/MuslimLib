//
//  QuranSourahSummaryViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranSourahSummaryViewController.h"
#import "Utils.h"
#import "LanguageStrings.h"
#import "MuslimLib.h"
#import "NSString+Contains.h"

@interface QuranSourahSummaryViewController ()

@end

@implementation QuranSourahSummaryViewController

+ (QuranSourahSummaryViewController*)create:(QuranSourahInfo*)model {
    QuranSourahSummaryViewController* vc = (QuranSourahSummaryViewController*)[Utils createViewControllerFromStoryboard:@"QuranSourahSummaryViewController"];

    vc.sourahInfo = model;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString* title = L(@"QuranTab/SourahList/Details/Title");
    title = [title stringByReplacingOccurrencesOfString:@"$englishName" withString:self.sourahInfo.titleEnglish];
    title = [title stringByReplacingOccurrencesOfString:@"$arabicName" withString:self.sourahInfo.titleArabic];
    self.title = title;

    self.webView.delegate = self;
    [self.webView loadHTMLString:[[MuslimLib instance] getSourahArticle:self.sourahInfo] baseURL:nil];

    self.webView.backgroundColor = [UIColor whiteColor];
    for (UIView* subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* url = [request.URL absoluteString];

    if ([url contains:@"http://"] || [url contains:@"https://"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

@end
