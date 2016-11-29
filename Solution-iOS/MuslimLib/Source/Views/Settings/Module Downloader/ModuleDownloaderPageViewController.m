//
//  ModuleDownloaderPageViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 10/12/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "ModuleDownloaderPageViewController.h"
#import "Utils.h"
#import "LanguageStrings.h"
#import "Theme.h"

@interface ModuleDownloaderPageViewController ()

@end

@implementation ModuleDownloaderPageViewController {
    MODULE_DOWNLOADED_ACTION successAction;
    MODULE_DOWNLOADED_ACTION failureAction;
}

+ (ModuleDownloaderPageViewController*)create:(NSString*)module {
    ModuleDownloaderPageViewController* result = (ModuleDownloaderPageViewController*)[Utils createViewControllerFromStoryboard:@"ModuleDownloaderPageViewController"];
    
    result.module = module;
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [[LanguageStrings instance] get:[NSString stringWithFormat:@"ModuleDownloader/Title/%@", self.module]];
    self.lblDescription.text = [[LanguageStrings instance] get:[NSString stringWithFormat:@"ModuleDownloader/Description/%@", self.module]];
    self.lblDescription.backgroundColor = [UIColor clearColor];
    self.lblDescription.font = [Utils createDefaultFont:16];
    self.lblDescription.textAlignment = [Utils getDefaultTextAlignment];
//    self.lblDescription.textColor = [Theme instance].navigationBarTintColor;
    
    self.cmdCancel.title = L(@"Cancel");
    
    [self.cmdCancel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [Utils createDefaultFont:16], NSFontAttributeName,
                                           nil]
                                 forState:UIControlStateNormal];

}

- (void)setModuleDownloadedAction:(MODULE_DOWNLOADED_ACTION)action {
    successAction = action;
}

- (void)setModuleDownloadFailureAction:(MODULE_DOWNLOADED_ACTION)action {
    failureAction = action;
}

- (BOOL)hasSidebarButton {
    return NO;
}

- (UIColor*)getBackgroundTopColor {
    return  [[Theme instance] lightPageGradientTopColor];
}

- (UIColor*)getBackgroundBottomColor {
    return  [[Theme instance] lightPageGradientBottomColor];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        failureAction();
    }];
}
@end
